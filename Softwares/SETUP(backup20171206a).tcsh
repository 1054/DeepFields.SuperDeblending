#!/bin/tcsh
# 
# 
# 
# readlink
set called=($_) ### https://stackoverflow.com/questions/2563300/how-can-i-find-the-location-of-the-tcsh-shell-script-im-executing
if ( "$called" != "" ) then  ### called by source 
   set DeepFieldsSuperDeblendingSoftwaresPath=`dirname "$called[2]"`
else                         ### called by direct excution of the script
   set DeepFieldsSuperDeblendingSoftwaresPath=`dirname "$0"`
endif
set DeepFieldsSuperDeblendingSoftwaresPath=`"$DeepFieldsSuperDeblendingSoftwaresPath"/astrodepth_abs_path "$DeepFieldsSuperDeblendingSoftwaresPath"`
#echo "$DeepFieldsSuperDeblendingSoftwaresPath"
#
# PATH
if ! ( "$PATH" =~ *"$DeepFieldsSuperDeblendingSoftwaresPath"* ) then
    setenv PATH "$DeepFieldsSuperDeblendingSoftwaresPath":"$PATH"
endif
echo "PATH = $PATH"




