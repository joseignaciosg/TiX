#!/usr/bin/python

import shutil,errno,os,stat,platform,sys,getopt,subprocess,inspect, ConfigParser, rsa

startupAppCaller = "startupAppCaller.sh"
tixUpdater = "tix_updater.sh"
tixLib = "tix_lib.sh"

installDirUnix = "/etc/TIX"
installDirUnixApp = installDirUnix + '/app'

udpClientFile = "TixClientApp"
udpClientFileCFG = "udpclienttiempos.cfg"

toCopyPath = './InstallerFiles/toBeCopied'
installDirUnixAppExecutable = installDirUnixApp + '/' + udpClientFile

linuxTemplateFile = "TiX.desktop"

darwinLaunchFile = 'com.user.loginscript.plist'
darwinLaunchScriptsFolder = 'Library/LaunchAgents'

initPath = "/etc/init.d"

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

# Copy recursively files
def cp_rf(src, dst):
    try:
        shutil.copytree(src, dst)
    except OSError as exc: # python >2.5
        if exc.errno == errno.ENOTDIR:
            shutil.copy(src, dst)
        else: raise

def link(src, dst):
    os.system("sudo ln -s %s %s" % (os.path.abspath(src),os.path.abspath(dst)))


# Change permissions to execute on a given file
def chmod_x(file):
    script_st = os.stat(file)
    os.chmod(file, script_st.st_mode | stat.S_IEXEC)

def src_path(file):
  return toCopyPath + "/" + file

def init_path(file):
  return initPath + "/" + file

def dest_path(file):
  return installDirUnixApp + "/" + file

def darwin_launch_path(file):
  return ("/" + darwinLaunchScriptsFolder + "/" + file)

def linux_replace_file_path():
  with open(linuxTemplateFile) as thefile:
    content = thefile.read() 
    replacedText = content.replace("{{PATH}}", )
  if replacedText != content:
    with open(match, 'w') as thefile:
      thefile.write(replacedText)

def unix_common_files_copy():
  # Copy udpClientFile and make executable
  link(udpClientFile,dest_path(udpClientFile))

  # Copy udpClientFile configuration
  link(src_path(udpClientFileCFG),dest_path(udpClientFileCFG))

  # Copy startupAppCaller and make executable
  chmod_x(src_path(startupAppCaller))
  link(src_path(startupAppCaller),dest_path(startupAppCaller))

  # Copy startupAppCaller and make executable
  chmod_x(src_path(tixUpdater))
  link(src_path(tixUpdater),dest_path(tixUpdater))
  chmod_x(src_path(tixLib))
  link(src_path(tixLib),dest_path(tixLib))

def darwin_install_client():
  # Set as root, copy to launchers, and tell osx we're inside
  os.system('sudo chown root %s' % src_path(darwinLaunchFile))
  cp_rf('%s' % src_path(darwinLaunchFile), darwin_launch_path(darwinLaunchFile))
  sys_return = os.system('sudo launchctl load %s' % darwin_launch_path(darwinLaunchFile))

def linux_install_client():
  print "about to copy"
  chmod_x(src_path(startupAppCaller))
  cp_rf(src_path(startupAppCaller),init_path(startupAppCaller))

  # TODO: Test this ones
  print "update-rc.d " + startupAppCaller + " defaults"
  os.system("update-rc.d " + startupAppCaller + " defaults")

def installingStartup():
    os_system = platform.system()
    installation_ok = False
    print os_system
    if os_system == "Linux" or os_system == "Darwin":
        print "Creando Directorios... ... hola mama"
        if not os.path.exists(installDirUnix):
            os.makedirs(installDirUnix)
            os.makedirs(installDirUnixApp)
        else: # No deberia existir el directorio TiX si es una instalacion nueva; esto ya se valida en TixApp
            return False

        print "Creando par de claves publica y privada para la instalacion.."
        generateKeyPair(installDirUnix+'/tix_key.priv',installDirUnix+'/tix_key.pub')    
        
        print "Copiando el ejecutable..."
        unix_common_files_copy()

        print "Instalando cliente TIX en el arranque..."
        if os_system == "Darwin":
          darwin_install_client()
        else:
          linux_install_client()

        installation_ok = True
    if os_system == "Windows":
        # TODO: Windows setup
        os_type = platform.release();
        if os_type == "XP":
            print "Estoy en Windows XP"
        if os_type == "Vista":
            print "Estoy en Windows Vista"
            # subprocess.call(['runas', '/user:Administrator', 'C:/my_program.exe'])
        installation_ok = True

    return installation_ok

if __name__ == "__main__":
    installingStartup()

