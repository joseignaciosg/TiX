#!/usr/bin/python
import shutil,errno,os,stat,platform,sys,getopt,subprocess

startupAppCaller = "startupAppCaller.sh" #This app will call on startup to the UDP Client app
installDirUnix = "/etc/TIX"
installDirUnixApp = installDirUnix + '/app'


def unInstallingStartup():
    os_system = platform.system()
    startupAppCaller = "startupAppCaller.sh" #This app will call on startup to the UDP Client app
    print os_system
    if os_system == "Linux":
        print("Estoy en Linux")
        if os.path.exists("/etc/init.d"):
            if os.path.isfile("/etc/init.d/" + startupAppCaller):
                os.remove('/etc/init.d/' + startupAppCaller)
        if os.path.exists(installDirUnix):
            shutil.rmtree(installDirUnix)
        os.system("update-rc.d "+ startupAppCaller + " remove")
        os.system("killall TixClientApp");
    if os_system == "Darwin":
        print "Estoy en MAC"
        os.system("sudo launchctl unload com.user.loginscript")
        os.system("sudo rm /Library/LaunchAgents/com.user.loginscript.plist")
        os.system("sudo rm -rf /etc/TIX/")
        os.system("killall TixClientApp");
        # if os.path.exists(installDirUnix):
        #     shutil.rmtree(installDirUnix)
    if os_system == "Windows":
        os_type = platform.release();
        if os_type == "XP":
            print "Desinstalo en Windows XP"
        if os_type == "Vista":
            print "Desinstalo en Windows Vista"

    return 0

if __name__ == "__main__":
    unInstallingStartup()
