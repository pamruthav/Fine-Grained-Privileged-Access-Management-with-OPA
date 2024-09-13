local http = require "resty.http"
local cjson = require "cjson.safe"

local M = {}

function M.checkAccess(userRoles, requestPath, requestMethod, opaServiceUrl)
    local opa_request_data = {
        input = {
            userRoles = userRoles,
            requestPath = requestPath,
            requestMethod = requestMethod
        }
    }
   
    local httpc = http.new()
    local res, err = httpc:request_uri(opaServiceUrl, {
        method = "POST",
        body = cjson.encode(opa_request_data),
        headers = {
            ["Content-Type"] = "application/json"
        }
    })

    if not res then
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

    return isAllowedByOPA
end

return M
