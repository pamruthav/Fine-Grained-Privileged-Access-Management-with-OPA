local typedefs = require "kong.db.schema.typedefs"

local PLUGIN_NAME = "auth-opa"

local schema = {
  name = PLUGIN_NAME,
  fields = {
    { protocols = typedefs.protocols_http },
    {
      config = {
        type = "record",
        fields = {
          {
            redis = {
              type = "record",
              required = true,
              fields = {
                {
                  host = typedefs.host {
                    default = "localhost",
                  },
                },
                {
                  port = {
                    type = "number",
                    default = 6379,
                    between = {
                      0,
                      65534
                    },
                  },
                },
                {
                  ttl = {
                    type = "number",
                    default = 10,
                  },
                },
              },
            }
          },
          {
            postgres = {
              type = "record",
              required = true,
              fields = {
                {
                  host = typedefs.host {
                    default = "localhost",
                  },
                },
                {
                  port = {
                    type = "number",
                    default = 5435,
                    between = {
                      0,
                      65534
                    },
                  },
                },
                {
                  user = {
                    type = "string",
                    default = "postgres",
                  },
                },
                {
                  password = {
                    type = "string",
                    default = "password",
                  },
                },
              },
            }
          },
        },
      },
    },
  },
}

return schema