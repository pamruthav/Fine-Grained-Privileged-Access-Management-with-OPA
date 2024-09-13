local pg = require "luasql.postgres"
local env = pg.postgres()
local module = {}
function module.fetchRolesFromPostgres(email, plugin_config)
    local pg_conn =
        env:connect(
        "postgres",
        plugin_config.postgres.user,
        plugin_config.postgres.password,
        plugin_config.postgres.host
    )

    if not pg_conn then
        kong.log.err("Failed to connect to Postgres")
        return
    end

    local query =
        string.format([[
        SELECT r.role_name 
        FROM user_role_mapping urm 
        JOIN roles r ON urm.role_id = r.role_id 
        WHERE urm.email = '%s'
      ]], email)

    local cursor, err = pg_conn:execute(query)
    if not cursor then
        kong.log.err("Error executing query: ", err)
        pg_conn:close()
        return
    end
    local roles = {}
    local row = cursor:fetch({}, "a")

    while row do
        table.insert(roles, row.role_name)
        row = cursor:fetch({}, "a")
    end

    cursor:close()
    pg_conn:close()

<<<<<<< HEAD
    kong.log.info("Fetched roles: ", table.concat(roles, ", "))
    return roles

end
return module
=======
    kong.log.info("fetched roles: ", table.concat(roles, ", "))
    return roles

    -- local user = {roles = {}}

    -- local row = cursor:fetch({}, "a")
    -- cursor:close()
    -- pg_conn:close()
    -- kong.log.info("fetched row", row.roles)
    -- return row.roles
end
return module


-- CREATE TABLE user_data (
--     id SERIAL PRIMARY KEY,
--     email VARCHAR(255) NOT NULL,
--     name VARCHAR(255) NOT NULL,
--     roles JSONB
-- );
-- INSERT INTO user_data (email, name, roles)
-- VALUES                    
--     ('amu@test.com', 'Wagezawulico', '["User"]'),
--     ('Ciguruhumoxavezuviwu.4lgipcs5z7@testmail.com', 'Ciguruhumoxavezuviwu', '["Admin", "Guest", "Moderator", "User"]'),
--     ('Zabumutinolulo.dmwt1pn2pz@testmail.com', 'Zabumutinolulo', '["Moderator", "Admin", "User"]'),
--     ('Wisoqevicocohewila.4pv1rm3o71@mailservice.net', 'Wisoqevicocohewila', '["Admin", "User"]'),
--     ('Xutawimufusiqelo.r1uzurdxpm@testmail.com', 'Xutawimufusiqelo', '["Admin"]');
>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
