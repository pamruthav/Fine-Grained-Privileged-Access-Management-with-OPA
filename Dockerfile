FROM kong/kong-gateway:latest

USER root
RUN apt update -y 
RUN apt install git unzip build-essential libpq-dev -y

RUN luarocks install luasql-postgres PGSQL_INCDIR=/usr/include/postgresql PGSQL_LIBDIR=/usr/lib/postgresql
RUN luarocks install lua-cjson
RUN luarocks install lua-resty-redis
RUN mkdir -p /usr/local/share/lua/5.1/kong/plugins/authopa

COPY ./authopa /usr/local/share/lua/5.1/kong/plugins/authopa
             