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