#!/bin/bash
# 

# 
# Define ID
# 

SourceID="14896"
SourceRA="188.9751587"
SourceDec="62.1787071"
SourceDir="ID14896_blending_demonstration"

# 
# start ds9
# 

DS9_TITLE="goodsn"
ds9 -title "$DS9_TITLE" -tile yes -tile mode grid -tile grid layout 2 4 -width 600 -height 800 -lock frame wcs -lock colorbar yes &

# 
# Get fits file list
# 

FitsFileList=($(cat aaa_ds9_photos | grep -v "^#" | sed -e 's/^ *//g' | tr -s ' ' | cut -d ' ' -f 1))
echo "Reading ${#FitsFileList[@]} fits files"

# 
# Wait for ds9 
# 

echo -n "Starting ds9 $DS9_TITLE"
while [[ $(xpaget "$DS9_TITLE" frame active 2>&1 | grep "ERROR" | wc -l) -eq 1 ]]; do 
    sleep 1.0
    echo -n "."
done
echo ""

# 
# ds9 load fits images
# 

for (( i=0; i<${#FitsFileList[@]}; i++ )); do
    
    FitsFileName=$(echo "${FitsFileList[$i]}" | sed -e 's/.fits$//g')
    
    if [[ $i == 0 ]]; then 
        xpaset -p "$DS9_TITLE" frame 1
    else
        xpaset -p "$DS9_TITLE" frame new
    fi
    
    echo xpaset -p "$DS9_TITLE" fits "$FitsFileName.fits"
         xpaset -p "$DS9_TITLE" fits "$FitsFileName.fits"
    
    #if [[ x"$iraf" != x ]]; then
        
        #if [[ ! -f "$FitsFileName.imstat.txt" && $(du "$FitsFileName.fits" | cut -f 1) -lt 256000 ]]; then
        #    CrabPhotImageStatistics "$FitsFileName.fits" > "$FitsFileName.imstat.txt"
        #fi
        
        if [[ -f "$FitsFileName.imstat.txt" ]]; then
            
            DS9_PIXLOW=$(cat "$FitsFileName.imstat.txt" | grep -v "^#" | sed -e 's/^ *//g' | tr -s ' ' | cut -d ' ' -f 8)
            DS9_PIXHIGH=$(cat "$FitsFileName.imstat.txt" | grep -v "^#" | sed -e 's/^ *//g' | tr -s ' ' | cut -d ' ' -f 9)
            
            xpaset -p "$DS9_TITLE" scale limits $(bc -l <<< "$DS9_PIXLOW/2.0") $(bc -l <<< "$DS9_PIXHIGH/2.0")
            echo                   scale limits $(bc -l <<< "$DS9_PIXLOW/2.0") $(bc -l <<< "$DS9_PIXHIGH/2.0")
            
            if [[ "$FitsFileName" == *"MIPS/"* ]]; then
                xpaset -p "$DS9_TITLE" scale limits $(bc -l <<< "$DS9_PIXLOW/1.5") $(bc -l <<< "$DS9_PIXHIGH/0.5")
                echo                   scale limits $(bc -l <<< "$DS9_PIXLOW/1.5") $(bc -l <<< "$DS9_PIXHIGH/0.5")
            fi
            if [[ "$FitsFileName" == *"IRSX/"* ]]; then
                xpaset -p "$DS9_TITLE" scale limits $(bc -l <<< "$DS9_PIXLOW/1.5") $(bc -l <<< "$DS9_PIXHIGH/0.5")
                echo                   scale limits $(bc -l <<< "$DS9_PIXLOW/1.5") $(bc -l <<< "$DS9_PIXHIGH/0.5")
            fi
            if [[ "$FitsFileName" == *"PACS/"* ]]; then
                xpaset -p "$DS9_TITLE" scale limits $(bc -l <<< "$DS9_PIXLOW/15.") $(bc -l <<< "$DS9_PIXHIGH/6.5")
                echo                   scale limits $(bc -l <<< "$DS9_PIXLOW/15.") $(bc -l <<< "$DS9_PIXHIGH/6.5")
            fi
            if [[ "$FitsFileName" == *"PACS/pgh_goodsn_red"* ]]; then
                xpaset -p "$DS9_TITLE" scale limits $(bc -l <<< "$DS9_PIXLOW/18.") $(bc -l <<< "$DS9_PIXHIGH/5.5")
                echo                   scale limits $(bc -l <<< "$DS9_PIXLOW/18.") $(bc -l <<< "$DS9_PIXHIGH/5.5")
            fi
            if [[ "$FitsFileName" == *"SPIRE/spire250"* ]]; then
                xpaset -p "$DS9_TITLE" scale limits 0.000 0.0300
                echo                   scale limits 0.000 0.0300
            fi
            if [[ "$FitsFileName" == *"SPIRE/spire350"* ]]; then
                xpaset -p "$DS9_TITLE" scale limits 0.002 0.0275
                echo                   scale limits 0.002 0.0275
            fi
            if [[ "$FitsFileName" == *"SPIRE/spire500"* ]]; then
                xpaset -p "$DS9_TITLE" scale limits 0.008 0.0275
                echo                   scale limits 0.008 0.0275
            fi
            if [[ "$FitsFileName" == *"AZTEC/"* ]]; then
                xpaset -p "$DS9_TITLE" scale limits $(bc -l <<< "$DS9_PIXLOW/3.5") $(bc -l <<< "$DS9_PIXHIGH/1.5")
                echo                   scale limits $(bc -l <<< "$DS9_PIXLOW/3.5") $(bc -l <<< "$DS9_PIXHIGH/1.5")
            fi
        fi
        
        #xpaset -p "$DS9_TITLE" cmap value 4.0 0.4
        
    #fi
    
    xpaset -p "$DS9_TITLE" region showtext no
    
done

# 
# ds9 load regions
# 

xpaset -p "$DS9_TITLE" frame 2
#xpaset -p "$DS9_TITLE" pan to $(cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v5_201500/ds9.mips.fk5.reg" | grep "text={ID${SourceID}}" | sed -e 's/[)(,]/ /g' | cut -d ' ' -f 2,3) fk5
xpaset -p "$DS9_TITLE" pan to $SourceRA $SourceDec fk5
xpaset -p "$DS9_TITLE" zoom to 5

#xpaset -p "$DS9_TITLE" frame 1
#xpaset -p "$DS9_TITLE" region load "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v5_201500/ds9.mips.fk5.reg"

#xpaset -p "$DS9_TITLE" frame 2
#xpaset -p "$DS9_TITLE" region load "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v5_201500/ds9.mips.fk5.reg"

#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160725_850um/cat_24.ds9.reg"       | sed -e 's/color=yellow/color=green  width=2/g'  > "$SourceDir/cat_24.ds9.reg"
#
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_100_detected.ds9.reg"   | sed -e 's/color=yellow/color=green  width=2/g'  > "$SourceDir/cat_100_detected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_100_undetected.ds9.reg" | sed -e 's/color=yellow/color=green  width=1/g'  > "$SourceDir/cat_100_undetected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_100_unfitted.ds9.reg"   | sed -e 's/color=yellow/color=orange width=1/g'  > "$SourceDir/cat_100_unfitted.ds9.reg"
#
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_160_detected.ds9.reg"   | sed -e 's/color=yellow/color=green  width=2/g'  > "$SourceDir/cat_160_detected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_160_undetected.ds9.reg" | sed -e 's/color=yellow/color=green  width=1/g'  > "$SourceDir/cat_160_undetected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_160_unfitted.ds9.reg"   | sed -e 's/color=yellow/color=orange width=1/g'  > "$SourceDir/cat_160_unfitted.ds9.reg"
#
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_250_detected.ds9.reg"   | sed -e 's/color=yellow/color=green  width=2/g'  > "$SourceDir/cat_250_detected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_250_undetected.ds9.reg" | sed -e 's/color=yellow/color=green  width=1/g'  > "$SourceDir/cat_250_undetected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_250_unfitted.ds9.reg"   | sed -e 's/color=yellow/color=orange width=1/g'  > "$SourceDir/cat_250_unfitted.ds9.reg"
#
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_350_detected.ds9.reg"   | sed -e 's/color=yellow/color=green  width=2/g'  > "$SourceDir/cat_350_detected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_350_undetected.ds9.reg" | sed -e 's/color=yellow/color=green  width=1/g'  > "$SourceDir/cat_350_undetected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_350_unfitted.ds9.reg"   | sed -e 's/color=yellow/color=orange width=1/g'  > "$SourceDir/cat_350_unfitted.ds9.reg"
#
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_500_detected.ds9.reg"   | sed -e 's/color=yellow/color=green  width=2/g'  > "$SourceDir/cat_500_detected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_500_undetected.ds9.reg" | sed -e 's/color=yellow/color=green  width=1/g'  > "$SourceDir/cat_500_undetected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_500_unfitted.ds9.reg"   | sed -e 's/color=yellow/color=orange width=1/g'  > "$SourceDir/cat_500_unfitted.ds9.reg"
#
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_1160_detected.ds9.reg"   | sed -e 's/color=yellow/color=green  width=2/g'  > "$SourceDir/cat_1160_detected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_1160_undetected.ds9.reg" | sed -e 's/color=yellow/color=green  width=1/g'  > "$SourceDir/cat_1160_undetected.ds9.reg"
#cat "/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160309/cat_1160_unfitted.ds9.reg"   | sed -e 's/color=yellow/color=orange width=1/g'  > "$SourceDir/cat_1160_unfitted.ds9.reg"

SourceDir="/home/dzliu/Data/DeepFields/Data_deep_fields/GOODSN_Photo/aaa_ds9_regions_v7_201601_update_20160725_850um"

xpaset -p "$DS9_TITLE" frame 1
xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_16.ds9.reg"

xpaset -p "$DS9_TITLE" frame 2
xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_24.ds9.reg"

xpaset -p "$DS9_TITLE" frame 3
xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_100.ds9.reg"

xpaset -p "$DS9_TITLE" frame 4
xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_160.ds9.reg"

xpaset -p "$DS9_TITLE" frame 5
xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_250.ds9.reg"

xpaset -p "$DS9_TITLE" frame 6
xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_350.ds9.reg"

xpaset -p "$DS9_TITLE" frame 7
xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_500.ds9.reg"

xpaset -p "$DS9_TITLE" frame 8
xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_1160.ds9.reg"

#xpaset -p "$DS9_TITLE" frame 3
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_100_detected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_100_undetected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_100_unfitted.ds9.reg"
#
#xpaset -p "$DS9_TITLE" frame 4
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_160_detected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_160_undetected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_160_unfitted.ds9.reg"
#
#xpaset -p "$DS9_TITLE" frame 5
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_250_detected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_250_undetected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_250_unfitted.ds9.reg"
#
#xpaset -p "$DS9_TITLE" frame 6
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_350_detected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_350_undetected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_350_unfitted.ds9.reg"
#
#xpaset -p "$DS9_TITLE" frame 7
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_500_detected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_500_undetected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_500_unfitted.ds9.reg"
#
#xpaset -p "$DS9_TITLE" frame 8
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_1160_detected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_1160_undetected.ds9.reg"
#xpaset -p "$DS9_TITLE" region load "$SourceDir/cat_1160_unfitted.ds9.reg"



xpaset -p "$DS9_TITLE" frame 1; echo "fk5; text 12:35:57.038,+62:10:58.30 # color=white width=4 font=\"helvetica 20 bold roman\" text={20cm}"    | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 2; echo "fk5; text 12:35:57.038,+62:10:58.30 # color=white width=4 font=\"helvetica 20 bold roman\" text={24um}"    | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 3; echo "fk5; text 12:35:57.038,+62:10:58.30 # color=white width=4 font=\"helvetica 20 bold roman\" text={100um}"   | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 4; echo "fk5; text 12:35:57.038,+62:10:58.30 # color=white width=4 font=\"helvetica 20 bold roman\" text={160um}"   | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 5; echo "fk5; text 12:35:57.038,+62:10:58.30 # color=white width=4 font=\"helvetica 20 bold roman\" text={250um}"   | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 6; echo "fk5; text 12:35:57.038,+62:10:58.30 # color=white width=4 font=\"helvetica 20 bold roman\" text={350um}"   | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 7; echo "fk5; text 12:35:57.038,+62:10:58.30 # color=white width=4 font=\"helvetica 20 bold roman\" text={500um}"   | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 8; echo "fk5; text 12:35:57.038,+62:10:58.30 # color=white width=4 font=\"helvetica 20 bold roman\" text={1160um}"  | xpaset $DS9_TITLE regions



xpaset -p "$DS9_TITLE" frame 5; echo "fk5; text 12:35:54.091,+62:10:54.86 # color=green width=2 font=\"helvetica 16 roman\" text={14896}"  | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 5; echo "fk5; text 12:35:53.248,+62:10:29.88 # color=green width=2 font=\"helvetica 15 roman\" text={15027}"  | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 5; echo "fk5; text 12:35:51.700,+62:10:49.52 # color=green width=2 font=\"helvetica 14 roman\" text={14867}"  | xpaset $DS9_TITLE regions

xpaset -p "$DS9_TITLE" frame 6; echo "fk5; text 12:35:54.091,+62:10:54.86 # color=green width=2 font=\"helvetica 16 roman\" text={14896}"  | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 6; echo "fk5; text 12:35:53.248,+62:10:29.88 # color=green width=2 font=\"helvetica 15 roman\" text={15027}"  | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 6; echo "fk5; text 12:35:51.700,+62:10:49.52 # color=green width=2 font=\"helvetica 14 roman\" text={14867}"  | xpaset $DS9_TITLE regions

xpaset -p "$DS9_TITLE" frame 7; echo "fk5; text 12:35:54.091,+62:10:54.86 # color=green  width=2 font=\"helvetica 16 roman\" text={14896}"  | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 7; echo "fk5; text 12:35:53.246,+62:10:33.72 # color=orange width=2 font=\"helvetica 13 roman\" text={15027}"  | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 7; echo "fk5; text 12:35:52.312,+62:10:48.33 # color=orange width=2 font=\"helvetica 13 roman\" text={14867}"  | xpaset $DS9_TITLE regions

xpaset -p "$DS9_TITLE" frame 8; echo "fk5; text 12:35:54.091,+62:10:54.86 # color=green  width=2 font=\"helvetica 16 roman\" text={14896}"  | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 8; echo "fk5; text 12:35:53.246,+62:10:33.72 # color=orange width=2 font=\"helvetica 13 roman\" text={15027}"  | xpaset $DS9_TITLE regions
xpaset -p "$DS9_TITLE" frame 8; echo "fk5; text 12:35:52.312,+62:10:48.33 # color=orange width=2 font=\"helvetica 13 roman\" text={14867}"  | xpaset $DS9_TITLE regions

xpaset -p "$DS9_TITLE" saveimage eps "ID14896_blending_demonstration_v.eps"

ps2pdf -dEPSCrop "ID14896_blending_demonstration_v.eps"




