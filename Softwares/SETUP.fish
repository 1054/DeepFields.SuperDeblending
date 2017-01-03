#!/usr/bin/fish
#
# 
# SUPERDEBLENDDIR
if contains "Linux" (uname)
    set -x SUPERDEBLENDDIR (dirname (readlink -f (status --current-filename)))
end
if contains "Darwin" (uname)
    set -x SUPERDEBLENDDIR (dirname (perl -MCwd -e 'print Cwd::abs_path shift' (status --current-filename)))
end
export SUPERDEBLENDDIR
#<DEBUG># echo "$SUPERDEBLENDDIR"
# 
# Check
if [ x"$SUPERDEBLENDDIR" = x"" ]
    exit
end
#
# PATH
if not contains "$SUPERDEBLENDDIR" $PATH
    set -x PATH "$SUPERDEBLENDDIR" $PATH
end
#
#LIST
set -x SUPERDEBLENDCMD galfit sm cl sky2xy xy2sky sex CrabPhotAperPhot
#
# IRAF
if [ (type cl 2>/dev/null | wc -l) -eq 0 ]
    # if on planer or in planer qsub job
    if true
        echo "************************************************************************************"
        echo "Warning! IRAF was not found! cl command not found! This will cause unknown problem!"
        echo "************************************************************************************"
        echo 
    end
end
#
# SEXTRACTOR
if [ (type sex 2>/dev/null | wc -l) -eq 0 ]; then
    # if on planer or in planer qsub job
    if true
        echo "******************************************************************************************"
        echo "Warning! SEXTRACTOR was not found! sex command not found! This will cause unknown problem!"
        echo "******************************************************************************************"
        echo 
    end
end
#
# IDL
if [ (type idl 2>/dev/null | wc -l) -eq 0 ]; then
    # if on planer or in planer qsub job
    if true
        echo "***********************************************************************************"
        echo "Warning! IDL was not found! idl command not found! This will cause unknown problem!"
        echo "***********************************************************************************"
        echo 
    end
end
# 
# CHECK
for TEMPNAME in $SUPERDEBLENDCMD
    type $TEMPNAME | head -n 1
end


