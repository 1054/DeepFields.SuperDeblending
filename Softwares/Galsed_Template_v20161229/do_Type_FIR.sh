#!/bin/bash
#
# Type_FIR is one of the parameters used in our SED fitting. 
# 
# We will compute Type_FIR using the input catalog and SED files. 
# 
# Usage: 
#     ./do_Type_FIR.sh -catalog RadioOwenMIPS24_priors_dzliu_20160128_Band160.txt
# 

# 
# Prepare Variables
# 

GALSED_CATALOG=""
GALSED_RESULTS=()

# 
# Read inputs
# 
while [[ $# -gt 0 ]]; do
    
    case "$1" in
                
     "-catalog") shift
                 while [[ $# -gt 0 ]]; do
                     if [[ "$1" != "-"* ]]; then
                         GALSED_CATALOG="$1"
                     else break; fi; shift
                 done
                 ;;
                 
              *) shift
              
    esac
done

echo GALSED_CATALOG="$GALSED_CATALOG"

# 
# Check variables
# 
if [[ x"$GALSED_CATALOG" == x"" ]]; then
    echo ""; echo "Usage: "; echo " ./do_Type_FIR.sh -catalog RadioOwenMIPS24_*.txt"; echo ""; exit
fi

# 
# Check software
# 
if [[ $(type sm 2>/dev/null) != "sm is "* ]]; then
    echo ""; echo "Error! sm is not installed or not found!"; echo ""; exit 1
fi

if [[ ! -f "do_Type_FIR/do_Type_FIR.sm" ]]; then
    echo ""; echo "Error! \"do_Type_FIR/do_Type_FIR.sm\" was not found! Please contact script provider for help!"; echo ""; exit 1
fi

# 
# Write catalog filename to "aaa_input_catalog_file"
# 
if [[ -f "$GALSED_CATALOG" ]]; then
    echo "$GALSED_CATALOG" > "do_Type_FIR"/"aaa_input_catalog_file"
    cp "$GALSED_CATALOG" "do_Type_FIR"/
    echo "Written to aaa_input_catalog_file!"
else
    echo ""; echo "Error! \"$GALSED_CATALOG\" does not exist!"; echo ""; exit 1
fi

# 
# Run do_Type_FIR.sm
# 
echo "cd into $(dirname ${BASH_SOURCE})/do_Type_FIR/"; echo "sm <<< \"macro read do_Type_FIR.sm do_Type_FIR\""; echo "-----------------------------------------------------------------------------"
bash -c "cd $(dirname ${BASH_SOURCE})/do_Type_FIR/; sm <<< \"macro read do_Type_FIR.sm do_Type_FIR\""; echo "-----------------------------------------------------------------------------"

# 
# Copy coo_FIR.txt coo_FIR.log
# 
echo "Copying do_Type_FIR/{coo_FIR.txt,coo_FIR.log} to current dir"
if [ -f "coo_FIR.txt" ]; then mv "coo_FIR.txt" "backup.coo_FIR.txt"; echo "Backuped coo_FIR.txt as backup.coo_FIR.txt!"; fi
if [ -f "coo_FIR.log" ]; then mv "coo_FIR.log" "backup.coo_FIR.log"; echo "Backuped coo_FIR.log as backup.coo_FIR.log!"; fi
cp "do_Type_FIR"/"coo_FIR.txt" .
cp "do_Type_FIR"/"coo_FIR.log" .
echo "Copied do_Type_FIR/{coo_FIR.txt,coo_FIR.log} to current dir!"

# 
# Done!
# 
echo "Done!"






