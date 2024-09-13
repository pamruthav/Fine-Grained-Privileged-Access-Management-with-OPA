<<<<<<< HEAD
FROM kong/kong-gateway:latest
=======
FROM kong/kong-gateway:3.2.2.1

>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd

USER root
RUN apt update -y 
RUN apt install git unzip build-essential libpq-dev -y

<<<<<<< HEAD
=======
# RUN luarocks install luasql-postgres PGSQL_DIR=/usr/include/postgresql/
>>>>>>> b24d1d77c78659ffe1fd7978439dcc0a8a8428bd
RUN luarocks install luasql-postgres PGSQL_INCDIR=/usr/include/postgresql PGSQL_LIBDIR=/usr/lib/postgresql
RUN luarocks install lua-cjson
RUN luarocks install lua-resty-redis
RUN mkdir -p /usr/local/share/lua/5.1/kong/plugins/authopa

COPY ./authopa /usr/local/share/lua/5.1/kong/plugins/authopa
             