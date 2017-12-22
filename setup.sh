#!/usr/bin/env bash
touch Dockerfile

echo "
FROM node:latest
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app
EXPOSE 3000
CMD [ 'npm', 'start' ]
" >> Dockerfile

DIRECTORY=UserManager

if [ ! -d "$DIRECTORY" ]; then
  git clone git@github.com:BolajiOlajide/$DIRECTORY.git
fi

if type node > /dev/null
  then
    echo ""
    echo "node is installed, skipping..."
  else
    brew install node
    # sudo apt-get update
    # sudo apt-get install nodejs
    # sudo apt-get install npm
  fi

cd $DIRECTORY

npm install

npm start
