#!/bin/bash
# 

#gedit datatable_Madau2014_IR_for_plot.sm
#gedit datatable_Madau2014_UV_for_plot.sm

#echo "input datatable_Madau2014_IR_for_plot.sm" | sm
#echo "input datatable_Madau2014_UV_for_plot.sm" | sm
#echo "input datatable_RowanRobinson2016_for_plot.sm" | sm
#echo "input datatable_Novak2017_for_plot.sm" | sm


if [[ -f datatable__CSFRD_correction__Go.txt ]]; then mv datatable__CSFRD_correction__Go.txt datatable__CSFRD_correction__Go.txt.backup; fi
if [[ -f datatable__CSFRD_correction__Go.readme.txt ]]; then mv datatable__CSFRD_correction__Go.readme.txt datatable__CSFRD_correction__Go.readme.txt.backup; fi

echo "macro read a_dzliu_code_Plot_CSFRD.sm plot_CSFRD" | sm


