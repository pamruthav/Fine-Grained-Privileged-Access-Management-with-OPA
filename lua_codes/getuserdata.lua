local redis = require("redis")
local json = require("cjson")
local pg = require ("luasql.postgres")


local client = redis.connect("localhost", 6379)


-- local email = "Zuxapezebafojozuqu.jzi8g7ath2@testmail.com"

-- Read email from user input
print("Enter email:")
local email = io.read()


-- Retrieve JSON data from Redis
local json_data = client:get("userdata")

-- Parse JSON data into a Lua table
local users = json.decode(json_data)

-- Function to find user data by email
function find_user_by_email(data, email)
    local user_json = client:get("user:" .. email)

    if user_json then
        -- Parse JSON data into a Lua table
        local user_data = json.decode(user_json)
        return user_data
    else
        return nil
    end
    -- for _, user in ipairs(data) do
    --     if user.email == email then
    --         return user.roles
    --     end
    -- end
    -- return nil
end

-- Find user data based on the input email in Redis
local user = find_user_by_email(users, email)

-------------------

-- If user not found in Redis, fetch data from PostgreSQL
if not user then
    print("Fetching data from PostgreSQL")  -- Add this print statement

    local env = pg.postgres()
    local con = env:connect("postgres", "postgres", "password", "172.22.0.3")  -- Replace with your PostgreSQL connection details

    -- local query = string.format("SELECT * FROM users WHERE email='%s'", email)
    local query = string.format([[
        SELECT ur.role
        FROM users u
        JOIN user_roles ur ON u.id = ur.user_id
        WHERE u.email = '%s'
      ]], email)
     
    local cursor = con:execute(query)
    local row = cursor:fetch({}, "a")

    user = { roles = {} }  -- Initialize user with an empty roles table

    while row do
        table.insert(user.roles, row.role) -- Add each role to the user's roles table
        row = cursor:fetch(row, "a") -- Fetch next row
    end

    if #user.roles == 0 then
        print("User not found in pg")
        user = nil
    else
            -- Cache the user data in Redis with a TTL of 10 seconds
            local userKey = "user:" .. email
            local userJSON = json.encode({
                email = email,  
                name = user.name,  -- Make sure you have 'name' available in the 'user' object
                roles = user.roles
            })
            client:setex(userKey, 30, userJSON)  -- Set the data with a TTL of 10 seconds
           
    cursor:close()
    con:close()
    env:close()
   
end

end
---------------------


-- Print user data if found
if user then
    print("User info:")
    for key, value in pairs(user) do
        if key == "roles" then
            local roles_str = table.concat(value, ', ')
            print(key, ":", roles_str)
        else
            print(key, ":", value)
        end
    end

else
    print("User not found")
end