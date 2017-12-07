#!/usr/bin/env fish
# 


set BIN_SETUP_SCRIPT (dirname (status --current-filename))/bin_setup.bash

#echo 
#echo "PATH = $PATH"
#echo 

set -x PATH (string split ":" (bash -c "source $BIN_SETUP_SCRIPT -print" | tail -n 1))

if test -d "$HOME/Softwares/Supermongo"
    set -x PATH (string split ":" (bash -c "source $BIN_SETUP_SCRIPT -var PATH -path $HOME/Softwares/Supermongo -print" | tail -n 1))
end

type gethead
type getpix
type sky2xy
type xy2sky
type galfit
type lumdist
type sm

#echo 
#echo "PATH = $PATH"
#echo 


