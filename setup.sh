#!/usr/bin/env bash
DIRECTORY=UserManager

if [ ! -d "$DIRECTORY" ]; then
  git clone git@github.com:BolajiOlajide/$DIRECTORY.git
fi

cd $DIRECTORY

rm Dockerfile

touch Dockerfile

echo 'FROM node:latest
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app
EXPOSE 3000
CMD [ "npm", "start" ]
' >> Dockerfile

rm docker-compose.yml

touch docker-compose.yml

echo 'version: "2"
services:
  app:
    container_name: app
    restart: always
    build: .
    ports:
      - "3000:3000"
    links:
      - mongo
    env_file:
      - .env

  mongo:
    container_name: mongo
    image: mongo
    volumes:
      - ./data:/data/db
    ports:
      - "27017:27017"
' >> docker-compose.yml

touch .env

echo 'PORT=3000
DB_URL=mongodb://0.0.0.0:27017
' >> .env

docker-compose up
