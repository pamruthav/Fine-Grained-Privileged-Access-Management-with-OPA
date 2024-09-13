docker stop kong-demo
docker rm kong-demo

docker-compose down -v
docker-compose build
docker-compose up 

sleep 20

# Confiure kong
curl -X POST http://localhost:8001/config -F config=@config.yaml

 curl -X PUT http://localhost:8181/v1/policies/mypolicyId -H "Content-Type: application/json" --data-binary @authopa.rego