#!/bin/bash

rm chameleon-vision.jar
curl -s https://api.github.com/repos/chameleon-vision/chameleon-vision/releases/latest | grep "browser_download_url.*jar" | cut -d : -f 2,3 | tr -d '"' | wget -qi - -O chameleon-vision.jar

echo "Chameleon Vision is ready for use! run \"sudo java -jar chameleon-vision.jar\" to start!"
