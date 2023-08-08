docker stop kong-demo
docker rm kong-demo

docker run -d --name kong-demo \
  -p "8000-8001:8000-8001" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
  -e "KONG_DATABASE=off" \
  -e "KONG_LOG_LEVEL=debug" \
  -e "KONG_PLUGINS=bundled,auth-opa" \
  kong-demo

sleep 8

# Confiure kong
curl -X POST http://localhost:8001/config -F config=@config.yaml