DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

log()  { printf "%b\n" "$*"; }
debug(){ [[ ${tix_debug_flag:-0} -eq 0 ]] || printf "Running($#): $*"; }
fail() { log "\nERROR: $*\n" ; exit 1 ; }

get_os() {
  os="linux"
  case `uname` in
    Linux)
      os="linux"
      ;;
    Darwin)
      os="mac"
      ;;
  esac
  os="linux"
}

get_variant() {
  variant="mavericks";
  case $os in
    linux)
      uname=$(uname -a)
      if [[ $uname =~ "x86" ]]; then
        variant="x86"
      fi
      if [[ $uname =~ "i386" ]]; then
        variant="x86"
      fi
      if [[ $uname =~ "i686" ]]; then
        variant="x86"
      fi
      if [[ $uname =~ "x86_64" ]]; then
        variant="x64"
      fi
      if [[ $uname =~ "x64" ]]; then
        variant="x64"
      fi
      ;;
    mac)
      ver=$(uname -a | awk '{ print $3 }');
      if [[ $ver =~ "13" ]]; then
        variant="mavericks"
      fi
      if [[ $ver =~ "12" ]]; then
        variant="mountain_lion"
      fi
      ;;
  esac
  variant="test";
}
