#!/bin/bash
#
# Type_SED is one of the parameters used in our SED fitting. 
# 
# We will compute Type_SED using the input catalog and SED files. 
# 
# Usage: 
#     ./do_Type_SED.sh -catalog RadioOwenMIPS24_priors_dzliu_20160128_Band160.txt -sedresults ResLMT*.txt
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
                 
  "-sedresults") shift
                 while [[ $# -gt 0 ]]; do
                     if [[ "$1" != "-"* ]]; then
                         GALSED_RESULTS=("${GALSED_RESULTS[@]}" "$1")
                     else break; fi; shift
                 done
                 ;;
                 
              *) shift
              
    esac
done

echo GALSED_CATALOG="$GALSED_CATALOG"
echo GALSED_RESULTS="${GALSED_RESULTS[@]}"

# 
# Check variables
# 
if [[ x"$GALSED_CATALOG" == x"" || x"${GALSED_RESULTS[@]}" == x"" ]]; then
    echo ""; echo "Usage: "; echo " ./do_Type_SED.sh -catalog RadioOwenMIPS24_*.txt -sedresults ResLMT*.txt"; echo ""; exit
fi

# 
# Check software
# 
if [[ $(type sm 2>/dev/null) != "sm is "* ]]; then
    echo ""; echo "Error! sm is not installed or not found!"; echo ""; exit 1
fi

if [[ ! -f "do_Type_SED/do_Type_SED.sm" ]]; then
    echo ""; echo "Error! \"do_Type_SED/do_Type_SED.sm\" was not found! Please contact script provider for help!"; echo ""; exit 1
fi

# 
# Write catalog filename to "aaa_input_catalog_file"
# 
if [[ -f "$GALSED_CATALOG" ]]; then
    echo "$GALSED_CATALOG" > "do_Type_SED"/"aaa_input_catalog_file"
    cp "$GALSED_CATALOG" "do_Type_SED"/
    echo "Written to aaa_input_catalog_file!"
else
    echo ""; echo "Error! \"$GALSED_CATALOG\" does not exist!"; echo ""; exit 1
fi

# 
# Write sed results filenames to "aaa_input_sed_files"
# 
for (( i = 0; i<${#GALSED_RESULTS[@]}; i++ )); do
    if [[ -f "${GALSED_RESULTS[$i]}" ]]; then
        if [[ $i == 0 ]]; then 
        echo "${GALSED_RESULTS[$i]}" > "do_Type_SED"/"aaa_input_sed_files"; else 
        echo "${GALSED_RESULTS[$i]}" >> "do_Type_SED"/"aaa_input_sed_files"; fi
        cp "${GALSED_RESULTS[$i]}" "do_Type_SED"/
        echo "Written to aaa_input_sed_files!"
    else
        echo ""; echo "Error! \"${GALSED_RESULTS[$i]}\" does not exist!"; echo ""; exit 1
    fi
done

# 
# Run do_Type_SED.sm
# 
echo "cd into $(dirname ${BASH_SOURCE})/do_Type_SED/"; echo "sm <<< \"macro read do_Type_SED.sm do_Type_SED\""; echo "-----------------------------------------------------------------------------"
bash -c "cd $(dirname ${BASH_SOURCE})/do_Type_SED/; sm <<< \"macro read do_Type_SED.sm do_Type_SED\""; echo "-----------------------------------------------------------------------------"

# 
# Copy coo_SED.txt coo_SED.log
# 
echo "Copying do_Type_SED/{coo_SED.txt,coo_SED.log} to current dir"
if [ -f "coo_SED.txt" ]; then mv "coo_SED.txt" "backup.coo_SED.txt"; echo "Backuped coo_SED.txt as backup.coo_SED.txt!"; fi
if [ -f "coo_SED.log" ]; then mv "coo_SED.log" "backup.coo_SED.log"; echo "Backuped coo_SED.log as backup.coo_SED.log!"; fi
cp "do_Type_SED"/"coo_SED.txt" .
cp "do_Type_SED"/"coo_SED.log" .
echo "Copied do_Type_SED/{coo_SED.txt,coo_SED.log} to current dir!"

# 
# Done!
# 
echo "Done!"






