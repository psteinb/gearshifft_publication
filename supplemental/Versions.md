# Software versions

This page is meant as a summary of steps taken to install the packages and libraries that were benchmarked in this paper.

## gcc version

On Intel x86_64 systems, we used gcc 5.3.0 throughout all benchmarks.

## cuFFT

Using cuFFT from CUDA 8.0.44 available from [nVidia](https://developer.nvidia.com/cuda-downloads).

## FFTW

We used fftw 3.3.5 throughout the benchmarks. FFTW is avilable from [fftw.org](http://www.fftw.org/download.html). The following steps were taken to install fftw compiled against gcc 5.3.0:

### single precision

```
$ ./configure -enable-static=yes --enable-shared=yes --with-gnu-ld  --enable-silent-rules --with-pic --enable-float --enable-openmp --enable-sse2 --prefix=$PREFIX
$ make
$ make install
```

### double precision

```
$ ./configure -enable-static=yes --enable-shared=yes --with-gnu-ld  --enable-silent-rules --with-pic --enable-openmp --enable-sse2 --prefix=$PREFIX
$ make
$ make install
```


## clFFT

We used clfft 2.1.2 throughout the benchmarks linking against boost 1.60.0 and fftw 3.3.5. `libOpenCL.so` was taken from the CUDA 8.0.44 release mentioned above. clFFT is avilable from [github](https://github.com/clMathLibraries/clFFT). The following steps were taken to build and install clfft:

```
$ git clone https://github.com/clMathLibraries/clFFT
$ cd clFFT
$ git checkout v2.12.2
$ mkdir build
$ cd build
$ CXX=`which g++` CC=`which gcc` cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DBOOST_ROOT=/path/to/boost/1.60.0-gcc530/ ../src/
$ make
$ make install
```
