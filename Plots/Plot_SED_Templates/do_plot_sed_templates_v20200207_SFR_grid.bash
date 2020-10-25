#!/bin/bash
# 

if [[ $(echo "load astroPhot.sm" | sm 2>&1 | wc -l) -eq 1 ]]; then
    if [[ ! -d "$HOME/Cloud/Github/DeepFields.SuperDeblending" ]]; then
        echo "The SuperDeblending code \"$HOME/Cloud/Github/DeepFields.SuperDeblending\" was not found? Please download from \"https://github.com/1054/DeepFields.SuperDeblending\" and source the \"Softwares/SETUP\" file by yourself!"
        exit 1
    else
        source $HOME/Cloud/Github/DeepFields.SuperDeblending/Softwares/SETUP
    fi
fi

if [[ ! -f "fit_engine.sm" ]]; then
    echo "Error! \"fit_engine.sm\" was not found under current directory!"
    exit 1
fi

if [[ ! -d "BC03/" ]]; then
    echo "Error! \"BC03/\" was not found under current directory!"
    exit 1
fi

if [[ ! -d "Magdis/" ]]; then
    echo "Error! \"Magdis/\" was not found under current directory!"
    exit 1
fi

Output_dir="Output_v20200207_SFR_grid"
if [[ ! -d "$Output_dir" ]]; then
    mkdir "$Output_dir"
fi

printf "# %-12s %-12s %-30s\n" "SFR" "lgSFR" "Data_dir" > "$Output_dir/list_of_SFR_grid.txt"

# 10 ** (np.linspace(-2, 3.5, num=30))
for SFR in 1.00000000e-02 1.54758735e-02 2.39502662e-02 3.70651291e-02 \
           5.73615251e-02 8.87719709e-02 1.37382380e-01 2.12611233e-01 \
           3.29034456e-01 5.09209564e-01 7.88046282e-01 1.21957046e+00 \
           1.88739182e+00 2.92090372e+00 4.52035366e+00 6.99564216e+00 \
           1.08263673e+01 1.67547492e+01 2.59294380e+01 4.01280703e+01 \
           6.21016942e+01 9.61077966e+01 1.48735211e+02 2.30180731e+02 \
           3.56224789e+02 5.51288979e+02 8.53167852e+02 1.32035178e+03 \
           2.04335972e+03 3.16227766e+03
do
    
    SFR_str=$(printf "%0.4g" "$SFR")
    SFR_lg=$(python -c "import numpy as np; print(np.round(np.log10($SFR),4))")
    
    printf "  %-12s %-12s %-30s\n" "${SFR_str}" "${SFR_lg}" "Output_SFR_${SFR_str}" >> "$Output_dir/list_of_SFR_grid.txt"
    
    if [[ -d "$Output_dir/Output_SFR_${SFR_str}" ]]; then
        #rm -rf "$Output_dir/Output_SFR_${SFR_str}"
        echo "Found \"$Output_dir/Output_SFR_${SFR_str}\"! Will not overwrite!"
        continue
    fi
    
    echo "macro read do_plot_sed_templates.sm Plot_SED_Templates $SFR" | sm > /dev/null
    
    #echo "macro read do_plot_sed_templates_flux_versus_z.sm Plot_SED_Templates_Flux_versus_z" | sm
    
    mv "Output" "$Output_dir/Output_SFR_${SFR_str}"
    
    mv "Plot_SED_Templates_v1.eps" "$Output_dir/Plot_SED_Templates_SFR_${SFR_str}.eps"
    mv "Plot_SED_Templates_v1.pdf" "$Output_dir/Plot_SED_Templates_SFR_${SFR_str}.pdf"
    
    #break
    
done


cat "$Output_dir/list_of_SFR_grid.txt"

