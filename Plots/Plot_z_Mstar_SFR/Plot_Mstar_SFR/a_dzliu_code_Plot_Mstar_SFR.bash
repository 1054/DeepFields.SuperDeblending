#!/bin/bash
# 


if [[ -z "$output_date" ]]; then
output_date="20171030a_DR_v201706"
fi


cp "../Plot_Mstar_Histogram/datatable__CSFRD_correction__${output_date}.txt" "datatable__M_incomplete.txt"


echo "macro read a_dzliu_code_Plot_Mstar_SFR.sm plot_Mstar_SFR_all" | sm | tee "a_dzliu_log_Plot_Mstar_SFR_v${output_date}.log"


rm Plot_Mstar_SFR_v1.{eps,pdfconverts,pdfmarks}


