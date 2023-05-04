#!/bin/sh
echo "init.sh"
echo "---------------------------------------------------------------------------------------------"
echo "update / upgrade"

sudo apt-add-repository ppa:fish-shell/release-3 
sudo apt -qq update -y
sudo apt -qq upgrade -y

echo "Installing fish"
sudo apt install fish -y
