#!/usr/bin/env tcsh
# 


set BIN_SETUP_SCRIPT = `dirname $0`/Softwares/bin_setup.bash

set PATH = `bash -c "source $BIN_SETUP_SCRIPT -print" | tail -n 1`

type do_Preset do_Galfit do_Galsim

set SUPERDEBLENDDIR = `dirname $0`/Softwares


