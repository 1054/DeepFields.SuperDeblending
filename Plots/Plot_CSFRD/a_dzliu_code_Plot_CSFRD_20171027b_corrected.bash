#!/bin/bash
# 

#gedit datatable_Madau2014_IR_for_plot.sm
#gedit datatable_Madau2014_UV_for_plot.sm

#echo "input datatable_Madau2014_IR_for_plot.sm" | sm
#echo "input datatable_Madau2014_UV_for_plot.sm" | sm
#echo "input datatable_RowanRobinson2016_for_plot.sm" | sm
#echo "input datatable_Novak2017_for_plot.sm" | sm


echo "../Plot_z_Mstar_SFR/Plot_Mstar_Histogram/results_Plots_v20171027b_DR_v201706_Renormalized/datatable__CSFRD_correction__SMF_renormalization.txt"    "datatable__CSFRD_correction__Go.readme.txt"
cp   "../Plot_z_Mstar_SFR/Plot_Mstar_Histogram/results_Plots_v20171027b_DR_v201706_Renormalized/datatable__CSFRD_correction__SMF_renormalization.txt"    "datatable__CSFRD_correction__Go.txt"


echo "macro read a_dzliu_code_Plot_CSFRD.sm plot_CSFRD" | sm


echo "macro read a_dzliu_code_Plot_CSFRD_correction_Go.sm plot_CSFRD_correction_Go" | sm


