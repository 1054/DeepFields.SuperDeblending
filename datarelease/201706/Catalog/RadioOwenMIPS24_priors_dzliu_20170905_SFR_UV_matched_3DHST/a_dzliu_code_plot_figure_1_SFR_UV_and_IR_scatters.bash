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
topcat -stilts plot2plane \
                xpix=500 ypix=400 \
                insets="${margin[3]},${margin[0]},${margin[1]},${margin[2]}" \
                xlabel="\Large SFR \ UV" \
                ylabel="\Large SFR \ IR" \
                xlog=true \
                ylog=true \
                \
                layer1=mark \
                shape1=filled_circle \
                size1=1 \
                color1=blue \
                shading1=auto \
                in1='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt1=ascii \
                leglabel1='SFR \ UV \ 1400 \AA' \
                x1='SFR_UV1400' \
                y1='SFR_IR' \
                \
                layer2=mark \
                shape2=filled_circle \
                size2=1 \
                color2=red \
                shading2=auto \
                in2='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt2=ascii \
                leglabel2='SFR \ UV \ 1700 \AA' \
                x2='SFR_UV1700' \
                y2='SFR_IR' \
                \
                layer3=function \
                fexpr3='(x)' \
                color3=black \
                antialias3=true \
                thick3=1 \
                leglabel3='1:1' \
                \
                legpos=0.08,0.94 \
                seq="3,2,1" \
                fontsize=16 \
                texttype=latex \
                aspect=1.0 \
                omode=out \
                out='Plot_comparison_SFR_UV_and_IR.pdf'
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-usage.html
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-examples.html
                # omode=swing

open "Plot_comparison_SFR_UV_and_IR.pdf"
