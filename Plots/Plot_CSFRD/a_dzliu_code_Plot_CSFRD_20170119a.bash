#!/bin/bash
# 

#echo "macro read make_cosmic_sfr_plot_with_uncertainty.sm go" | sm | tee log_plot_csfrd_20170118a.txt

#gedit datatable_Madau2014_IR_for_plot.sm
#gedit datatable_Madau2014_UV_for_plot.sm

echo "input datatable_Madau2014_IR_for_plot.sm" | sm
echo "input datatable_Madau2014_UV_for_plot.sm" | sm
echo "input datatable_RowanRobinson2016_for_plot.sm" | sm
echo "input datatable_Novak2017_for_plot.sm" | sm

echo "macro read a_dzliu_code_Plot_CSFRD.sm plot_CSFRD" | sm


