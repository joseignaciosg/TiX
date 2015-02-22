
import rsa

def generateKeyPair(privateKeyFile, publicKeyFile):
	(pubkey, privkey) = rsa.newkeys(512)
	exportableKeys = []
	privHandle = open(privateKeyFile, 'wb')
	exportableKeys.append(privkey.save_pkcs1(format='PEM'))
	privHandle.write(privkey.save_pkcs1(format='PEM'))
	privHandle.close()

	pubHandle = open(publicKeyFile, 'wb')
	pubHandle.write(pubkey.save_pkcs1(format='PEM'))
	exportableKeys.append(pubkey.save_pkcs1(format='PEM'))
	pubHandle.close()

	return exportableKeys[1]

if __name__ == "__main__":
	generateKeyPair("/etc/TIX/tix_key.priv", "/etc/TIX/tix_key.pub")
#	generateKeyPair("tix_key.priv", "tix_key.pub")
#	privateKeyFile = open('tix_key.priv','r')
#	publicKeyFile = open('tix_key.pub','r')
#	privateKey = RSA.importKey(privateKeyFile.read())
#	publicKey = RSA.importKey(publicKeyFile.read())
#	msg = "09/07/13|12:56:26,629827 |75|46586628676|46586629490|46586629558|46586629653"
#	signedMessage = privateKey.sign(msg, Random.new().read) #El cliente firma el msg
#	print signedMessage

#	publicKeyPlain = publicKey.exportKey()
	#Cliente envia al server: DATA|publicKeyPlain|signedMeessage|msg

	## En el server, valido el 'DATA' y con la signature y el msg lo verifico. Por ultimo uso la publicKeyPlain para buscar el usuario

#	client_pub_key = RSA.importKey(publicKeyPlain) # import pub key from string

#	print client_pub_key.verify(msg, signedMessage) # En el servidor se hace el VERIFY, para esto se necesita tambien la firma!