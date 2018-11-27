#!/usr/bin/env fish
# 


set BIN_SETUP_SCRIPT (dirname (status --current-filename))/Softwares/bin_setup.bash

#echo 
#echo "PATH = $PATH"
#echo 

set -x PATH (string split ":" (bash -c "source $BIN_SETUP_SCRIPT -print" | tail -n 1))

type do_Preset do_Galfit do_Galsim

set -gx SUPERDEBLENDDIR (dirname (status --current-filename))/Softwares

#echo 
#echo "PATH = $PATH"
#echo 


