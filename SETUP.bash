#!/usr/bin/env bash
# 


Crab_BIN_SETUP_SCRIPT=$(dirname "${BASH_SOURCE[0]}")/Softwares/bin_setup.bash

source "$Crab_BIN_SETUP_SCRIPT" -check do_Galfit do_Galsim

export SUPERDEBLENDDIR=$(dirname "${BASH_SOURCE[0]}")/Softwares


