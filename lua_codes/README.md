## kong-plugin-opa-poc

- generate sample user data using python -in json format and store in redis and postgresql
- lua code block imports redis and postgresql modules, takes user email as input from cli, tries to fetch data from redis frist and if not present, fetches data from postgresql
    > - sudo luarocks install redis-lua
    > - sudo luarocks install lua-cjson
    > - sudo luarocks install luasql-postgres

- used docker-compose for postgres. 
    >  Get the PostgreSQL container IP address
    > - postgres_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres_container)
    > - Get the PostgreSQL username and password from environment variables
    > - postgres_user=$(docker exec postgres_container env | grep POSTGRES_USER | cut -d '=' -f2)
    > - postgres_password=$(docker exec postgres_container env | grep POSTGRES_PASSWORD | cut -d '=' -f2)
    > - echo "PostgreSQL Host: $postgres_ip" 
    > - echo "PostgreSQL Username: $postgres_user"
    > - echo "PostgreSQL Password: $postgres_password"


##### Postgresql data format help
To convert this json into sql (to store and retrieve from postgreql) : insert statements also create corresponding sql schema

###### **Table Schema:**

``` 
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE user_roles (
    user_id INTEGER REFERENCES users(id),
    role VARCHAR(50) NOT NULL,
    PRIMARY KEY (user_id, role)
);
```
###### **Insert statements:**

```
-- Insert users
INSERT INTO users (email, name) VALUES ('Wagezawulico.fgfboyuvr7@randommail.org', 'Wagezawulico');
INSERT INTO users (email, name) VALUES ('Ciguruhumoxavezuviwu.4lgipcs5z7@testmail.com', 'Ciguruhumoxavezuviwu');
etc

-- Insert user roles
INSERT INTO user_roles (user_id, role) VALUES (1, 'User');
INSERT INTO user_roles (user_id, role) VALUES (2, 'Admin');
INSERT INTO user_roles (user_id, role) VALUES (2, 'Guest');
INSERT INTO user_roles (user_id, role) VALUES (2, 'Moderator');
INSERT INTO user_roles (user_id, role) VALUES (2, 'User');
etc
```




