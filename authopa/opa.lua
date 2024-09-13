local http = require "resty.http"
local cjson = require "cjson.safe"

local M = {}

function M.checkAccess(userRoles, requestPath, requestMethod, opaServiceUrl)
    local opa_request_data = {
<<<<<<< HEAD
        input = {
            userRoles = userRoles,
            requestPath = requestPath,
            requestMethod = requestMethod
        }
    }
   
=======
            input={
            userRoles = userRoles,
            requestPath = requestPath,
            requestMethod = requestMethod
            }
        }

    print(cjson.encode(opa_request_data))
>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
    local httpc = http.new()
    local res, err = httpc:request_uri(opaServiceUrl, {
        method = "POST",
        body = cjson.encode(opa_request_data),
        headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if not res then
<<<<<<< HEAD
        kong.log.err("Failed to make OPA request: ", err)
        return false
    end


    local opa_response = cjson.decode(res.body)
    if not opa_response then
        kong.log.err("Failed to decode OPA response JSON")
        return false
    end

    local isAllowedByOPA = opa_response.result
    kong.log.info("Is Allowed by OPA: ", isAllowedByOPA)
=======
        ngx.log(ngx.ERR, "Failed to make OPA request: ", err)
        return false
    else
        kong.log.info("successfully sent request to OPA ")
    end 

    local opa_response = cjson.decode(res.body)
    if not opa_response then
        ngx.log(ngx.ERR, "Failed to decode OPA response JSON")
        return false
    end
    local isAllowedByOPA = opa_response.result
    kong.log.info("\n \n OPA response body:", res.body, "\n\n\n" )
    kong.log.info("\n \n isAllowedByOPA:", isAllowedByOPA)

>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd

    return isAllowedByOPA
end

return M
<<<<<<< HEAD
=======


-- local opa_policy = {
--     {
--         path = "/demo",
--         method = "GET",
--         allowed_roles = {"Admin", "User", "Moderator"}
--     }
--     -- Add more policy rules as needed
-- }

-- function module.verifyAccess(userRoles, requestPath, requestMethod)
--     for _, rule in ipairs(opa_policy) do
--         if rule.path == requestPath and rule.method == requestMethod then
--             kong.log.info("Matching policy rule found for path: " .. rule.path .. " and method: " .. rule.method)
--             for _, allowedRole in ipairs(rule.allowed_roles) do
--                 kong.log.info("Checking access for "..allowedRole)
--                 if userRoles[allowedRole] then
--                     kong.log.info("Role " .. allowedRole .. " found in user roles. Access granted.")
--                     return true
--                 end
--             end
--             kong.log.info("No matching allowed roles for user roles: " ,userRoles)
--             return false  -- If none of the allowed roles matched
--         end
--     end
--     kong.log.info("No matching policy rules for path: " .. requestPath .. " and method: " .. requestMethod)
--     return false  -- If no rule matched the request path and method
-- end

-- return module
>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
