http://henrysmac.org/blog/2012/8/17/install-sextractor-on-os-x-lion.html


first compile fftw then compile atlas3.10.2.tar.bz2

cd fftw3 
./configure --enable-threads
make
cp .libs/libfftw3.a ../3rd
cp include/fftw3.h ../3rd

cd ATLAS
mkdir build
cd build
../configure
make
cp lib/*.a ../../3rd
cp include/*.h ../../3rd
cp ../include/*.h ../../3rd

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

cd sextractor-2.19.5

./configure --with-fftw-libdir="/Users/dliu/Software/sextractor/sextractor-2.19.5/3rd" --with-fftw-incdir="/Users/dliu/Software/sextractor/sextractor-2.19.5/3rd" --with-atlas-libdir="/Users/dliu/Software/sextractor/sextractor-2.19.5/3rd" --with-atlas-incdir="/Users/dliu/Software/sextractor/sextractor-2.19.5/3rd"

make

cp src/sex ../

cd tests

../../sex galaxies.fits

le 20150502

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

cd psfex-3.17.1

./configure --with-fftw-libdir="/Users/dliu/Software/sextractor/sextractor-2.19.5/3rd" --with-fftw-incdir="/Users/dliu/Software/sextractor/sextractor-2.19.5/3rd" --with-atlas-libdir="/Users/dliu/Software/sextractor/sextractor-2.19.5/3rd" --with-atlas-incdir="/Users/dliu/Software/sextractor/sextractor-2.19.5/3rd"

make

cp src/psfex ../

le 20150502












