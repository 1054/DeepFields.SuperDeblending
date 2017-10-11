#!/bin/bash
#

inputband="850"
inputdate="20160909"
scalelimits="-scale limits -2.0 4.0"
inputname="FIT_goodsn_${inputband}_Map_${inputdate}_vary" # make sure add _vary for band 100, 160 and 850
inputresults="results_${inputband}_${inputdate}_vary__fluxes"
outputname="galfit_${inputband}_${inputname}_with_additional_sources"

mv "${outputname}.eps" "${outputname}.eps.backup" 2>/dev/null

cp -r "/home/dzliu/Cloud/Github/DeepFields.SuperDeblending/Softwares/Galfit_Template_v20160225/run_make_ds9_regions" .
cd "run_make_ds9_regions"
echo "macro read run_make_ds9_regions.sm run_make_ds9_regions ${inputband} ${inputdate}" | sm
cd "../"

ds9 -geometry 1800x600 -title ${inputband} -multiframe \
    -tile mode column -lock frame wcs -lock scale yes -lock colorbar yes \
    -colorbar fontsize 15 -colorbar font courier -cmap Heat \
     $scalelimits \
     ${inputname}.fits \
    -frame 1 \
    -region showtext no \
    -region load ${inputresults}_catalog_sources.ds9.reg \
    -region load ${inputresults}_additional_sources.ds9.reg \
    -saveimage eps ${outputname}.eps \
    -saveimage jpeg ${outputname}.jpeg \
    &

while [[ ! -f "${outputname}.eps" ]]; do
    sleep 0.5
done

ps2pdf -dEPSCrop ${outputname}.eps ${outputname}.pdf

