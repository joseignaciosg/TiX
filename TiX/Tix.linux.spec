import os
import kivy
from kivy.tools.packaging.pyinstaller_hooks import install_hooks
import shutil

install_hooks(globals())

pwd = os.getcwd()

base_path = '%s/TiX/PythonApp/ClientApp/' % pwd

# Compile TixApp.py

paths = ["TixApp.py",  "InstallerFiles/installStartupUDPClient.py",  "InstallerFiles/startupAppCaller.py",  "InstallerFiles/uninstallStartupUDPClient.py",  "InstallerFiles/toBeCopied/TixClientApp.py"]

def filter_binaries(all_binaries):
  '''Exclude binaries provided by system packages, and rely on .deb dependencies
  to ensure these binaries are available on the target machine.

  We need to remove OpenGL-related libraries so we can distribute the executable
  to other linux machines that might have different graphics hardware. If you
  bundle system libraries, your application might crash when run on a different
  machine with the following error during kivy startup:

  Fatal Python Error: (pygame parachute) Segmentation Fault

  If we strip all libraries, then PIL might not be able to find the correct _imaging
  module, even if the `python-image` package has been installed on the system. The
  easy way to fix this is to not filter binaries from the python-imaging package.

  We will strip out all binaries, except libpython2.7, which is required for the
  pyinstaller-frozen executable to work, and any of the python-* packages.
  '''

  print '============== Excluding system libraries'
  import subprocess
  excluded_pkgs  = set()
  excluded_files = set()
  whitelist_prefixes = ('libpython2.7', 'python-', 'libtiff', 'libudev', 'python2.7', 'libmikmod2')
  binaries = []

  for b in all_binaries:
      try:
          output = subprocess.check_output(['dpkg', '-S', b[1]], stderr=open('/dev/null'))
          p, path = output.split(':', 2)
          if not p.startswith(whitelist_prefixes):
              excluded_pkgs.add(p)
              excluded_files.add(b[0])
              print ' excluding {f} from package {p}'.format(f=b[0], p=p)
      except Exception:
          pass

  print 'Your exe will depend on the following packages:'
  print excluded_pkgs

  inc_libs = set(['libpython2.7.so.1.0'])
  binaries = [x for x in all_binaries if x[0] not in excluded_files]
  print '============== END Excluding system libraries'
  return binaries
  
def collect_many(filter_binaries, paths, base_path):
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
              debug=True, append_pkg=False,
              upx=True,
              console=True)
    print "==================================================== Preparing COLLECT for %s" % basename


    if exename == 'TixApp':
      args = [exe, filter_binaries(a.binaries), a.zipfiles, a.datas]
      args.append(Tree(base_path))
    else:
      args = [exe, a.binaries, a.zipfiles, a.datas]

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

collect_many(filter_binaries, paths, base_path)
