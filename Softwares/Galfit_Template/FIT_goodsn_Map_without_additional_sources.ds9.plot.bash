#!/bin/bash
#

inputband="850"
inputdate="20160909"
scalelimits="-scale limits -2.0 4.0"
inputname="FIT_goodsn_${inputband}_Map_${inputdate}_vary" # make sure add _vary for band 100, 160 and 850
inputresults="results_${inputband}_${inputdate}_vary__fluxes"
outputname="galfit_${inputband}_${inputname}_without_additional_sources"

mv "${outputname}.eps" "${outputname}.eps.backup" 2>/dev/null

head -n 1 "run_sextractor/DS9_regions_additional.reg" > "run_sextractor/DS9_regions_additional_${inputband}_only.reg"
cat "run_sextractor/DS9_regions_additional.reg" | grep "text={${inputband}" | sed -e 's/color=red/color=green/g' | sed -e 's/dash=0/dash=0 width=2/g' >> "run_sextractor/DS9_regions_additional_${inputband}_only.reg"

ds9 -geometry 1800x600 -title ${inputband} -multiframe \
    -tile mode column -lock frame wcs -lock scale yes -lock colorbar yes \
    -colorbar fontsize 15 -colorbar font courier -cmap Heat \
     $scalelimits \
     ${inputname}.fits \
    -region load run_sextractor/DS9_regions_additional_${inputband}_only.reg \
    -saveimage eps ${outputname}.eps \
    -saveimage jpeg ${outputname}.jpeg \
    &

while [[ ! -f "${outputname}.eps" ]]; do
    sleep 0.5
done

ps2pdf -dEPSCrop ${outputname}.eps ${outputname}.pdf

