#!/bin/tcsh
#
#${BASH_SOURCE[0]}
#
#BASH_VERBOSE=0
#
# readlink for Mac (because Mac readlink does not accept "-f" option)
if [[ (uname) == *"Darwin"* ]]; then
    alias readlink 
        if [[ $# -gt 1 ]]; then if [[ "$1" == "-f" ]]; then shift; fi; fi
        DIR=$(echo "${1%/*}"); # 20160410: fixed bug: source SETUP just under the Softwares dir
        if [[ -d "$DIR" ]]; then cd "$DIR" && echo "$(pwd -P)/$(basename ${1})"; 
        else echo "$(pwd -P)/$(basename ${1})"; fi
    }
fi
exit
SUPERDEBLENDDIR=$(dirname $(readlink -f "${BASH_SOURCE[0]}"))
export SUPERDEBLENDDIR
#
# PATH
if [[ $PATH != *"$SUPERDEBLENDDIR"* ]]; then
    export PATH="$SUPERDEBLENDDIR":$PATH
fi
#
#LIST
SUPERDEBLENDCMD=(galfit sm cl sky2xy xy2sky sex CrabPhotAperPhot)
#
# IRAF
if [[ $(type cl 2>/dev/null | wc -l) -eq 0 ]]; then
    # if on planer or in planer qsub job
    if [[ ($(hostname) == planer* || $(hostname) == sapherschel* || $(hostname) == irfucoast*)  && -d "/opt/core-3.1-amd64/iraf64/2.14.1/iraf/" ]]; then
        ##module load iraf64/2.15 # iraf64/2.15 has imstat precision bug, have to fall back to iraf 2.14
        ##export MACH="linux64"
        ##export IRAFARCH="linux64"
        ##source "$SUPERDEBLENDDIR/iraf_on_planer/irafuser_2.15.sh"
        ##module load iraf64/2.14.1 # iraf64/2.14.1 however could not be successfully module load, have to do it manually
        #export iraf="/opt/core-3.1-amd64/iraf64/2.15/iraf/"
        #export PATH="/opt/core-3.1-amd64/iraf64/2.15/local/bin/:$PATH"
        #export MACH="linux64"
        #export IRAFARCH="linux64"
        #source "$SUPERDEBLENDDIR/iraf_on_planer/irafuser_2.15.sh"
        #export LOADEDMODULES="iraf64/2.15:$LOADEDMODULES"
        export iraf="/opt/core-3.1-amd64/iraf64/2.14.1/iraf/"
        export PATH="/opt/core-3.1-amd64/iraf64/2.14.1/iraf/bin.linux/:$SUPERDEBLENDDIR/iraf_on_planer/bin:$PATH"
        export MACH="linux64"
        export IRAFARCH="linux"
        source "$SUPERDEBLENDDIR/iraf_on_planer/irafuser_2.14.sh"
        export LOADEDMODULES="iraf64/2.14.1:$LOADEDMODULES"
        SUPERDEBLENDCMD=($(echo "${SUPERDEBLENDCMD[@]}" | sed -e 's/ cl / cl cl.e /g'))
    else
        echo "************************************************************************************"
        echo "Warning! IRAF was not found! cl command not found! This will cause unknown problem!"
        echo "************************************************************************************"
        echo 
    fi
fi
#
# SEXTRACTOR
if [[ $(type sex 2>/dev/null | wc -l) -eq 0 ]]; then
    # if on planer or in planer qsub job
    if [[ ($(hostname) == planer* || $(hostname) == sapherschel* || $(hostname) == irfucoast*)  && -d "/opt/core-3.1-amd64/sextractor/2.19.5/bin/" ]]; then
        ##module load sextractor/2.19.5
        export PATH="/opt/core-3.1-amd64/sextractor/2.19.5/bin:$PATH"
    else
        echo "******************************************************************************************"
        echo "Warning! SEXTRACTOR was not found! sex command not found! This will cause unknown problem!"
        echo "******************************************************************************************"
        echo 
    fi
fi
#
# IDL
if [[ $(type idl 2>/dev/null | wc -l) -eq 0 ]]; then
    # if on planer or in planer qsub job
    if [[ ($(hostname) == planer* || $(hostname) == sapherschel* || $(hostname) == irfucoast*)  && -d "/opt/core-3.1-amd64/idl/8.2/bin/" ]]; then
        ##module load idl
        export PATH="/opt/core-3.1-amd64/idl/8.2/bin:$PATH"
        export EXELIS_DIR_DIR="/opt/core-3.1-amd64/idl/8.2"
        export IDL_DIR="/opt/core-3.1-amd64/idl/8.2"
        export RSI_DIR="/opt/core-3.1-amd64/idl/8.2"
        export IDL_PATH="+/dsm/upgal/data/dliu/Superdeblending/Softwares/idl_lib_dzliu/crab:+/opt/core-3.1-amd64/astrolib/200901:+/opt/core-3.1-amd64/craigm/20090329:+/opt/core-3.1-amd64/idl/8.2/lib:+/opt/core-3.1-amd64/idl/8.2/examples"
        export LM_LICENSE_FILE="/opt/core-3.1-amd64/idl/8.2/../license/license.dat"


        ##
        ##IDL_LIB_DZLIU
        ##
        if [[ "$PATH" != *"/dsm/upgal/data/dliu/Superdeblending/Softwares/idl_lib_dzliu/crab:"* ]]; then
            ##!PATH = "idl_lib_dzliu/crab:"+!PATH
            ##resolve_crab ; , "idl_lib_dzliu/crab"
            export PATH="/dsm/upgal/data/dliu/Superdeblending/Softwares/idl_lib_dzliu/crab:$PATH"
        fi
    else
        echo "***********************************************************************************"
        echo "Warning! IDL was not found! idl command not found! This will cause unknown problem!"
        echo "***********************************************************************************"
        echo 
    fi
else
    if [[ x"$IDL_DIR" == x ]]; then
        export IDL_DIR=$(idl -quiet -e 'print, getenv("IDL_DIR")')
    fi
    if [[ x"$IDL_PATH" != x*"$SUPERDEBLENDDIR/idl_lib_dzliu"* ]]; then
        export IDL_PATH="$IDL_PATH:+$SUPERDEBLENDDIR/idl_lib_dzliu"
    fi
    if [[ x"$IDL_DIR" != x && x"$IDL_PATH" != x*":+$IDL_DIR/lib"* ]]; then
        export IDL_PATH="$IDL_PATH:+$IDL_DIR/lib"
    fi
fi
# 
# CHECK
for TEMPNAME in ${SUPERDEBLENDCMD[@]}; do
    type $TEMPNAME
done


