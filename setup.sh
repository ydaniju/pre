#!/usr/bin/env bash
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
  fi

cd $DIRECTORY

npm install

npm start
