#!/bin/bash
TEMP_FILE=/dev/stdout
#TEMP_FILE=install.log

gksudo echo

echo "### TIX instalation script is running ###"

echo "### installing python... ###"
sudo apt-get install -y python-software-properties >> $TEMP_FILE 2>&1

echo "### installing kivy... ###"
sudo add-apt-repository ppa:kivy-team/kivy >> $TEMP_FILE 2>&1
sudo apt-get update >> $TEMP_FILE 2>&1
sudo apt-get install -y python-kivy >> $TEMP_FILE 2>&1

echo "### installing pip... ###"
sudo apt-get install -y python-pip >> $TEMP_FILE 2>&1

echo "### installing pip dependencies.. ###"
pip install -r dependencies.txt >> $TEMP_FILE 2>&1

#echo "### installing iphython... ###"
#sudo easy_install ipython >> $TEMP_FILE 2>&1

echo "### installing postgresql...###"
sudo apt-get install -y postgresql >> $TEMP_FILE 2>&1
sudo apt-get install -y postgresql-server-dev-9.1 >> $TEMP_FILE 2>&1

echo "### intalling psycopg2.... ###"
sudo apt-get install -y python-psycopg2 >> $TEMP_FILE 2>&1

echo "### installing rsa 3.1.2... ###"
sudo  easy_install rsa >> $TEMP_FILE 2>&1

echo "### installing requests module... ###"
sudo easy_install requests >> $TEMP_FILE 2>&1

echo "### Launching Installation... ###"
cd TiX/PythonApp/ClientApp/
sudo python TixApp.py >> $TEMP_FILE 2>&1
cd ../../..
