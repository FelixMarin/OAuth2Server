#!/usr/bin/env bash

echo "=== Arrancando OAuth2Server en modo DEV ==="

export SPRING_PROFILES_ACTIVE=dev

# Ejecutar la aplicación (sin redirección a /data)
java -Dspring.profiles.active=dev -Dserver.address=0.0.0.0 -jar /app/app.jar
