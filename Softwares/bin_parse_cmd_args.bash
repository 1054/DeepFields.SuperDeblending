#!/bin/bash
# 
# Aim:
#      source this code in bash with arguments, you will get variables. see example. 
# 
# Usage:
#        source $(which bin_parsed_cmd_args) "$@"
# 
# Example:
#          In a bash script, we write: 
#              source $(which bin_parsed_cmd_args) -sim aaa.fits -rec bbb.fits
#          Then after this, the following array varibales will be created 
#          with aaa.fits and bbb.fits as their contents: 
#              ${bin_parsed_cmd_sim} ${bin_parsed_cmd_rec}
#          
#          Or, if we write
#               source $(which bin_parsed_cmd_args) -xlog -ylog
#          Then, we will have "-xlog" "-ylog" in the array variable: 
#               ${bin_parsed_cmd_misc_opts[@]}
# 


# 
# Check Mac System
# 
xargs_command="xargs"
if [[ $(uname) == "Darwin" ]]; then
    if [[ $(type gxargs 2>/dev/null | wc -l) -eq 1 ]]; then
        xargs_command="gxargs"
    else
        echo "Error! Please install GNU findutils under Mac system! (e.g., sudo port install findutils)"
        exit 1
    fi
fi


# 
# Setup functions for checking input dirs/files
# 
function check_input_dir() {
    local i=1
    for (( i=1; i<=$#; i++ )); do
        if [[ ! -d "${!i}" ]] && [[ ! -L "${!i}" ]]; then
            echo "Error! \"${!i}\" was not found!"
            exit 1
        fi
    done
}
function check_input_file() {
    local i=1
    for (( i=1; i<=$#; i++ )); do
        if [[ ! -f "${!i}" ]] && [[ ! -L "${!i}" ]]; then
            echo "Error! \"${!i}\" was not found!"
            exit 1
        fi
    done
}
function backup_output_dir() {
    local i=1
    for (( i=1; i<=$#; i++ )); do
        if [[ -d "${!i}" ]]; then
            mv "${!i}" "${!i}.backup."$(date +"%Y%m%d.%Hh%Mm%Ss.%Z")
        fi
    done
}
function create_output_dir() {
    local i=1
    for (( i=1; i<=$#; i++ )); do
        if [[ ! -d "${!i}" ]]; then
            mkdir -p "${!i}"
        fi
    done
}


# 
# Read input args
# 
iarg_iarg=1
iarg_name=""
iarg_text=""
iarg_numb=0
bin_parsed_cmd_main_args=()
bin_parsed_cmd_main_opts=()
bin_parsed_cmd_misc_args=() # misc arguments without option name, e.g., -aaa bbb, "-aaa" is the option, "bbb" is the argument. 
bin_parsed_cmd_misc_opts=() # misc options without argument value, e.g., -aaa bbb, "-aaa" is the option, "bbb" is the argument. 
while [[ iarg_iarg -le $# ]]; do
    #echo "$iarg_iarg ${!iarg_iarg}"
    # 
    # if current arg starts with "-"
    if echo "${!iarg_iarg}" | grep -q -e "^-[a-zA-Z]" -e "^--[a-zA-Z]"; then
        iarg_name_prev="$iarg_name"
        iarg_text_prev="$iarg_text"
        if [[ ! -z "$iarg_name_prev" ]]; then
            iarg_numb=$(eval "echo \${#$iarg_name_prev[@]}")
            echo "dimension $iarg_name_prev $iarg_numb"
            if [[ $iarg_numb -eq 0 ]]; then
                bin_parsed_cmd_misc_opts+=("$iarg_text_prev") # record misc opts without arg value, if its next input is also an option.
            fi
        fi
        iarg_name=$(echo "${!iarg_iarg}" | sed -e 's/^--/-/g' | sed -e 's/^-/bin_parsed_cmd_/g' | sed -e 's/[^a-zA-Z_0-9]/_/g' | tr '[:upper:]' '[:lower:]')
        iarg_text="${!iarg_iarg}"
        echo "declare -a $iarg_name"
        declare -a $iarg_name
        if [[ iarg_iarg -eq $# ]]; then
            bin_parsed_cmd_misc_opts+=("$iarg_text") # record misc opts without arg value, if this is the last input. 
        fi
        #echo "bin_parsed_cmd_main_opts+=(\"$iarg_text\")"
        bin_parsed_cmd_main_opts+=("$iarg_text") # all the opts. An opt is an input string starting with "-" or "--". 
    # 
    # if current arg does not start with "-", i.e., it is a string or value, add it to "${iarg_name[@]}"
    elif [[ ! -z "$iarg_name" ]]; then
        eval "$iarg_name+=(\"${!iarg_iarg}\")"
        eval "bin_parsed_cmd_main_args+=(\"${!iarg_iarg}\")"
        iarg_numb=$(eval "echo \${#$iarg_name[@]}")
        #eval "echo $iarg_name[$((iarg_numb-1))]=\${$iarg_name[$((iarg_numb-1))]}"
    # 
    # else might be some isolated string or value
    else
        bin_parsed_cmd_misc_args+=("${!iarg_iarg}")
        #echo "bin_parsed_cmd_misc_args[$((${#bin_parsed_cmd_misc_args[@]}-1))]=${!iarg_iarg}"
    fi
    # 
    iarg_iarg=$((iarg_iarg+1))
done

unset iarg_iarg
unset iarg_name
unset iarg_text
unset iarg_numb

#echo "bin_parsed_cmd_main_args = ${bin_parsed_cmd_main_args[@]} (${#bin_parsed_cmd_main_args[@]})"
#echo "bin_parsed_cmd_main_opts = ${bin_parsed_cmd_main_opts[@]} (${#bin_parsed_cmd_main_opts[@]})"
#echo "bin_parsed_cmd_misc_args = ${bin_parsed_cmd_misc_args[@]} (${#bin_parsed_cmd_misc_args[@]})"
#echo "bin_parsed_cmd_misc_opts = ${bin_parsed_cmd_misc_opts[@]} (${#bin_parsed_cmd_misc_opts[@]})"



