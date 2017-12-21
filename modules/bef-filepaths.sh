#!/usr/bin/env bash
############# BASH ESSENTIAL FUNCTIONS - FILEPATHS MODULE (BEF-FP) #############
# If copying the contents of this module into your own script be sure to comment
# out the next line, otherwise this library's usage message will be displayed.
if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then case "$1" in -l*|--l*) message='
################################## LICENSE #####################################
# Bash Essential Functions - FilePaths module (BEF-FP)
#
# The Bash Essential Functions library is licensed under the MIT License (a.k.a.
# the "Expat License"), details of which are below. Code contributions are
# welcome at <https://github.com/shoogle/bash-essential-functions>.
#
# MIT License
#
# Copyright (c) 2017 Peter Jonas
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
################################################################################
#' ;; -h*|-h*) message='
#################################### HELP ######################################
# Bash Essential Functions - FilePaths module (BEF-FP)
#
# Source this file to get access to the functions it contains:
#
#   $  source  bef-filepaths.sh  [--no-convenience-functions]
#
# Functions in this module are named `bef_fp__function_name` to avoid polluting
# the global namespace. After souring the file you can list the functions with:
#
#   $ declare -F | grep "bef_fp"  # `declare -f` includes function definitions!
#
# BEF modules provide convenience functions that accept data piped from STDIN
# and echo the result to STDOUT, which can be saved using command substitution:
#
#   $  myvar="$(pipeline  |  bef_fp__function_name  "${args}")"  # convenient!
#
# However, this is not recommended because command substitution strips trailing
# newlines, which, although rarely used, are valid characters in Unix filenames.
# Instead, you should consider using the "setvar" functions:
#
#   $  declare funcvar  &&  bef_fp__setvar_funcvar "${arg}"  # faster & safer!
#
# This sets the variable "funcvar" to the output of the first function, without
# losing any trailing newline characters. Using the setvar function is faster
# than command substitution because it avoids spawning a subshell. Most setvar
# functions do not accept piped data because this could spawn a subshell.
#
# If you want to disable the convenience functions entirely and keep only setvar
# functions then source the file with the `--no-convenience-functions` option.
################################################################################
#' ;; *) message="
#################################### USAGE #####################################
# Bash Essential Functions - FilePaths module (BEF-FP)
#
# This script is a Bash function library and should be sourced rather than run.
#
# Usage: .|source  bef-filepaths.sh  [--no-convenience-functions]
#
# However, it may be run with the following options to display info messages:
#
# Usage: [bash] ./bef-filepaths.sh [-h|--help] [-l|--license]
#
# Please submit code contributions and bug reports to the upstream repository
# at <https://github.com/shoogle/bash-essential-functions>. Thanks!
################################################################################
#" ;; esac; IFS=$'\n' read -d '' -n ${#message} -a lines <<<"${message}
#" ; for ((i=1;i<${#lines[@]}-2;i++)); do echo "${lines[i]:2}"; done; exit; fi
################################################################################

if [[ "$1" != "--no-convenience-functions" ]]; then

  function bef_fp__basename() {
    local path basename \
      && bef_fp__setvar_path_from_args_or_stdin "$@" \
      && bef_fp__setvar_basename "${path}" \
      && echo "${basename}"
  }

  function bef_fp__dirname() {
    local path dirname \
      && bef_fp__setvar_path_from_args_or_stdin "$@" \
      && bef_fp__setvar_dirname "${path}" \
      && echo "${dirname}"
  }

  # Appends $PWD to $path if $path is relative (does not start with '/'). $path
  # does not have to exist. Output is not normalized or canonicalized.
  function bef_fp__absolute_path() {
    local path abspath \
      && bef_fp__setvar_path_from_args_or_stdin "$@" \
      && bef_fp__setvar_abspath "${path}" \
      && echo "${abspath}"
  }

  function bef_fp__normalized_path() {
    local path normpath \
      && bef_fp__setvar_path_from_args_or_stdin "$@" \
      && bef_fp__setvar_normpath "${path}" \
      && echo "${normpath}"
  }

  function bef_fp__canonical_path() {
    local path canonpath \
      && bef_fp__setvar_path_from_args_or_stdin "$@" \
      && bef_fp__setvar_canonpath "${path}" \
      && echo "${canonpath}"
  }

fi # [[ "$1" != "--no-convenience-functions" ]]

# set $path variable in caller shell with input from $1 or STDIN
# Usage: local path && bef_fp__setvar_path_from_args_or_stdin "$@"
function bef_fp__setvar_path_from_args_or_stdin() {
  if (($# > 0)); then
    path="$1"
  else
    read -d '' -r path # path from STDIN (path may contain newlines)
    path="${path%$'\n'}" # strip extra newline added by read -d ''
  fi
}

# set $nodes array in caller shell with result of splitting $1 on "/"
# Usage: local nodes=() && bef_fp__setvar_nodes_array "${path}"
function bef_fp__setvar_nodes_array() {
  local length=${#1} IFS="/" # split path on "/"
  # read $path into array. Only read $lenght chars to avoid extra '\n' chars.
  ((length == 0)) || read -d '' -n $length -r -a nodes <<<"$1"
}

# set $basename variable in caller shell with basename of $1. Avoids subshell.
# Usage: local basename && bef_fp__setvar_basename "${path}"
function bef_fp__setvar_basename() {
  local path="$1"
  if [[ "${path}" =~ ^/+$ ]]; then
    basename="/" # path consists only of slashes
    return # '/////' gives '/'
  fi
  while [[ "${path}" == *"/" ]]; do
    path="${path%/}" # strip trailing slash(es): 'foo/bar//' goes to 'foo/bar'
  done
  # return everything after final slash, or everything if there are no slashes
  basename="${path##*/}" # 'foo/bar' or 'bar' gives 'bar'
}

# set $dirname variable in caller function dirname of $1. Avoids subshell.
# Usage: local dirname && bef_fp__setvar_dirname "${path}"
function bef_fp__setvar_dirname() {
  local path="$1"
  if [[ "${path}" =~ ^/*[^/]*/*$ ]]; then # path only has one node: //foo///
    if [[ "${path:0:1}" == / ]]; then
      dirname="/" # '//foo///', '//foo' or '//' gives '/' (shortest abs. path)
    else
      dirname="." # 'foo///', 'foo' or '' gives '.' (shortest relative path)
    fi
    return
  fi
  while [[ "${path}" == */ ]]; do # strip any trailing slash(es)
    path="${path%/}" # 'foo///bar///' goes to 'foo///bar'
  done
  # only keep characters before the final slash, or everything if no slashes
  path="${path%/*}" # 'foo///bar' goes to 'foo//', 'foo' goes to 'foo'
  while [[ "${path}" == */ ]]; do
    path="${path%/}" # strip trailing slash(es):  'foo//' goes to 'foo'
  done
  dirname="${path}"
}

# Prepends $PWD to $path if $path is relative (does not start with '/'). $path
# does not have to exist. Output is not normalized or canonicalized.
function bef_fp__setvar_abspath() {
  local path="$1"
  if [[ "${path:0:1}" == "/" ]]; then
    abspath="${path}"
  else
    abspath="${PWD}/${path}"
  fi
}

# Removes unnecessary slashes and resolves '.' and '..' to return the shortest
# path equivalent to the one given as input. The path does not have to exist.
function bef_fp__setvar_normpath() {
  local path="$1" basename dirname abs skip=0
  [[ "${path:0:1}" == "/" ]] && abs="/" || abs="" # relative or absolute path?
  while [[ ! "${path}" =~ ^\.?/*$ ]]; do
    bef_fp__setvar_basename "${path}"
    bef_fp__setvar_dirname "${path}"
    if [[ "${basename}" == "." ]]; then
      : # ignore node
    elif [[ "${basename}" == ".."  ]]; then
      ((skip++)) # skip next node that isn't '.' or '..' or already skipped
    elif ((skip > 0)); then
      ((skip--)) # skipping this node due to prior '..'
    else
      normpath="${basename}/${normpath}" # add node to normpath
    fi
    path="${dirname}" # move to next node
  done
  if [[ ! "${abs}" ]]; then
    while ((skip > 0)); do
      normpath="../${normpath}"
      ((skip--))
    done
  fi
  if [[ "${normpath}" ]]; then
    normpath="${abs}${normpath%/}" # strip trailing slash
  elif [[ "${abs}" ]]; then
    normpath="/"
  else
    normpath="."
  fi
}

function bef_fp__setvar_canondirpath() {
  local dirpath="$1"
   # `cd` to $dirpath and back again. ${OLDPWD} created automatically by shell.
  CDPATH="" cd -P "${dirpath}" \
    && canondirpath="${PWD}" \
    && CDPATH="" cd "${OLDPWD}" \
    || echo "${FUNCNAME[0]}: error: unable to access: ${dirpath}" >&2
}

# Prints physical path without symbolic links. ${path} must exist on system.
function bef_fp__setvar_canonpath() {
  local path="$1" canonpath canondirpath
  if [[ -d "${path}" ]]; then
    bef_fp__setvar_canondirpath "${path}"
    canonpath="${canondirpath}"
  elif [[ ! -e "${path}" ]]; then
    if [[ -L "${path}" ]]; do
      echo "${FUNCNAME[0]}: error: no target found for symlink: ${path}" >&2
      return 2
    else
      echo "${FUNCNAME[0]}: error: file not found: ${path}" >&2
      return 1
    fi
  else
    local basename dirname symlinks=0 max_symlinks=40
    while [[ -L "${path}" ]]; do
      if ((symlinks++ && symlinks > max_symlinks)); then
        echo "${FUNCNAME[0]}: error: too many symlinks: ${path}" >&2
        return 3
      fi
      # Must read the link. Can we avoid using subshell and external binary?
      canonpath="$(readlink "${path}")" # XXX: Can we avoid this?
      if [[ "${canonpath:0:1}" == "/" ]]; then
        path="${canonpath}"
      else
        bef_fp__setvar_dirname "${path}"
        path="${dirname}/${canonpath}"
      fi
    done
    bef_fp__setvar_basename "${path}"
    bef_fp__setvar_dirname "${path}"
    bef_fp__setvar_canondirpath "${dirname}"
    canonpath="${canondirpath}/${basename}"
  fi
}
