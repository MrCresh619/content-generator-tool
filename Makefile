.PHONY: dev docker-up docker-down docker-build logs api-logs web-logs clean-data

dev:
    docker compose up

docker-up:
    docker compose up

docker-build:
    docker compose up --build

docker-down:
    docker compose down --remove-orphans

logs:
    docker compose logs -f

api-logs:
    docker compose logs -f api

web-logs:
    docker compose logs -f web

clean-data:
    rm -f data/app.db
    rm -rf data/uploads/*
    rm -rf data/exports/*
    touch data/uploads/.gitkeep
    touch data/exports/.gitkeep
