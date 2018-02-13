#!/bin/bash
#


BIN_SETUP_SCRIPT=$(dirname "${BASH_SOURCE[0]}")/bin_setup.bash

if [[ -d "$HOME/Softwares/Supermongo" ]]; then
    source "$BIN_SETUP_SCRIPT" -var PATH -path "$HOME/Softwares/Supermongo" -prepend
fi

#if [[ -d "lib_python_dzliu/crabtable" ]]; then
#    source "$BIN_SETUP_SCRIPT" -var PYTHONPATH -path "lib_python_dzliu/crabtable"
#fi

source "$BIN_SETUP_SCRIPT" -check gethead getpix sky2xy xy2sky galfit lumdist sm


