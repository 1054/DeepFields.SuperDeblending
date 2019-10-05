#!/bin/bash
#

OutputDir=$(perl -MCwd -e 'print Cwd::abs_path shift' $(dirname "${BASH_SOURCE[0]}"))

#if [[ ! -d "../../../Crab/" ]]; then
#    echo "Error! \"../../../Crab/\" was not found!"
#    exit
#fi

#cd ../../../Crab/

if [[ ! -d "CrabIO/" ]]; then
    echo "Error! \"CrabIO/\" was not found!"
    exit
fi

set -e


cd CrabIO/CrabConst/
g++ CrabStringClean.cpp radec2degree.cpp -o "$OutputDir"/radec2degree_linux_x86_64
g++ CrabStringClean.cpp degree2radec.cpp -o "$OutputDir"/degree2radec_linux_x86_64
g++ double2hex.cpp -o "$OutputDir"/double2hex_linux_x86_64
g++ hex2double.cpp -o "$OutputDir"/hex2double_linux_x86_64
g++ float2hex.cpp -o "$OutputDir"/float2hex_linux_x86_64
g++ hex2float.cpp -o "$OutputDir"/hex2float_linux_x86_64
g++ lumdist.cpp -o "$OutputDir"/lumdist_linux_x86_64
cd ../../


cd CrabIO/CrabTable/CrabTableReadColumn/
g++ main.cpp -o "$OutputDir"/CrabTableReadColumn_linux_x86_64
cd ../../../


cd CrabIO/CrabTable/CrabTableReadInfo/
g++ main.cpp -o "$OutputDir"/CrabTableReadInfo_linux_x86_64
cd ../../../


cd CrabIO/CrabFitsIO/CrabFitsHeader/
./do_Compile
cp CrabFitsHeader_linux_x86_64 "$OutputDir"/
cd ../../../


cd CrabIO/CrabFitsIO/CrabFitsImageArithmetic/
./do_Compile
cp CrabFitsImageArithmetic_linux_x86_64 "$OutputDir"/
cd ../../../


cd CrabIO/CrabFitsIO/CrabFitsImageCrop/
./do_Compile
cp CrabFitsImageCrop_linux_x86_64 "$OutputDir"/
cd ../../../


cd CrabIO/CrabPhot/CrabPhotAperPhot/
./do_Compile
cp CrabPhotAperPhot_linux_x86_64 "$OutputDir"/
cd ../../../


cd CrabIO/CrabPhot/CrabPhotImageStatistics/
./do_Compile
cp CrabPhotImageStatistics_linux_x86_64 "$OutputDir"/
cd ../../../


cd CrabIO/CrabPhot/CrabPhotMonteCarlo/
./do_Compile
cp CrabPhotMonteCarlo_linux_x86_64 "$OutputDir"/
cd ../../../


cd CrabIO/CrabPhot/CrabPhotRingPhot/
./do_Compile
cp CrabPhotRingPhot_linux_x86_64 "$OutputDir"/
cd ../../../


#if [[ -d "CrabIO/CrabFitsIO/CrabFitsImageFromGildasMapping/" ]]; then
#    cd CrabIO/CrabFitsIO/CrabFitsImageFromGildasMapping/
#    g++ -std=c++11 CrabFitsIO.cpp pdbi-uvt-to-fits.cpp -o "$OutputDir"/pdbi-uvt-to-fits_linux_x86_64
#    g++ -std=c++11 CrabFitsIO.cpp pdbi-lmv-to-fits.cpp -o "$OutputDir"/pdbi-lmv-to-fits_linux_x86_64
#    cd ../../../
#fi











