import random
import unittest
import ConfigParser
import mock
import installStartupUDPClient as installer
from mock import patch, MagicMock, Mock, call
from ludibrio import Dummy


class Base(unittest.TestCase):
    def setUp(self):
      import sys
      class NullDevice():
            def write(self, s):
                pass
      sys.stdout = NullDevice()

@patch("platform.system", ** { 'return_value' : "Darwin" })
@patch("installStartupUDPClient.cp_rf")
@patch("installStartupUDPClient.link")
@patch("installStartupUDPClient.generateKeyPair")
@patch("installStartupUDPClient.os")
class TestInstallStartupUdpClientCopyFiles(Base):
    @patch("os.path.exists", ** { 'return_value' : True })
    def test_returns_directly_if_there_is_an_installation(self, *args):
      assert installer.installingStartup() == False

   
    def test_generates_keypair(self,mock_os,keygen,*args):
      mock_os.path.exists.return_value = False

      installer.installingStartup()
      assert keygen.called

    def test_copies_udp_client_file(self,mock_os,keygen,link,*args):
      mock_os.path.exists.return_value = False

      installer.installingStartup()

      assert link.mock_calls[0] == call(installer.udpClientFile, \
                                        installer.installDirUnixApp + "/" + installer.udpClientFile)

    def test_copies_udp_config_client_file(self, mock_os,keygen,link,*args):
      mock_os.path.exists.return_value = False

      installer.installingStartup()

      assert link.mock_calls[1] == call(installer.toCopyPath        + "/" + installer.udpClientFileCFG, \
                                        installer.installDirUnixApp + "/" + installer.udpClientFileCFG)


    def test_copies_startup_app_caller_file(self, mock_os,keygen,link,*args):
      mock_os.path.exists.return_value = False

      installer.installingStartup()

      assert link.mock_calls[2] == call(installer.toCopyPath        + "/" + installer.startupAppCaller, \
                                        installer.installDirUnixApp + "/" + installer.startupAppCaller)


@patch("platform.system", ** { 'return_value' : "Darwin" })
@patch("installStartupUDPClient.link")
@patch("installStartupUDPClient.cp_rf")
@patch("installStartupUDPClient.generateKeyPair")
@patch("installStartupUDPClient.os")
class TestInstallScriptDarwin(Base):
    def test_copies_startup_app_caller_file_on_install_target(self, mock_os,keygen,copy,*args):
      mock_os.path.exists.return_value = False

      installer.installingStartup()

      assert copy.mock_calls[0] == call("./InstallerFiles/toBeCopied/com.user.loginscript.plist", \
                                        "/Library/LaunchAgents/com.user.loginscript.plist")



@patch("platform.system", ** { 'return_value' : "Linux" })
@patch("installStartupUDPClient.cp_rf")
@patch("installStartupUDPClient.generateKeyPair")
@patch("installStartupUDPClient.os")
class TestInstallScriptLinux(Base):
    def test_copies_startup_app_caller_file_on_install_target(self, mock_os,keygen,copy,*args):
      mock_os.path.exists.return_value = False

      installer.installingStartup()

      assert copy.mock_calls[0] == call("./InstallerFiles/toBeCopied/" + installer.startupAppCaller, \
                                        "/etc/init.d" + "/" + installer.startupAppCaller)



if __name__ == '__main__':
    unittest.main()

