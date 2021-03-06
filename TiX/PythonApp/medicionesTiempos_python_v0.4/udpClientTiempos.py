#!/usr/bin/python

import time
import datetime
import sys, urllib, xmlrpclib, socket
import subprocess
import binascii
import random
import threading
import sys


def ts():
  # time en microsegundos
  timestamp= datetime.datetime.now().strftime("%H:%M:%S:%f").split(':')
  en_microsegundos=float(timestamp[0])*3600*(10**6)+float(timestamp[1])*60*(10**6)+float(timestamp[2])*(10**6)+float(timestamp[3])
  #print timestamp 
  #print en_microsegundos
  return str(int(en_microsegundos)) # <- en microsegundos, en hexa


def relleno_largo(largo):
	
	relleno=""
	for i in range(0,largo-1):
	    relleno= relleno + str(random.randint(0,9))
	
	return relleno

	
def log_msg(log_file, msg):

	arch=open(log_file,"a")
	print >>arch, datetime.datetime.now().strftime("%D|%H:%M:%S,%f"), msg
	arch.close()
	return


	
def pingUniq(num_uniq, log_file):
	
	#deberian ser 12 bytes, 32 bits por cada timestamp (en hexa)
	_24hs='86400000000'
	
	t1 = _24hs 
	t2 = _24hs
	t3 = _24hs
	t4 = _24hs
	
	#Mensaje corto
	
	t1 = ts()
	
	if (num_uniq % 2 == 0) :
		message = t1 + '|' + t2 + '|' + t3 + '|' + t4
	else:
		message = t1 + '|' + t2 + '|' + t3 + '|' + t4 + '|' + relleno_largo(4400)
	
	client = socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
	
	HOST='157.92.44.31'
	PORT=80
#	HOST='127.0.0.1'
#	PORT=5005
	try:
		client.settimeout(1.0)
		client.sendto(message + "\n", (HOST, PORT)) 
		#print "enviado"
	
		data = client.recv(8192)#(2048) para el mensaje largo
		msg = data.split('|')
		data = msg[0] + '|' + msg[1] + '|' + msg[2] + '|' + ts()#+ '|' + msg[4], en msg[4] queda el contenido del mensaje largo sin imprimir 
		#print 'Received', repr(data)

		iph=20 #longitud ip header (min. 20 bytes)
		udph=8 #longitud udp header (min. 8 bytes)
		if (num_uniq % 2 == 0) :
		      payload=len(data) #longitud del mensaje en bytes
		else:
		      payload=len(data + '|'+ msg[4]) 
		      #data: solo los timestamps, en msg[4] esta el contenido del mensaje largo
	
		pack_len=str(iph + udph + payload)
		log_msg(log_file, '|' + pack_len + '|' + data)
		

		#print data #debuging
		#msg_completo = str(data).split('|')  
		#print len(data) #debuging
	except:
		# print 'Timeout: no hubo respuesta del servidor' #debuging
		client.close()
		

if __name__ == "__main__":
  
	if len(sys.argv) < 2:
	  print "usage: python <client>.py <logfile>\n"
	  sys.exit()
	  
	log_file=sys.argv[1]

	t0=ts()	
	i=0
	while True:
  		#print i
		if int(ts())-int(t0) > 600000000:# 10 minutos
			t0=ts()
  		cliente= threading.Thread(target=pingUniq,args=(i,log_file + t0))
  		cliente.start()
  		#pingUniq(i, log_file)
  		i=~i
  		time.sleep(1)

