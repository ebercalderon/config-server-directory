#!/bin/bash

microservices=("config-server" "eureka-server" "gateway" "customer-microservice" "movement-microservice" "passive-microservice")
cd ..

read -p "Do you want to change the active profile? (Y/N) " answer

if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
  read -p "Enter the value for the active profile (dev, prod, or docker): " value
  if [ "$value" == "dev" ] || [ "$value" == "prod" ] || [ "$value" == "docker" ]; then
    for file in $(find . -name bootstrap.yml); do
      sed -i "5s/active:.*/active: $value/" $file
    done
  else
    echo "Invalid value entered. Exiting script."
    exit 1
  fi
fi

read -p "Do you want to generate the jar files? (Y/N) " answer
if [ "$answer" == "Y" ] || [ "$answer" == "y" ]; then
  # Compile JARs for each microservice
  for microservice in "${microservices[@]}"; do
    cd $microservice
    mvn clean install
    cd ..
  done

  # Start the Docker containers
  docker-compose up --build
else
  echo "Exiting without generating jar files."
fi
