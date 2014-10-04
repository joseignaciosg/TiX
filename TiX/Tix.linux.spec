import os
import kivy
from kivy.tools.packaging.pyinstaller_hooks import install_hooks
import shutil

install_hooks(globals())

pwd = os.getcwd()

base_path = '%s/Tix/PythonApp/ClientApp/' % pwd

# Compile TixApp.py

paths = ["TixApp.py",  "InstallerFiles/installStartupUDPClient.py",  "InstallerFiles/startupAppCaller.py",  "InstallerFiles/uninstallStartupUDPClient.py",  "InstallerFiles/tobeCopied/TixClientApp.py"]
  
def collect_many(paths, base_path):
  ans = []
  for path in paths:
    filename = path.split(os.sep)[-1]
    print "==================================================== Preparing analysis for %s" % filename
    a = Analysis(['%s/%s' % (base_path, path)],
                 pathex=[os.getcwd()])
    ans.append([a, filename, filename.replace(".py", "")])

  MERGE(*ans)

  for a, basename, exename in ans:
    print "==================================================== PYZ for %s" % basename
    pyz = PYZ(a.pure)

    print "==================================================== Preparing EXE for %s" % basename

    exe = EXE(pyz,
              a.scripts,
              exclude_binaries=True,
              name=os.path.join('build', exename),
              strip=None,
              debug=True,
              append_pkg=False,
              upx=True,
              console=True)
    print "==================================================== Preparing COLLECT for %s" % basename

    args = [exe, a.binaries, a.zipfiles, a.datas]

    if exename == 'TixApp':
      args.append(Tree(base_path))

    coll = COLLECT(*args,
                   debug=True,
                   strip=None,
                   upx=True,
                   name=os.path.join('dist',exename))
  for a, basename, exename in ans: 
    if exename == 'TixApp': 
      continue
    os.system("bash -c 'cp dist/%s/* dist/TixApp/'" % exename)
    os.system("chmod 766 dist/TixApp/%s" % (exename))

  os.system("bash -c 'cp updater/* dist/TixApp/InstallerFiles/toBeCopied/'")

collect_many(paths, base_path)
