#!/usr/bin/env bash
DIRECTORY=UserManager

case "$OSTYPE" in
  darwin*)
    echo "OSX detected"
    command -v brew >/dev/null 2>&1 || { echo >&2 "Installing Homebrew Now"; \
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }
    brew install docker docker-compose
  ;;
  linux*)
    echo "Linux detected"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    test -d ~/.linuxbrew && PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
    test -d /home/linuxbrew/.linuxbrew && PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"
    test -r ~/.bash_profile && echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.bash_profile
    echo "export PATH='$(brew --prefix)/bin:$(brew --prefix)/sbin'":'"$PATH"' >>~/.profile
    brew install docker docker-compose
  ;;
  msys*)    echo "WINDOWS" ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

if [ ! -d "$DIRECTORY" ]; then
  git clone git@github.com:BolajiOlajide/$DIRECTORY.git
fi

cd $DIRECTORY

[ -e Dockerfile ] && rm Dockerfile

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

[ -e docker-compose.yml ] && rm docker-compose.yml

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
