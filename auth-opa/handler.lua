local BasePlugin = require "kong.plugins.base_plugin"
local config = require("plugin_config") 
local redis = require("resty.redis")
local cjson = require("cjson")
local pg = require("luasql.postgres")

local auth-opa = BasePlugin:extend()

function auth-opa:new()
 auth-opa.super.new(self, "auth-opa")
end

function auth-opa:access(plugin_config)
 auth-opa.super.access(self)

  local redis_host = "localhost"
  local redis_port = 6379

  local email = ngx.req.get_headers()["X-User-Email"] 

  if email then
    local redis_conn = redis:new()
    local ok, err = redis_conn:connect(redis_host, redis_port)

    if ok then
      local user_json = redis_conn:get("user:" .. email)

      if user_json then
        local user_data = cjson.decode(user_json)
        -- Apply your desired logic with user_data here
        
        -- For example, you could modify the response headers or body
        ngx.header["X-User-Data"] = cjson.encode(user_data)
      else
        local env = pg.postgres()
        local con = env:connect("postgres", plugin_config.postgres.user, plugin_config.postgres.password, plugin_config.postgres.host)

        local query = string.format([[
            SELECT ur.role
            FROM users u
            JOIN user_roles ur ON u.id = ur.user_id
            WHERE u.email = '%s'
          ]], email)
        
        local cursor = con:execute(query)
        local row = cursor:fetch({}, "a")

        local user = { roles = {} }

        while row do
          table.insert(user.roles, row.role)
          row = cursor:fetch(row, "a")
        end

        if #user.roles > 0 then
          local user_key = "user:" .. email
          local user_json = cjson.encode({
            email = email,
            roles = user.roles
          })
          
          redis_conn:setex(user_key, plugin_config.redis_ttl, user_json)
          cursor:close()
        con:close()
      end
      redis_conn:close()
    end
  end
 auth-opa.PRIORITY = 1000
 auth-opa.VERSION = "0.1.0"
 auth-opa.SCHEMA = require("kong.plugins.auth-opa.schema")
 
 return auth-opa         

