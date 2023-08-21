local redis = require "resty.redis"
local cjson = require "cjson.safe"

local module = {}
function module.performRedisLookup(email, plugin_config)
    local redis_conn = redis:new()
    local ok, err = redis_conn:connect(plugin_config.redis.host, plugin_config.redis.port)
    if not ok then
        kong.log.err("!$!Failed to connect to Redis!$!: ", err)
        return
    else
        local res, err = redis_conn:getex(email)
        kong.log.info("Redis result: ", res)
        redis_conn:close()
        return res
    end
end

function module.cacheRolesInRedis(email, userRoles, plugin_config)
    local redis_conn = redis:new()
    local ok, err = redis_conn:connect(plugin_config.redis.host, plugin_config.redis.port)
    if not ok then
        kong.log.err("!$!Failed to connect to Redis!$!: ", err)
        return
    else
        local user_key = email
        local user_json = cjson.encode({email = email, roles = userRoles})

        local set_res, set_err = redis_conn:setex(user_key, plugin_config.redis.ttl, user_json)
        if not set_res then
            kong.log.err("Failed to set data in Redis: ", set_err)
        else
            kong.log.info("Data successfully cached in Redis")
        end

        redis_conn:close()
    end
end

return module
