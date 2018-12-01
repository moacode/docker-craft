#!/bin/bash

printf "UID=$(id -u)\nGID=$(id -g)" > .env && docker-compose up -d