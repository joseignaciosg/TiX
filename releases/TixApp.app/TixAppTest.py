import random
import unittest
import ConfigParser
import mock
from mock import patch, MagicMock
from ludibrio import Dummy

class TestSequenceFunctions(unittest.TestCase):
    # Prepare all classes from kivy to be ignored
    # So we can test the behaviour of the application
    def setUp(self):
        self.kivy = MagicMock()

        class Fake(object):
          def __init__(self, **kwargs):
            return
          def add_widget(self, *args, **kwargs):
            return
          def open(self):
            return

        self.kivy.BoxLayout = Fake
        self.kivy.Popup = Fake
        self.kivy.TextInput = mock.Mock()
        self.subprocess = mock.Mock()

        kivyDict = { 
            "kivy" : self.kivy, 
            "kivy.app" : self.kivy,
            "kivy.uix" : self.kivy,
            "kivy.uix.gridlayout" : self.kivy,
            "kivy.uix.boxlayout" : self.kivy,
            "kivy.uix.label" : self.kivy,
            "kivy.uix.button" : self.kivy,
            "kivy.uix.textinput" : self.kivy,
            "kivy.uix.popup" : self.kivy,
            "kivy.uix.spinner" : self.kivy,
            "kivy.uix.dropdown" : self.kivy,
            "kivy.network" : self.kivy,
            "kivy.network.urlrequest" : self.kivy,
            "kivy.config" : self.kivy,
            "kivy.graphics" : self.kivy,
            "kivy.uix.image" : self.kivy,
            "webbrowser" : self.kivy,
            "subprocess" : self.subprocess,
            "ConfigParser" : self.kivy
        }

        self.module_patcher = patch.dict("sys.modules", kivyDict)
        self.module_patcher.start()


    # Expect to show a screen with "already installed" if the folder already exists
    @patch("os.path.exists", ** { 'return_value' : True })
    def test_shows_splash_when_installation_exists(self, path):
        import TixApp
        with patch.object(TixApp.LoginScreen, 'show_already_installed_popup') as fn:
          screen = TixApp.LoginScreen()
          fn.assert_called_with()

    # Expect to ask a new installation if the folder doesnt exist
    @patch("os.path.exists", ** { 'return_value' : False })
    def test_shows_splash_when_installation_not_exists(self, path):
        import TixApp
        with patch.object(TixApp.LoginScreen, 'show_install_form') as fn:
          screen = TixApp.LoginScreen()
          fn.assert_called_with()


    ### Installation

    # Expect the installer to call installStartupUDPClient in the given installationPath
    def test_calls_valid_path_on_execute_installation(self):
        import os
        import TixApp
        global globalPlatformName
        globalPlatformName = "Darwin"
        installationPath = TixApp.installationPath
        with patch.object(os, 'system') as fn:
          TixApp.execute_installation()
          fn.assert_called_with("sudo %s/installStartupUDPClient" % installationPath)

    ### Removal

    ### On Darwin

    # Expect the installer remove the loginscript in the launchctl
    def test_removes_userscript_on_delete_existing_installation(self):
        import os
        import shutil
        import TixApp
        global globalPlatformName
        globalPlatformName = "Darwin"
        installationPath = TixApp.installationPath
        with patch.object(os, 'system') as fn:
          TixApp.deleteExistingInstallation(TixApp)
          fn.assert_called_with("launchctl remove com.user.loginscript")
    
    # Expect the installer remove the loginscript in the Library path
    @patch("os.path.isfile", ** { 'return_value' : True })
    @patch("os.system", ** { 'return_value' : True })
    def test_removes_userscript_file_on_delete_existing_installation(self, _, __):
        import os
        import shutil
        import TixApp
        global globalPlatformName
        globalPlatformName = "Darwin"
        installationPath = TixApp.installationPath
        with patch.object(os, 'remove') as fn:
          TixApp.deleteExistingInstallation(TixApp)
          fn.assert_called_with("~/Library/LaunchAgents/com.user.loginscript.plist")

    # Expect the installer to remove all the files in the folder /etc/TIX/
    @patch("os.path.exists", ** { 'return_value' : True })
    @patch("os.system", ** { 'return_value' : True })
    def test_removes_data_on_delete_existing_installation(self, _, __):
        import os
        import shutil
        import TixApp
        global globalPlatformName
        globalPlatformName = "Darwin"
        installationPath = TixApp.installationPath
        with patch.object(shutil, 'rmtree') as fn:
          TixApp.deleteExistingInstallation(TixApp)
          fn.assert_called_with("/etc/TIX/")

if __name__ == '__main__':
    unittest.main()

