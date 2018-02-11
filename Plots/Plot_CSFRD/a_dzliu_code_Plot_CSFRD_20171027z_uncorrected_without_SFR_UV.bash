#!/bin/bash
# 

#gedit datatable_Madau2014_IR_for_plot.sm
#gedit datatable_Madau2014_UV_for_plot.sm

#echo "input datatable_Madau2014_IR_for_plot.sm" | sm
#echo "input datatable_Madau2014_UV_for_plot.sm" | sm
#echo "input datatable_RowanRobinson2016_for_plot.sm" | sm
#echo "input datatable_Novak2017_for_plot.sm" | sm



# 
# Prepare
# 

data_version="20171030z_DR_v201706"
cp -r "../Calc_Vmax_and_CSFRD/datatable_CSFRD_dzliu_v${data_version}" .
echo "${data_version}" > "set_input_date"
echo "0" > "set_do_corr"




# 
# Do uncorrected
# 

if [[ -f datatable__CSFRD_correction__Go.txt ]]; then mv datatable__CSFRD_correction__Go.txt datatable__CSFRD_correction__Go.txt.backup.v20171030z; fi
if [[ -f datatable__CSFRD_correction__Go.readme.txt ]]; then mv datatable__CSFRD_correction__Go.readme.txt datatable__CSFRD_correction__Go.readme.txt.backup.v20171030z; fi

echo "macro read a_dzliu_code_Plot_CSFRD.sm plot_CSFRD" | sm

cp "log_make_cosmic_sfr_plot.log" \
    "log_make_cosmic_sfr_plot_v${data_version}.log"



# 
# Do corrected
# 

#echo "../Plot_z_Mstar_SFR/Plot_Mstar_Histogram/results_Plots_v20171027b_DR_v201706_Renormalized/datatable__CSFRD_correction__SMF_renormalization.txt"    "datatable__CSFRD_correction__Go.readme.txt"
#cp   "../Plot_z_Mstar_SFR/Plot_Mstar_Histogram/results_Plots_v20171027b_DR_v201706_Renormalized/datatable__CSFRD_correction__SMF_renormalization.txt"    "datatable__CSFRD_correction__Go.txt"
#
#
#echo "macro read a_dzliu_code_Plot_CSFRD.sm plot_CSFRD" | sm
#
#
#echo "macro read a_dzliu_code_Plot_CSFRD_correction_Go.sm plot_CSFRD_correction_Go" | sm


