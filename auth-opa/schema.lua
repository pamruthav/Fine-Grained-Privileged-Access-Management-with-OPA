local plugin = require "kong.plugins.auth-opa.plugin"

local schema = {
  name = plugin.name,
  fields = {
    {
      name = "redis_host",
      type = "string",
      default = "localhost"
    },
    {
      name = "redis_port",
      type = "number",
      default = 6379
    },
    {
      name = "postgres_user",
      type = "string",
      required = true
    },
    {
      name = "postgres_password",
      type = "string",
      required = true
    },
    {
      name = "postgres_host",
      type = "string",
      required = true
    },
    {
      name = "postgres_port",
      type = "number",
      default = 5432
    },
    {
      name = "redis_ttl",
      type = "number",
      default = 10
    }
  }
}

return schema