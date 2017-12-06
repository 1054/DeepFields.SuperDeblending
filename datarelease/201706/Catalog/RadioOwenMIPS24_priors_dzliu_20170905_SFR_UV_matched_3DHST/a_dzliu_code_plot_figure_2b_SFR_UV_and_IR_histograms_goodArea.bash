#!/bin/bash
# 

if [[ ! -f "datatable_CrossMatched_selected_columns_converted_to_SFRs.txt" ]]; then
    echo "Error! \"datatable_CrossMatched_selected_columns_converted_to_SFRs.txt\" was not found!"
    exit 1
fi

# 
# Make plots
# 
margin=(80 50 20 20) # left, bottom, right, top
binsize="+1.3"
topcat -stilts plot2plane \
                xpix=500 ypix=400 \
                insets="${margin[3]},${margin[0]},${margin[1]},${margin[2]}" \
                xlabel="\Large SFR_{UV}/SFR_{IR}" \
                ylabel="\Large N" \
                xlog=true \
                ylog=true \
                \
                layer1=histogram \
                thick1=1 \
                barform1=semi_filled \
                color1='cccccc' \
                transparency1=0 \
                binsize1="$binsize" \
                in1='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt1=ascii \
                icmd1="select \"(Mstar>1 && SNR_IR>=5 && goodArea==1)\"" \
                leglabel1='all \ M_{*}' \
                x1="SFR_UV/SFR_IR" \
                \
                layer2=histogram \
                thick2=1 \
                barform2=semi_filled \
                color2=green \
                transparency2=0 \
                binsize2="$binsize" \
                in2='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt2=ascii \
                icmd2="select \"(Mstar>=1e9 && Mstar<1e10 && SNR_IR>=5 && goodArea==1)\"" \
                leglabel2='1 \times 10^{9} \le M_{*} < 1 \times 10^{10}' \
                x2="SFR_UV/SFR_IR" \
                \
                layer3=histogram \
                thick3=1 \
                barform3=semi_filled \
                color3=blue \
                transparency3=0 \
                binsize3="$binsize" \
                in3='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt3=ascii \
                icmd3="select \"(Mstar>=1e10 && Mstar<1e11 && SNR_IR>=5 && goodArea==1)\"" \
                leglabel3='1 \times 10^{10} \le M_{*} < 1 \times 10^{11}' \
                x3="SFR_UV/SFR_IR" \
                \
                layer4=histogram \
                thick4=1 \
                barform4=semi_filled \
                color4=red \
                transparency4=0 \
                binsize4="$binsize" \
                in4='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt4=ascii \
                icmd4="select \"(Mstar>=1e11 && Mstar<1e12 && SNR_IR>=5 && goodArea==1)\"" \
                leglabel4='1 \times 10^{11} \le M_{*} < 1 \times 10^{12}' \
                x4="SFR_UV/SFR_IR" \
                \
                legpos=0.08,0.94 \
                seq='1,2,3,4' \
                fontsize=16 \
                texttype=latex \
                aspect=1.0 \
                ymin=1 ymax=2e3 \
                omode=out \
                out='Plot_comparison_SFR_histogram_goodArea.pdf'
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-usage.html
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-examples.html
                # omode=swing
                # ymin=1e3 ymax=2e3 ysub=0.1,0.2 \

open "Plot_comparison_SFR_histogram_goodArea.pdf"
