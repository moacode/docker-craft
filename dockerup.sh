#!/bin/bash

if [ ! -f ./.env ]; then
    printf "UID=$(id -u)\nGID=$(id -g)" > .env
elif ! grep -q "UID" .env; then
    printf "\n\n# Special UID/GID variables for docker containers\nUID=$(id -u)\nGID=$(id -g)" >> .env
else
	sed -i '' -e 's@\(UID=\)\([0-9]*\)@\1'$(id -u)'@g' .env\
	&& sed -i '' -e 's@\(GID=\)\([0-9]*\)@\1'$(id -g)'@g' .env
fi

docker-compose up -d