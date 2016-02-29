#!/bin/bash
#
# In this script we will run post analysis to see how many
# sources that we extracted from the residual image and added
# to the fitting list could get detected by galfit fitting. 
# 
# Usage:
#    ./run_sextractor_postanalysis.sh -band 250 -catalog-old Residual_priors_Band250_Trial.txt -catalog-output Residual_priors_Band250_Revised.txt -fitresults-flux results_250_201601__fluxes.txt -sedpredict SED_predictions_250.txt -detect-thresh 3.0
# 

# 
# Prepare Variables
# 

GALFIT_CATALOG_OLD=""
GALFIT_CATALOG_OUT=""
GALFIT_RESULTS_FLX=""
GALFIT_PREDICT_SED=""
GALFIT_BAND=""
SEXTRACTOR_DETECT_THRESH=3.0 # This is actually the S/N that we want to keep residual sources. 

# 
# Read inputs
# 
while [[ $# -gt 0 ]]; do
    
    case "$1" in
                     
             "-band") shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              GALFIT_BAND="$1"
                          else break; fi; shift
                      done
                      ;;
                     
     "-catalog-old"*) shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              GALFIT_CATALOG_OLD="$1"
                          else break; fi; shift
                      done
                      ;;
                     
     "-catalog-out"*) shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              GALFIT_CATALOG_OUT="$1"
                          else break; fi; shift
                      done
                      ;;
                      
 "-fitresults-flux"*) shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              GALFIT_RESULTS_FLX="$1"
                          else break; fi; shift
                      done
                      ;;
                      
  "-detect-thresh"*) shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              SEXTRACTOR_DETECT_THRESH=$1
                          else break; fi; shift
                      done
                      ;;
                     
      "-sedpredict"*) shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              GALFIT_PREDICT_SED="$1"
                          else break; fi; shift
                      done
                      ;;
                      
                   *) shift
                   
    esac
done

GALFIT_CATALOG_LOG=$(echo $GALFIT_CATALOG_OUT | sed -e 's%.txt$%.log%g')

echo GALFIT_CATALOG_OLD="$GALFIT_CATALOG_OLD"
echo GALFIT_CATALOG_OUT="$GALFIT_CATALOG_OUT"
echo GALFIT_CATALOG_LOG="$GALFIT_CATALOG_LOG"
echo GALFIT_RESULTS_FLX="$GALFIT_RESULTS_FLX"

# 
# Check variables
# 
if [[ x"$GALFIT_BAND" == x"" || x"$GALFIT_CATALOG_OLD" == x"" || x"$GALFIT_CATALOG_OUT" == x"" || x"$GALFIT_RESULTS_FLX" == x"" || x"$GALFIT_PREDICT_SED" == x"" ]]; then
    echo ""; echo "Usage: "; echo " ./run_sextractor_postanalysis.sh -band 250 -catalog-old Residual_priors_Band250_Trial.txt -catalog-output Residual_priors_Band250_Revised.txt -fitresults-flux results_250_201601_WithAddSources_Pass1__fluxes.txt -sedpredict SED_predictions_250.txt -detect-thresh 3.0"; echo ""; exit
fi

# 
# Check software
# 
if [[ $(type sm 2>/dev/null) != "sm is "* ]]; then
    echo ""; echo "Error! sm is not installed or not found!"; echo ""; exit 1
fi

if [[ ! -f "run_sextractor_postanalysis/do_sextract_postanalysis.sm" ]]; then
    echo ""; echo "Error! \"run_sextractor_postanalysis/do_sextract_postanalysis.sm\" was not found! Please contact script provider for help!"; echo ""; exit 1
fi

# 
# Write catalog-olditional filename to "aaa_input_residual_prior_file"
# 
if [[ -f "$GALFIT_CATALOG_OLD" ]]; then
    echo "$GALFIT_CATALOG_OLD" > "run_sextractor_postanalysis"/"aaa_input_residual_prior_file"
    cp "$GALFIT_CATALOG_OLD" "run_sextractor_postanalysis"/
    echo "Written to aaa_input_residual_prior_file!"
else
    echo ""; echo "Error! \"$GALFIT_CATALOG_OLD\" does not exist!"; echo ""; exit 1
fi

# 
# Write catalog-olditional output new filename to "aaa_output_residual_prior_file"
# 
if [[ -f "$GALFIT_CATALOG_OUT" ]]; then
    mv "$GALFIT_CATALOG_OUT" "backup.$GALFIT_CATALOG_OUT"
fi
    echo "$GALFIT_CATALOG_OUT" > "run_sextractor_postanalysis"/"aaa_output_residual_prior_file"
    echo "Written to aaa_output_residual_prior_file!"
    echo "$GALFIT_CATALOG_LOG" > "run_sextractor_postanalysis"/"aaa_output_residual_prior_log"
    echo "Written to aaa_output_residual_prior_log!"

# 
# Write galfit results-fluxes filename to "aaa_input_result_flux_file"
# 
if [[ -f "$GALFIT_RESULTS_FLX" ]]; then
    echo "\"$GALFIT_RESULTS_FLX\"" > "run_sextractor_postanalysis"/"aaa_input_result_flux_file"
    cp "$GALFIT_RESULTS_FLX" "run_sextractor_postanalysis"/
    echo "Written to aaa_input_result_flux_file!"
else
    echo ""; echo "Error! \"$GALFIT_RESULTS_FLX\" does not exist!"; echo ""; exit 1
fi

# 
# Write SED predictions filename to "aaa_input_sed_prediction_file"
# 
if [[ -f "$GALFIT_PREDICT_SED" ]]; then
    echo "$GALFIT_PREDICT_SED" > "run_sextractor_postanalysis"/"aaa_input_sed_prediction_file"
    cp "$GALFIT_PREDICT_SED" "run_sextractor_postanalysis"/
    echo "Written to aaa_input_sed_prediction_file!"
else
    echo ""; echo "Error! \"$GALFIT_PREDICT_SED\" does not exist!"; echo ""; exit 1
fi

# 
# Run do_sextract_postanalysis.sm
# 
echo "cd into $(dirname ${BASH_SOURCE})/run_sextractor_postanalysis/"; echo "sm <<< \"macro read do_sextract_postanalysis.sm go $GALFIT_BAND $SEXTRACTOR_DETECT_THRESH\""; echo "-----------------------------------------------------------------------------"
bash -c "cd $(dirname ${BASH_SOURCE})/run_sextractor_postanalysis/; sm <<< \"macro read do_sextract_postanalysis.sm go $GALFIT_BAND $SEXTRACTOR_DETECT_THRESH\""; echo "-----------------------------------------------------------------------------"

# 
# Print message
# 
echo "Please check the output files and figures:"
ls "run_sextractor_postanalysis"/*

# 
# Done!
# 
echo "Done!"










