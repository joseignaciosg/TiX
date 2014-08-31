#!/usr/bin/env bash

shopt -s extglob
set -o errtrace
set -o errexit

tix_update_initialize()
{
  DEFAULT_SOURCES=(github.com/wayneeseguin/rvm)

  BASH_MIN_VERSION="3.2.25"
  if
    [[ -n "${BASH_VERSION:-}" &&
      "$(\printf "%b" "${BASH_VERSION:-}\n${BASH_MIN_VERSION}\n" | LC_ALL=C \sort -t"." -k1,1n -k2,2n -k3,3n | \head -n1)" != "${BASH_MIN_VERSION}"
    ]]
  then
    echo "BASH ${BASH_MIN_VERSION} required (you have $BASH_VERSION)"
    exit 1
  fi

  export HOME PS4
  export rvm_trace_flag rvm_debug_flag rvm_user_install_flag rvm_ignore_rvmrc rvm_prefix rvm_path

  PS4="+ \${BASH_SOURCE##\${rvm_path:-}} : \${FUNCNAME[0]:+\${FUNCNAME[0]}()}  \${LINENO} > "
}

log()  { return }
debug(){ return }
fail() { return }

tix_update_commands_setup()
{
  return
}

usage()
{
  return
}

## duplication marker 32fosjfjsznkjneuera48jae
__rvm_curl_output_control()
{
  return
}

## duplication marker 32fosjfjsznkjneuera48jae
# -S is automatically added to -s
# __rvm_curl()
# (
# return
# )

rvm_error()  { return }
__rvm_which(){ return }
__rvm_debug_command()
{
  return
}
rvm_is_a_shell_function()
{
  return
}

# Searches the tags for the highest available version matching a given pattern.
# fetch_version (github.com/wayneeseguin/rvm bitbucket.org/mpapis/rvm) 1.10. -> 1.10.3
# fetch_version (github.com/wayneeseguin/rvm bitbucket.org/mpapis/rvm) 1.10. -> 1.10.3
# fetch_version (github.com/wayneeseguin/rvm bitbucket.org/mpapis/rvm) 1.    -> 1.11.0
# fetch_version (github.com/wayneeseguin/rvm bitbucket.org/mpapis/rvm) ""    -> 2.0.1
fetch_version()
{
  return
}

# Returns a sorted list of all version tags from a repository
fetch_versions()
{
  return
}

update_release()
{
  return
}

update_head()
{
  return
}

# duplication marker dfkjdjngdfjngjcszncv
# Drop in cd which _doesn't_ respect cdpath
__rvm_cd()
{
  return
}

get_and_unpack()
{
  return
}

tix_update_default_settings()
{
  return
}

tix_update_parse_params()
{
  return
}

tix_update_validate_rvm_path()
{
  return
}

tix_update_select_and_get_version()
{
  return
}

tix_update_main()
{
  return
}

# tix_update_ruby_and_gems()
# (
# return
# )

tix_update()
{
  return
}

tix_update "$@"
