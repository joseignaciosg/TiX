#!/bin/bash

echo "### TIX instalation script is running ###"
clear

echo "### installing python... ###"
sudo apt-get install -y python-software-properties

echo "### installing kivy... ###"
sudo add-apt-repository ppa:kivy-team/kivy
sudo apt-get update
sudo apt-get install -y python-kivy

echo "### installing pip... ###"
sudo apt-get install python-pip

echo "### isntalling pip dependencies.. ###"
pip install -r dependencies.txt
