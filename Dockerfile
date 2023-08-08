FROM kong/kong-gateway:3.2.2.1

USER root
RUN mkdir -p /usr/share/lua/5.1/kong/plugins/auth-opa

COPY ./auth-opa /usr/share/lua/5.1/kong/plugins/auth-opa
