#!/bin/bash

rm -f chameleon-vision.jar
latest_chameleon_url=$(curl -s https://api.github.com/repos/chameleon-vision/chameleon-vision/releases/latest | jq -r ".assets[] | select(.name | test(\".jar\")) | .browser_download_url")
wget ${latest_chameleon_url} -O chameleon-vision.jar

echo "Chameleon Vision is ready for use! run \"sudo java -jar chameleon-vision.jar\" to start!"
