#!/bin/bash
# 

#gedit datatable_Madau2014_IR_for_plot.sm
#gedit datatable_Madau2014_UV_for_plot.sm

#echo "input datatable_Madau2014_IR_for_plot.sm" | sm
#echo "input datatable_Madau2014_UV_for_plot.sm" | sm
#echo "input datatable_RowanRobinson2016_for_plot.sm" | sm
#echo "input datatable_Novak2017_for_plot.sm" | sm


echo 'datatable__CSFRD_correction__v20170311.txt'    "datatable__CSFRD_correction__Go.readme.txt"
cp   'datatable__CSFRD_correction__v20170311.txt'    "datatable__CSFRD_correction__Go.txt"

echo "macro read a_dzliu_code_Plot_CSFRD_correction_Go.sm plot_CSFRD_correction_Go" | sm

mv Plot_CSFRD_correction_Go_v1.pdf Plot_CSFRD_correction_Go_v20171003a_with_DataRelease_v201612_only_z_GE_4.pdf


