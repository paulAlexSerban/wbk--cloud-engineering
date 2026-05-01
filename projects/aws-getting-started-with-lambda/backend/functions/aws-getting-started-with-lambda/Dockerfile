FROM node:22.14.0-bullseye-slim

RUN apt-get update \
    && apt-get install -y zip \
    && apt-get clean

WORKDIR /app
COPY . .
RUN yarn install --immutable --immutable-cache --check-cache
RUN zip -rj /app/function.zip ./src/*
RUN mkdir -p /package
CMD ["cp", "/app/function.zip", "/package/function.zip"]