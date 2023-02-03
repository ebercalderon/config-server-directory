#!/bin/bash

microservices=("config-server" "eureka-server" "gateway" "customer-microservice" "movement-microservice" "passive-microservice")

# Compile JARs for each microservice
for microservice in "${microservices[@]}"; do
  cd ..
  cd $microservice
  mvn clean install
done

# Start the Docker containers
docker-compose up --build