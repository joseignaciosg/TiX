### Readme for setting up a Linux Environment

Comandos a correr para instalar el entorno en Ubuntu

     sudo apt-get install -y python-software-properties
     sudo add-apt-repository ppa:kivy-team/kivy
     sudo apt-get update
     sudo apt-get install -y python-kivy
     sudo apt-get install python-pip
     # sudo apt-get install virtualenv
     pip install -r dependencies.txt
     # tratar de instalar por con pip, si una dependencia falla , sacarla y trantar con aptitude


ipdb==0.8 anda
ipython==1.1.0 no anda
psycopg2==2.5.1 no anda
pyasn1==0.1.7 anda
pycrypto==2.6 anda
rsa==3.1.2 no anda
wsgiref==0.1.2 anda

Estamos probando con:

easy_install (apt-get install python-setup-tools)  SUELE USAR PAQUETES
pip          (apt-get install python-pip)          COMPILA
apt-get                                            BAJAR BINARIOS
             Suele ser necesario usar add-apt-repository
