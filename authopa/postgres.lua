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

    kong.log.info("Fetched roles: ", table.concat(roles, ", "))
    return roles

end
return module
