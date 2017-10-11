#!/bin/bash
# 

inputband="850"
inputdate="20160909"
scalelimits="-scale limits -2.0 4.0"
inputname="FIT_goodsn_${inputband}_Map_${inputdate}_Galsub" # no vary for Galsub
inputresults="" # no need for Galsub
outputname="galfit_${inputband}_${inputname}"

mv "${outputname}.eps" "${outputname}.eps.backup" 2>/dev/null

ds9 -geometry 1800x600 -title ${inputband} -multiframe \
    -tile mode column -lock frame wcs -lock scale yes -lock colorbar yes \
    -colorbar fontsize 15 -colorbar font courier -cmap Heat \
     $scalelimits \
     ${inputname}.fits \
    -saveimage eps ${outputname}.eps \
    -saveimage jpeg ${outputname}.jpeg \
    &

while [[ ! -f "${outputname}.eps" ]]; do
    sleep 0.5
done

ps2pdf -dEPSCrop ${outputname}.eps ${outputname}.pdf

