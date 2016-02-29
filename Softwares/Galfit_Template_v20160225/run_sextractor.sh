#!/bin/bash
#
# In this script we will run sextractor to extract
# new sources from the residual image and make new
# trial fitting list for galfit fitting. 
# 
# Usage:
#    ./run_sextractor.sh -band 250 -catalog-old Residual_priors_Band160_Revised.txt -catalog-output Residual_priors_Band250_Trial.txt -fitresults-map FIT_goodsn_250_Map_201601.fits -rms-map spire250_rms_3p6_v0_100615.fits -detect-thresh 1.5 -detect-minarea 2
# 

# 
# Prepare Variables
# 

GALFIT_CATALOG_OLD=""
GALFIT_CATALOG_OUT=""
GALFIT_RESULTS_MAP=""
GALFIT_FITTING_RMS=""
GALFIT_BAND=""
SEXTRACTOR_DETECT_THRESH=1.5
SEXTRACTOR_DETECT_MINAREA=2

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
                      
         "-rms-map"*) shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              GALFIT_FITTING_RMS="$1"
                          else break; fi; shift
                      done
                      ;;
                      
  "-fitresults-map"*) shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              GALFIT_RESULTS_MAP="$1"
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
                      
  "-detect-minarea"*) shift
                      while [[ $# -gt 0 ]]; do
                          if [[ "$1" != "-"* ]]; then
                              SEXTRACTOR_DETECT_MINAREA=$1
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
echo GALFIT_RESULTS_MAP="$GALFIT_RESULTS_MAP"
echo GALFIT_FITTING_RMS="$GALFIT_FITTING_RMS"

# 
# Check variables
# 
if [[ x"$GALFIT_BAND" == x"" || x"$GALFIT_CATALOG_OUT" == x"" || x"$GALFIT_RESULTS_MAP" == x"" || x"$GALFIT_FITTING_RMS" == x"" ]]; then
    echo ""; echo "Usage: "; echo " ./run_sextractor.sh -band 250 -catalog-old Residual_priors_Band160_Revised.txt -catalog-output Residual_priors_Band250_Trial.txt -fitresults-map FIT_goodsn_250_Map_201601.fits -rms-map spire250_rms_3p6_v0_100615.fits -detect-thresh 1.5 -detect-minarea 2"; echo ""; exit
fi
if [[ x"$GALFIT_CATALOG_OLD" == x"" ]]; then
    echo ""; echo "*******"; echo "Warning!: "; echo "No -catalog-old was given."; echo "*******"; echo ""
fi

# 
# Check software
# 
if [[ $(type sm 2>/dev/null) != "sm is "* ]]; then
    echo ""; echo "Error! sm is not installed or not found!"; echo ""; exit 1
fi

if [[ $(type idl 2>/dev/null) != "idl is "* ]]; then
    echo ""; echo "Error! idl is not installed or not found!"; echo ""; exit 1
fi

if [[ $(type CrabTable2ds9reg 2>/dev/null) != "CrabTable2ds9reg is "* ]]; then
    echo ""; echo "Error! CrabTable2ds9reg is not installed or not found! Did you forgot to \"source /dsm/upgal/data/dliu/Superdeblending/Softwares/SETUP\"?"; echo ""; exit 1
fi

if [[ ! -f "run_sextractor/do_sextract_mask.pro" ]]; then
    echo ""; echo "Error! \"run_sextractor/do_sextract_mask.pro\" was not found! Please contact script provider for help!"; echo ""; exit 1
fi

if [[ ! -f "run_sextractor/do_sextract_result.sm" ]]; then
    echo ""; echo "Error! \"run_sextractor/do_sextract_result.sm\" was not found! Please contact script provider for help!"; echo ""; exit 1
fi

# 
# Write catalog-additional filename to "aaa_input_residual_prior_file"
# 
if [[ x"$GALFIT_CATALOG_OLD" != x"" ]]; then
    if [[ -f "$GALFIT_CATALOG_OLD" ]]; then
        echo "$GALFIT_CATALOG_OLD" > "run_sextractor"/"aaa_input_residual_prior_file"
        cp "$GALFIT_CATALOG_OLD" "run_sextractor"/
        echo "Written to aaa_input_residual_prior_file!"
    else
        echo ""; echo "Error! \"$GALFIT_CATALOG_OLD\" does not exist!"; echo ""; exit 1
    fi
else
    if [[ -f "run_sextractor"/"aaa_input_residual_prior_file" ]]; then
        rm "run_sextractor"/"aaa_input_residual_prior_file"
    fi
fi

# 
# Write catalog-additional output new filename to "aaa_output_residual_prior_file"
# 
if [[ -f "$GALFIT_CATALOG_OUT" ]]; then
    mv "$GALFIT_CATALOG_OUT" "backup.$GALFIT_CATALOG_OUT"
fi
    echo "$GALFIT_CATALOG_OUT" > "run_sextractor"/"aaa_output_residual_prior_file"
    echo "Written to aaa_output_residual_prior_file!"
    echo "$GALFIT_CATALOG_LOG" > "run_sextractor"/"aaa_output_residual_prior_log"
    echo "Written to aaa_output_residual_prior_log!"

# 
# Write galfit rms map filename to "aaa_input_fitting_rms_file"
# 
if [[ -f "$GALFIT_FITTING_RMS" ]]; then
    echo "$GALFIT_FITTING_RMS" > "run_sextractor"/"aaa_input_fitting_rms_file"
    cp "$GALFIT_FITTING_RMS" "run_sextractor"/
    echo "Written to aaa_input_fitting_rms_file!"
else
    echo ""; echo "Error! \"$GALFIT_FITTING_RMS\" does not exist!"; echo ""; exit 1
fi

# 
# Write galfit output map filename to "aaa_input_result_map_file"
# 
if [[ -f "$GALFIT_RESULTS_MAP" ]]; then
    echo "$GALFIT_RESULTS_MAP" > "run_sextractor"/"aaa_input_result_map_file"
    cp "$GALFIT_RESULTS_MAP" "run_sextractor"/
    echo "Written to aaa_input_result_map_file!"
else
    echo ""; echo "Error! \"$GALFIT_RESULTS_MAP\" does not exist!"; echo ""; exit 1
fi

# 
# Run do_sextract_mask.pro
# 
echo "cd into $(dirname ${BASH_SOURCE})/run_sextractor/"; echo "idl -e 'do_SExtract_Mask, FITPhoto = \"$GALFIT_RESULTS_MAP\", RMSPhoto = \"$GALFIT_FITTING_RMS\"'"; echo "-----------------------------------------------------------------------------"
bash -c "cd $(dirname ${BASH_SOURCE})/run_sextractor/; idl -e 'do_SExtract_Mask, FITPhoto = \"$GALFIT_RESULTS_MAP\", RMSPhoto = \"$GALFIT_FITTING_RMS\"'"; echo "-----------------------------------------------------------------------------"

# 
# Show ds9
# 
read -p "Do you want to launch ds9 to examine the input maps? [y/n] " GALFIT_DS9_OK
if [[ "$GALFIT_DS9_OK" == "y"* ]]; then
    echo    "cd $(dirname ${BASH_SOURCE})/run_sextractor/; ds9 -mecube -tile mode column -lock frame wcs \"$GALFIT_RESULTS_MAP\" SExtractor_Signal.fits SExtractor_Noise.fits SExtractor_Weight.fits"
    bash -c "cd $(dirname ${BASH_SOURCE})/run_sextractor/; ds9 -mecube -tile mode column -lock frame wcs \"$GALFIT_RESULTS_MAP\" SExtractor_Signal.fits SExtractor_Noise.fits SExtractor_Weight.fits"
fi

# 
# Run sextractor
# 
echo    "cd $(dirname ${BASH_SOURCE})/run_sextractor/; sex SExtractor_Signal.fits -DETECT_THRESH $SEXTRACTOR_DETECT_THRESH -DETECT_MINAREA $SEXTRACTOR_DETECT_MINAREA"
bash -c "cd $(dirname ${BASH_SOURCE})/run_sextractor/; sex SExtractor_Signal.fits -DETECT_THRESH $SEXTRACTOR_DETECT_THRESH -DETECT_MINAREA $SEXTRACTOR_DETECT_MINAREA"

# 
# Run sextractor
# 
echo    "cd $(dirname ${BASH_SOURCE})/run_sextractor/; CrabTable2ds9reg SExtractor_OutputList.txt SExtractor_OutputList.ds9.reg -xy2sky SExtractor_Signal.fits"
bash -c "cd $(dirname ${BASH_SOURCE})/run_sextractor/; CrabTable2ds9reg SExtractor_OutputList.txt SExtractor_OutputList.ds9.reg -xy2sky SExtractor_Signal.fits"

# 
# Show ds9
# 
read -p "Do you want to launch ds9 to examine the result maps? [y/n] " GALFIT_DS9_OK
if [[ "$GALFIT_DS9_OK" == "y"* ]]; then
    echo    "cd $(dirname ${BASH_SOURCE})/run_sextractor/; ds9 -tile mode column -lock frame wcs -lock scale yes -lock colorbar yes SExtractor_Signal.fits SExtractor_Model.fits -region load SExtractor_OutputList.ds9.reg SExtractor_ModelRev.fits"
    bash -c "cd $(dirname ${BASH_SOURCE})/run_sextractor/; ds9 -tile mode column -lock frame wcs -lock scale yes -lock colorbar yes SExtractor_Signal.fits SExtractor_Model.fits -region load SExtractor_OutputList.ds9.reg SExtractor_ModelRev.fits"
fi

# 
# Run do_sextract_result.sm
# 
echo    "cd into $(dirname ${BASH_SOURCE})/run_sextractor/"; echo "sm <<< \"macro read do_sextract_result.sm go $GALFIT_BAND\""; echo "-----------------------------------------------------------------------------"
bash -c "cd $(dirname ${BASH_SOURCE})/run_sextractor/; sm <<< \"macro read do_sextract_result.sm go $GALFIT_BAND\""; echo "-----------------------------------------------------------------------------"

# 
# Print message
# 
echo "Please check the output files and figures:"
ls "run_sextractor"/*
echo "cd $(dirname ${BASH_SOURCE})/run_sextractor/; ds9 -tile mode column -lock frame wcs -lock scale yes -lock colorbar yes SExtractor_Signal.fits SExtractor_Model.fits -region load SExtractor_OutputList.ds9.reg SExtractor_ModelRev.fits"

# 
# Done!
# 
echo "Done!"










