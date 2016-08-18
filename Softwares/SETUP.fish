#!/usr/bin/fish
#
# readlink
if contains "Darwin" (uname)
    function readlink
        for i in (seq 1 (count $argv))
            #echo "$argv[$i]"
            if [ (expr substr + "$argv[$i]" 1 1) = "-" ]
            	#check the input is not starting with "-"
            	#echo "No"
            else if [ (expr substr + "$argv[$i]" 1 1) = "/" ]
            	#check the input is an absolute path
            	#echo "Yes"
            	if test -f "$argv[$i]"
            		###echo "cd \"\$(dirname \$(pwd -P)/$argv[$i])\" && echo \$(pwd -P)/\$(basename \"$argv[$i]\")"
            	    bash -c "cd \"\$(dirname \$(pwd -P)/$argv[$i])\" && echo \$(pwd -P)/\$(basename \"$argv[$i]\")"
            	    #pwd
            	else
            		###echo "cd \"\$(pwd -P)/$argv[$i]\" && echo \$(pwd -P)/"
            	    bash -c "cd \"\$(pwd -P)/$argv[$i]\" && echo \$(pwd -P)/"
            	    #pwd
            	end
            else
            	#check the input is a relative path
            	#echo "Yes"
            	if test -f "$argv[$i]"
            		###echo "cd \"\$(dirname \$(pwd -P)/$argv[$i])\" && echo \$(pwd -P)/\$(basename \"$argv[$i]\")"
            	    bash -c "cd \"\$(dirname \$(pwd -P)/$argv[$i])\" && echo \$(pwd -P)/\$(basename \"$argv[$i]\")"
            	    #pwd
            	else
            		###echo "cd \"\$(pwd -P)/$argv[$i]\" && echo \$(pwd -P)/"
            	    bash -c "cd \"\$(pwd -P)/$argv[$i]\" && echo \$(pwd -P)/"
            	    #pwd
            	end
            end
        end
        #if [[ (count $argv) -gt 1 ]]; then if [[ "$1" == "-f" ]]; then shift; fi; fi
        #DIR=$(echo "${1%/*}"); (cd "$DIR" && echo "$(pwd -P)/$(basename ${1})")
    end
    #readlinkff -f "../../"
    #readlinkff -f "SETUP.fish"
end
#exit
# 
# 
# <TODO> ONLY FOR LINUX FISH SHELL
if not contains "Linux" (uname)
	exit
end
# 
# 
# 
set -x SUPERDEBLENDDIR (dirname (readlink -f (status --current-filename)))
export SUPERDEBLENDDIR
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


