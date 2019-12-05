#!/bin/bash
# setup script for Chameleon Vision on Jetson Nano

function is_jetson() {
  ARCH=$(dpkg --print-architecture)
  if [ "$ARCH" = "arm64" ] ; then
    echo 0
  else
    echo 1
  fi
}

if [ $(is_jetson) -ne 0 ]
then
  echo "This script is only for Jetson Nano!"
  exit 1
else
  echo "Detected Jetson Nano, begginning install."
fi

echo "Checking network connection..."
wget -q --spider http://google.com

if [ $? -ne 0 ]
then
  echo "This script requires an internet connection!"
  exit 1
fi

echo "Preparing your Jetson Nano for Chameleon Vision, please wait..."
echo "Installing JDK 12..."
wget -q -O - https://download.bell-sw.com/pki/GPG-KEY-bellsoft | sudo apt-key add -
echo "deb [arch=arm64] https://apt.bell-sw.com/ stable main" | sudo tee /etc/apt/sources.list.d/bellsoft.list

sudo apt update
sudo apt install -y bellsoft-java12 jq

echo "Downloading latest Chameleon Vision..."

# for future use...
sudo mkdir -p /usr/share/chameleon-vision

latest_chameleon_url=$(curl -s https://api.github.com/repos/chameleon-vision/chameleon-vision/releases/latest | jq -r ".assets[] | select(.name | test(\".jar\")) | .browser_download_url")

wget ${latest_chameleon_url} -O chameleon-vision.jar

echo "Chameleon Vision is ready for use! run 'sudo java -jar chameleon-vision.jar' to start!"
exit 0
