#!/bin/bash
#
#${BASH_SOURCE[0]}
#
#BASH_VERBOSE=0
#
# readlink for Mac (because Mac readlink does not accept "-f" option)
BIN_SETUP_SCRIPT=$(dirname "${BASH_SOURCE[0]}")/bin_setup.bash

if [[ -d "$HOME/Softwares/Supermongo" ]]; then
    source "$BIN_SETUP_SCRIPT" -var PATH -path "$HOME/Softwares/Supermongo"
fi

source "$BIN_SETUP_SCRIPT" -check gethead getpix sky2xy xy2sky galfit lumdist sm


