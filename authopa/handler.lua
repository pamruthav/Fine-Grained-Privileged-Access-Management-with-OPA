local http = require "resty.http"
local get_header = kong.request.get_header
local requestPath = kong.request.get_path
local requestMethod = kong.request.get_method
local postgres = require("kong.plugins.authopa.postgres")
local redis = require("kong.plugins.authopa.redis")
local opa = require("kong.plugins.authopa.opa")
local cjson = require "cjson.safe"
local plugin = {
  VERSION = "0.1",
  PRIORITY = 10
}
<<<<<<< HEAD
local opa_service_url="http://opa:8181/v1/data/authopa/allow"

function plugin:access(plugin_config)
    local email = get_header("X-Consumer-Email")
    local userRoles

    if email then
      local res = redis.performRedisLookup(email, plugin_config)

      if not res then
        kong.log.info("Fetching roles from PostgreSQL for email: ", email)
        userRoles = postgres.fetchRolesFromPostgres(email, plugin_config)

        if userRoles and #userRoles > 0 then
          kong.log.info("Caching user roles in Redis")
          redis.cacheRolesInRedis(email, userRoles, plugin_config)
        end
      else
        if res.roles then
          userRoles = res.roles
        else
          kong.log.err("Redis data did not contain roles")
          kong.response.exit(500, { message = "Invalid data in Redis" })
        end
      end
    end

    local path = requestPath()
    local method = requestMethod()

    local isAllowedByOPA = opa.checkAccess(userRoles, path, method, opa_service_url)

    if not isAllowedByOPA then
      kong.response.exit(403, { message = "Access denied" })
    end
  end

  
return plugin
=======

-- local opa_service_url = "https://eosh985myaoqy9.m.pipedream.net"
local opa_service_url="http://opa:8181/v1/data/authopa/allow"



function plugin:access(plugin_config)
  local email = get_header("X-Consumer-Email")
  local userRoles
  if email then
    local res = redis.performRedisLookup(email, plugin_config)
    if res == ngx.null then
      kong.log.info("Fetching roles from PostgreSQL for email: ", email)
         userRoles = postgres.fetchRolesFromPostgres(email, plugin_config)
        
      if userRoles and #userRoles > 0 then
          kong.log.info("Caching user roles in Redis")
          redis.cacheRolesInRedis(email, userRoles, plugin_config)
      end
    end
  end
  local path=requestPath()
  local method=requestMethod()
  local isAllowedByOPA = opa.checkAccess(userRoles, path, method, opa_service_url)

  if not isAllowedByOPA then
    kong.response.exit(403, { message = "Access denied" })
  end
end




    -- Prepare data to send to OPA service
  --   local opa_request_data = {
  --     userRoles = userRoles,
  --     requestPath = requestPath,
  --     requestMethod = requestMethod
  --   }

  --   local httpc = http.new()
  --   local res, err = httpc:request_uri(opa_service_url, {
  --     method = "POST",
  --     body = cjson.encode(opa_request_data),
  --     headers = {
  --       ["Content-Type"] = "application/json"
  --     }
  --   })

  --   if not res then
  --     kong.log.err("Failed to make OPA request: ", err)
  --     return
  --   end

  --   local opa_response = cjson.decode(res.body)
  --   local isAllowedByOPA = opa_response.result

  --   if not isAllowedByOPA then
  --     kong.response.exit(403, { message = "Access denied" })
  --   end
  -- end

         
          -- local requestPath = kong.request.get_path()
          -- local requestMethod = kong.request.get_method()
          -- -- if not opa.verifyAccess(userRoles, requestPath, requestMethod) then
          -- local isAllowed = opa.verifyAccess(userRoles, requestPath, requestMethod)
          -- if not isAllowed then
          --   kong.log.info(" user does not have access")
          --   kong.response.exit(403, "Access denied")
          -- end
      




return plugin
>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
