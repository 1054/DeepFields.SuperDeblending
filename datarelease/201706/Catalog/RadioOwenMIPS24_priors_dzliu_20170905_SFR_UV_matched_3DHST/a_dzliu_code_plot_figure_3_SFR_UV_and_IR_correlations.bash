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
                xlabel="\Large log M_{*}" \
                ylabel="\Large SFR_{UV}/SFR_{IR}" \
                xmin=6 xmax=13 xcrowd=2 \
                ylog=true \
                ymin=1e-4 ymax=1e8 \
                \
                layer1=mark \
                shape1=x \
                size1=1 \
                color1='999999' \
                shading1=auto \
                in1='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt1=ascii \
                icmd1="select \"(goodArea==1 && SNR_IR>=5)\"" \
                leglabel1='all \ z' \
                x1='log10(Mstar)' \
                y1='SFR_UV1400/SFR_IR' \
                \
                layer2=mark \
                shape2=x \
                size2=1 \
                color2=green \
                shading2=auto \
                in2='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt2=ascii \
                icmd2="select \"(goodArea==1 && SNR_IR>=5 && z_IR<1)\"" \
                leglabel2='z < 1' \
                x2='log10(Mstar)' \
                y2='SFR_UV1400/SFR_IR' \
                \
                layer3=mark \
                shape3=x \
                size3=1 \
                color3=blue \
                shading3=auto \
                in3='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt3=ascii \
                icmd3="select \"(goodArea==1 && SNR_IR>=5 && z_IR>=1 && z_IR<2)\"" \
                leglabel3='1 \le z < 2' \
                x3='log10(Mstar)' \
                y3='SFR_UV1400/SFR_IR' \
                \
                layer4=mark \
                shape4=filled_circle \
                size4=1 \
                color4=magenta \
                shading4=auto \
                in4='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt4=ascii \
                icmd4="select \"(goodArea==1 && SNR_IR>=5 && z_IR>=2 && z_IR<3)\"" \
                leglabel4='2 \le z < 3' \
                x4='log10(Mstar)' \
                y4='SFR_UV1400/SFR_IR' \
                \
                layer5=mark \
                shape5=filled_circle \
                size5=1 \
                color5=red \
                shading5=auto \
                in5='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt5=ascii \
                icmd5="select \"(goodArea==1 && SNR_IR>=5 && z_IR>=3)\"" \
                leglabel5='z \ge 3' \
                x5='log10(Mstar)' \
                y5='SFR_UV1400/SFR_IR' \
                \
                layer6=function \
                fexpr6='pow(10,13.3-1.4*(x))' \
                color6=black \
                antialias6=true \
                thick6=1 \
                leglabel6='fit \ line' \
                \
                layer7=function \
                fexpr7='0.5961754054745767' \
                color7=black \
                antialias7=true \
                thick7=1 \
                leglabel7='low \ M_{*} \ limit \ (ID885, M_{*}=10^{8.16}, z_{spec}=0.9032)' \
                \
                legpos=0.08,0.94 \
                seq="1,2,3,4,5,6,7" \
                fontsize=16 \
                texttype=latex \
                aspect=1.0 \
                omode=out \
                out='Plot_correlation_Ratio_SFR_UV_IR_versus_Mstar_goodArea.pdf'
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-usage.html
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-examples.html
                # omode=swing

# 
# Make plots
# 
margin=(90 50 20 20) # left, bottom, right, top
topcat -stilts plot2plane \
                xpix=500 ypix=400 \
                insets="${margin[3]},${margin[0]},${margin[1]},${margin[2]}" \
                xlabel="\Large SFR_{IR}" \
                ylabel="\Large SFR_{UV}/SFR_{IR}" \
                xlog=true \
                ylog=true \
                xmin=1e-2 xmax=1e4 ymin=1e-4 ymax=1e3 \
                \
                layer1=mark \
                shape1=x \
                size1=1 \
                color1='999999' \
                shading1=auto \
                in1='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt1=ascii \
                icmd1="select \"(goodArea==1 && SNR_IR>=5)\"" \
                leglabel1='all \ z' \
                x1='SFR_IR' \
                y1='SFR_UV/SFR_IR' \
                \
                layer2=mark \
                shape2=x \
                size2=1 \
                color2=green \
                shading2=auto \
                in2='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt2=ascii \
                icmd2="select \"(goodArea==1 && SNR_IR>=5 && z_IR<1)\"" \
                leglabel2='z < 1' \
                x2='SFR_IR' \
                y2='SFR_UV/SFR_IR' \
                \
                layer3=mark \
                shape3=x \
                size3=1 \
                color3=blue \
                shading3=auto \
                in3='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt3=ascii \
                icmd3="select \"(goodArea==1 && SNR_IR>=5 && z_IR>=1 && z_IR<2)\"" \
                leglabel3='1 \le z < 2' \
                x3='SFR_IR' \
                y3='SFR_UV/SFR_IR' \
                \
                layer4=mark \
                shape4=filled_circle \
                size4=1 \
                color4=magenta \
                shading4=auto \
                in4='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt4=ascii \
                icmd4="select \"(goodArea==1 && SNR_IR>=5 && z_IR>=2 && z_IR<3)\"" \
                leglabel4='2 \le z < 3' \
                x4='SFR_IR' \
                y4='SFR_UV/SFR_IR' \
                \
                layer5=mark \
                shape5=filled_circle \
                size5=1 \
                color5=red \
                shading5=auto \
                in5='datatable_CrossMatched_selected_columns_converted_to_SFRs.txt' \
                ifmt5=ascii \
                icmd5="select \"(goodArea==1 && SNR_IR>=5 && z_IR>=3)\"" \
                leglabel5='z \ge 3' \
                x5='SFR_IR' \
                y5='SFR_UV/SFR_IR' \
                \
                layer6=function \
                fexpr6='pow(10,0.3-1.4*log10(x))' \
                color6=black \
                antialias6=true \
                thick6=1 \
                leglabel6='fit \ line' \
                \
                legpos=0.08,0.94 \
                seq="1,2,3,4,5,6" \
                fontsize=16 \
                texttype=latex \
                aspect=1.0 \
                omode=out \
                out='Plot_correlation_Ratio_SFR_UV_IR_versus_SFR_IR_goodArea.pdf'
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-usage.html
                # http://www.star.bristol.ac.uk/~mbt/stilts/sun256/plot2plane-examples.html
                # omode=swing

open "Plot_correlation_Ratio_SFR_UV_IR_versus_Mstar_goodArea.pdf" "Plot_correlation_Ratio_SFR_UV_IR_versus_SFR_IR_goodArea.pdf"
