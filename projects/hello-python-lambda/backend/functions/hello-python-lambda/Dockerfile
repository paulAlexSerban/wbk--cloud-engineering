FROM python:3.12.9-bullseye
LABEL maintainer="paulserban.eu"

RUN apt-get update \
    && apt-get install -y zip \
    && apt-get clean

WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
RUN zip -rj /app/function.zip ./src/*
RUN mkdir -p /package
CMD ["cp", "/app/function.zip", "/package/function.zip"]