#!/bin/bash
# setup script for Chameleon Vision on Raspberry Pi 3 and 4

function is_pi() {
  ARCH=$(dpkg --print-architecture)
  if [ "$ARCH" = "armhf" ] ; then
    echo 0
  else
    echo 1
  fi
}


function is_pione() {
   if grep -q "^Revision\s*:\s*00[0-9a-fA-F][0-9a-fA-F]$" /proc/cpuinfo; then
      echo 0
   elif grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]0[0-36][0-9a-fA-F]$" /proc/cpuinfo ; then
      echo 0
   else
      echo 1
   fi
}

function is_pitwo() {
   if grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]04[0-9a-fA-F]$" /proc/cpuinfo; then
      echo 0
   else
      echo 1
   fi
}

function is_pizero() {
   if grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]0[9cC][0-9a-fA-F]$" /proc/cpuinfo; then
      echo 0
   else
      echo 1
   fi
}

function is_pifour() {
   if grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]11[0-9a-fA-F]$" /proc/cpuinfo; then
      echo 0
   else
      echo 1
   fi
}

function get_pi_type() {
  if [ $(is_pi) ]; then
    if [ $(is_pione) -eq 0 ]; then
      echo 1
    elif [ $(is_pitwo) -eq 0 ]; then
      echo 2
    elif [ $(is_pizero) -eq 0 ]; then
      echo 0
    elif [ $(is_pifour) -eq 0 ]; then
      echo 4
    else
      echo 3
    fi
  else
    echo -1
  fi
}

pi_type=$(get_pi_type)

if [ $pi_type -ne 3 ] && [ $pi_type -ne 4 ]
then
  echo "This script is only for Raspberry Pi 3 and 4!"
  exit 1
else
  echo "Detected Raspberry Pi $pi_type, begginning install."
fi

echo "Checking network connection..."
wget -q --spider http://google.com

if [ $? -ne 0 ]
then
  echo "This script requires an internet connection!"
  exit 1
fi

echo "Preparing your Raspberry Pi for Chameleon Vision, please wait..."
echo "Installing JDK 12..."
wget -q -O - https://download.bell-sw.com/pki/GPG-KEY-bellsoft | sudo apt-key add -
echo "deb [arch=armhf] https://apt.bell-sw.com/ stable main" | sudo tee /etc/apt/sources.list.d/bellsoft.list

sudo apt update
sudo apt install -y bellsoft-java12

echo "Downloading latest Chameleon Vision..."

# for future use...
sudo mkdir -p /usr/share/chameleon-vision

curl -s https://api.github.com/repos/chameleon-vision/chameleon-vision/releases/latest | grep "browser_download_url.*jar" | cut -d : -f 2,3 | tr -d '"' | wget -qi - -O chameleon-vision.jar

echo "Chameleon Vision is ready for use! run 'sudo java -jar chameleon-vision.jar' to start!"
exit 0
