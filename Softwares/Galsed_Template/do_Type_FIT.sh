#!/bin/bash
#
# Type_AGN is one of the parameters used in our SED fitting. 
# 
# We will compute Type_AGN using the input catalog and SED files. 
# 
# Usage: 
#     ./do_Type_FIT.sh -catalog RadioOwenMIPS24_priors_dzliu_20160128_Band160.txt -sedresults ResLMT*.txt
# 

# 
# Prepare Variables
# 

GALSED_CATALOG=""
GALSED_RESULTS=()
GALSED_FIELD="GOODSN"
GALSED_BAND=""
GALSED_FCUT=""

# 
# Read inputs
# 
while [[ $# -gt 0 ]]; do
    
    case "$1" in
                
        "-field") shift
                 while [[ $# -gt 0 ]]; do
                     if [[ "$1" != "-"* ]]; then
                         GALSED_FIELD="$1"
                     else break; fi; shift
                 done
                 ;;
                
        "-band") shift
                 while [[ $# -gt 0 ]]; do
                     if [[ "$1" != "-"* ]]; then
                         GALSED_BAND="$1"
                     else break; fi; shift
                 done
                 ;;
                
        "-fcut") shift
                 while [[ $# -gt 0 ]]; do
                     if [[ "$1" != "-"* ]]; then
                         GALSED_FCUT="$1"
                     else break; fi; shift
                 done
                 ;;
                
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

echo GALSED_FIELD="$GALSED_FIELD"
echo GALSED_BAND="$GALSED_BAND"
echo GALSED_FCUT="$GALSED_FCUT"
echo GALSED_CATALOG="$GALSED_CATALOG"
echo GALSED_RESULTS="${GALSED_RESULTS[@]}"

# 
# Check variables
# 
if [[ x"$GALSED_FIELD" == x"" || x"$GALSED_BAND" == x"" || x"$GALSED_FCUT" == x"" || x"$GALSED_CATALOG" == x"" || x"${GALSED_RESULTS[@]}" == x"" ]]; then
    echo ""; echo "Usage: "; echo " ./do_Type_FIT.sh -field goodsn -band 100 -fcut 0.5 -catalog RadioOwenMIPS24_*.txt -sedresults ResLMT*.txt"; echo ""; exit
fi

# 
# Check software
# 
if [[ $(type sm 2>/dev/null) != "sm is "* ]]; then
    echo ""; echo "Error! sm is not installed or not found!"; echo ""; exit 1
fi

if [[ ! -f "do_Type_FIT/do_Type_FIT.sm" ]]; then
    echo ""; echo "Error! \"do_Type_FIT/do_Type_FIT.sm\" was not found! Please contact script provider for help!"; echo ""; exit 1
fi

# 
# Write catalog filename to "aaa_input_catalog_file"
# 
if [[ -f "$GALSED_CATALOG" ]]; then
    echo "$GALSED_CATALOG" > "do_Type_FIT"/"aaa_input_catalog_file"
    cp "$GALSED_CATALOG" "do_Type_FIT"/
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
        echo "${GALSED_RESULTS[$i]}" > "do_Type_FIT"/"aaa_input_sed_files"; else 
        echo "${GALSED_RESULTS[$i]}" >> "do_Type_FIT"/"aaa_input_sed_files"; fi
        cp "${GALSED_RESULTS[$i]}" "do_Type_FIT"/
        echo "Written to aaa_input_sed_files!"
    else
        echo ""; echo "Error! \"${GALSED_RESULTS[$i]}\" does not exist!"; echo ""; exit 1
    fi
done

# 
# Backup files
# 
if [[ -f "do_Type_FIT/SED_predictions_$GALSED_BAND.txt" ]]; then mv "do_Type_FIT/SED_predictions_$GALSED_BAND.txt" "do_Type_FIT/backup.SED_predictions_$GALSED_BAND.txt"; fi
if [[ -f "do_Type_FIT/SED_predictions_$GALSED_BAND.log" ]]; then mv "do_Type_FIT/SED_predictions_$GALSED_BAND.log" "do_Type_FIT/backup.SED_predictions_$GALSED_BAND.log"; fi
if [[ -f "do_Type_FIT/log_cutting_flux_$GALSED_BAND.txt" ]]; then mv "do_Type_FIT/log_cutting_flux_$GALSED_BAND.txt" "do_Type_FIT/backup.log_cutting_flux_$GALSED_BAND.txt"; fi
if [[ -f "do_Type_FIT/plot_cutting_flux_$GALSED_BAND.pdf" ]]; then mv "do_Type_FIT/plot_cutting_flux_$GALSED_BAND.pdf" "do_Type_FIT/backup.plot_cutting_flux_$GALSED_BAND.pdf"; fi

# 
# Run do_Type_FIT.sm
# 
echo "cd into $(dirname ${BASH_SOURCE})/do_Type_FIT/"; echo "sm <<< \"macro read do_Type_FIT.sm go $GALSED_FIELD $GALSED_BAND $GALSED_FCUT\""; echo "-----------------------------------------------------------------------------"
bash -c "cd $(dirname ${BASH_SOURCE})/do_Type_FIT/; sm <<< \"macro read do_Type_FIT.sm go $GALSED_FIELD $GALSED_BAND $GALSED_FCUT\""; echo "-----------------------------------------------------------------------------"

# 
# Print message
# 
if [[ -f "do_Type_FIT/SED_predictions_$GALSED_BAND.txt" && \
      -f "do_Type_FIT/SED_predictions_$GALSED_BAND.log" && \
      -f "do_Type_FIT/log_cutting_flux_$GALSED_BAND.txt" && \
      -f "do_Type_FIT/plot_cutting_flux_$GALSED_BAND.pdf" ]]; then
    echo ""
    echo "Please find new SED prediction files and plots:"
    echo "    do_Type_FIT/SED_predictions_$GALSED_BAND.txt"
    echo "    do_Type_FIT/SED_predictions_$GALSED_BAND.log"
    echo "    do_Type_FIT/log_cutting_flux_$GALSED_BAND.txt"
    echo "    do_Type_FIT/plot_cutting_flux_$GALSED_BAND.pdf"
    echo ""
else
    echo ""
    echo "Oops! Seems something is wrong! Please check the input agruments and rerun this script. "
    echo ""
    exit 1
fi

# 
# Done!
# 
echo "Done!"






