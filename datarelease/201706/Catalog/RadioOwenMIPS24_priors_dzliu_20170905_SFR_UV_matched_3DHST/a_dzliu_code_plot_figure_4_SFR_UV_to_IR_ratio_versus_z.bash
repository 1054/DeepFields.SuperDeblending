#!/bin/bash
# 

if [[ ! -f "datatable_CrossMatched_selected_columns_converted_to_SFRs.txt" ]]; then
    echo "Error! \"datatable_CrossMatched_selected_columns_converted_to_SFRs.txt\" was not found!"
    exit 1
fi

# 
# Make plots
# 
margin=(90 50 20 20) # left, bottom, right, top
topcat -stilts plot2plane \
                xpix=500 ypix=400 \
                insets="${margin[3]},${margin[0]},${margin[1]},${margin[2]}" \
                xlabel="\Large z_{IR}" \
                ylabel="\Large SFR_{UV}/SFR_{IR}" \
                ylog=true \
                ymax=1e6 xcrowd=2 ycrowd=2 \
                \
                layer1=mark \
                shape1=filled_circle \
                size1=1 \
                color1=blue \
                shading1=auto \
                in1='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt1=ascii \
                icmd1="select \"(goodArea==1 && SNR_IR>=5)\"" \
                leglabel1='SFR_{UV} \ from \ 1400 \AA' \
                x1='z_IR' \
                y1='SFR_UV1400/SFR_IR' \
                \
                layer11=mark \
                shape11=open_circle \
                size11=2 \
                color11=green \
                shading11=auto \
                in11='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt11=ascii \
                icmd11="select \"(goodArea==1 && SNR_IR>=5 && xfAGN>SFR_IR)\"" \
                leglabel11='SFR_{UV} \ from \ 1400 \AA, AGN' \
                x11='z_IR' \
                y11='SFR_UV1400/SFR_IR' \
                \
                layer12=mark \
                shape12=filled_circle \
                size12=2 \
                color12=green \
                shading12=auto \
                in12='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt12=ascii \
                icmd12="select \"(goodArea==1 && SNR_IR>=5 && xfAGN>SFR_IR)\"" \
                leglabel12='SFR_{UV} \ from \ SFR_{IR}, AGN' \
                x12='z_IR' \
                y12='SFR_UV_from_SFR_IR/SFR_IR' \
                \
                layer2=mark \
                shape2=open_circle \
                size2=2 \
                color2=red \
                shading2=auto \
                in2='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt2=ascii \
                icmd2="select \"(goodArea==1 && SNR_IR>=5 && SFR_UV1400<=0 && SFR_UV_from_Mstar>0)\"" \
                leglabel2='SFR_{UV} \ from \ M_{*}' \
                x2='z_IR' \
                y2='SFR_UV_from_Mstar/SFR_IR' \
                \
                layer3=mark \
                shape3=filled_circle \
                size3=2 \
                color3=magenta \
                shading3=auto \
                in3='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt3=ascii \
                icmd3="select \"(goodArea==1 && SNR_IR>=5 && SFR_UV1400<=0 && SFR_UV_from_Mstar<=0 && SFR_UV_from_SFR_IR>0)\"" \
                leglabel3='SFR_{UV} \ from \ SFR_{IR}' \
                x3='z_IR' \
                y3='SFR_UV_from_SFR_IR/SFR_IR' \
                \
                layer6=function \
                fexpr6='1' \
                color6=black \
                antialias6=true \
                thick6=1 \
                leglabel6='Y = 1' \
                \
                legpos=0.94,0.94 \
                seq="3,2,1,11,12,6" \
                fontsize=16 \
                texttype=latex \
                aspect=1.0 \
                omode=out \
                out='Plot_correlation_Ratio_SFR_UV_IR_versus_z_goodArea.pdf'
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-usage.html
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-examples.html
                # omode=swing

open "Plot_correlation_Ratio_SFR_UV_IR_versus_z_goodArea.pdf"
