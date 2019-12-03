#!/bin/sh
# setup script for Chameleon Vision on Raspberry Pi 3 and 4

is_pi() {
  ARCH=$(dpkg --print-architecture)
  if [ "$ARCH" = "armhf" ] ; then
    return 0
  else
    return 1
  fi
}


is_pione() {
   if grep -q "^Revision\s*:\s*00[0-9a-fA-F][0-9a-fA-F]$" /proc/cpuinfo; then
      return 0
   elif grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]0[0-36][0-9a-fA-F]$" /proc/cpuinfo ; then
      return 0
   else
      return 1
   fi
}

is_pitwo() {
   grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]04[0-9a-fA-F]$" /proc/cpuinfo
   return $?
}

is_pizero() {
   grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]0[9cC][0-9a-fA-F]$" /proc/cpuinfo
   return $?
}

is_pifour() {
   grep -q "^Revision\s*:\s*[ 123][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]11[0-9a-fA-F]$" /proc/cpuinfo
   return $?
}

get_pi_type () {
  if is_pi; then
    if is_pione; then
      return 1
    elif is_pitwo; then
      return 2
    elif is_pizero; then
      return 0
    elif is_pifour; then
      return 4
    else
      return 3
    fi
  else
    return 99
  fi
}

pi_type=$(get_pi_type)

echo "Skipping Pi check..."

#if [ "$pi_type" != "3" ] || [ "$pi_type" != "4" ]
#then
#  echo "This script is only for Raspberry Pi 3 and 4!"
#  exit 1
#fi

echo "Checking network connection..."
wget -q --spider http://google.com

is_online=[ $? -eq 0 ]

if [is_online != 1]
then
  echo "This script requires an internet connection!"
  exit 1
fi

echo "Preparing your Raspberry Pi for Chameleon Vision, please wait..."
echo "Installing JDK 12..."
wget -q -O - https://download.bell-sw.com/pki/GPG-KEY-bellsoft | sudo apt-key add -
echo "deb [arch=armhf] https://apt.bell-sw.com/ stable main" | sudo tee /etc/apt/sources.list.d/bellsoft.list

sudo apt update
sudo apt install bellsoft-java12

echo "Downloading latest Chameleon Vision..."

# for future use...
sudo mkdir -r /usr/share/chameleon-vision

latest_chameleon_url=$(curl -s https://api.github.com/repos/chameleon-vision/chameleon-vision/releases/latest | jq -r ".assets[] | select(.name | test(\".jar\")) | .browser_download_url")

wget ${latest_chameleon_url} -O chameleon-vision.jar

echo "Chameleon Vision is ready for use! run 'sudo java -jar chameleon-vision.jar' to start!"
exit 0
