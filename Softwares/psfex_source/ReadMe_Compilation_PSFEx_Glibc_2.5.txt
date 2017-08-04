# sapherschel8
# ldd --version 2.5


# first compile fftw-3.3.4.tar.gz

tar -xzf fftw-3.3.4.tar.gz
cd fftw3-3.3.4
./configure --enable-threads --enable-single
make

mkdir ../3rd
cp .libs/libfftw3.a ../3rd/
cp .libs/libfftw3f.a ../3rd/
cp api/fftw3.h ../3rd/


# then compile atlas3.8.4.tar.bz2 (must be <3.9.)

wget https://sourceforge.net/projects/math-atlas/files/Stable/3.8.4/atlas3.8.4.tar.bz2/download --no-check-certificate
tar -xf atlas3.8.4.tar.bz2
cd ATLAS/
mkdir build
cd build
../configure -Si cputhrchk 0 # get over cpu throttle thing, see -- https://stackoverflow.com/questions/14592401/atlas-install-really-need-to-get-past-cpu-throttle-check
make

cp ../include/*.h ../../3rd
cp lib/*.a ../../3rd


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#cd sextractor-2.19.5
#
#./configure --with-fftw-libdir="/home/dliu/Software/3rd" --with-fftw-incdir="/home/dliu/Software/3rd" 
## --with-atlas-libdir="/home/dliu/Software/3rd" --with-atlas-incdir="/home/dliu/Software/3rd"
#
#make
#
#cp src/sex ../
#
#cd tests
#
#../../sex galaxies.fits
#
#le 20150502


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

cd psfex-3.17.1

./configure --with-fftw-libdir="/home/dliu/Software/3rd" --with-fftw-incdir="/home/dliu/Software/3rd" --with-atlas-libdir="/home/dliu/Software/3rd" --with-atlas-incdir="/home/dliu/Software/3rd"

make

cp src/psfex ../










