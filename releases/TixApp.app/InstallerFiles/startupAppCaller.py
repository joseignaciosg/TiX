import shutil,errno,os,stat,platform,sys,getopt

installDirUnix = "/etc/TIX"
installDirUnixApp = installDirUnix + '/app'
udpclientFile = "TixClientApp.py"
installDirUnixAppExecutable = installDirUnixApp + '/' + udpclientFile

if __name__ == "__main__":
	os.system("sudo " + installDirUnixAppExecutable + " log")
