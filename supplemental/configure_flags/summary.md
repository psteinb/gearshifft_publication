Small analysis to see if the configure flags influence fftw runtime. The bottom line, the default flags appear to yield 3x faster runtimes than the manual aggressive flags.

# minimal 

## single precision

```
$ ./configure -enable-static=yes --enable-shared=yes --with-gnu-ld  --enable-silent-rules --with-pic --enable-openmp --enable-single --enable-sse --enable-sse2 --prefix=$PREFIX
$ make
$ make install
```

./bench --print-precision -onthreads=16 -s irf8192x8192 -s irb8192x8192
Problem: irf8192x8192, setup: 8.70 s, time: 58.57 ms, ``mflops'': 74470
Problem: irb8192x8192, setup: 9.05 s, time: 77.94 ms, ``mflops'': 55966

## double precision

```
$ ./configure -enable-static=yes --enable-shared=yes --with-gnu-ld  --enable-silent-rules --with-pic --enable-openmp --enable-sse2 --prefix=$PREFIX
$ make
$ make install
```

./bench --print-precision -onthreads=16 -s irf8192x8192 -s irb8192x8192
double
Problem: irf8192x8192, setup: 9.52 s, time: 86.28 ms, ``mflops'': 50555
Problem: irb8192x8192, setup: 10.01 s, time: 76.50 ms, ``mflops'': 57020

# aggressive 

## single precision

```
$ CFLAGS="-march=native" CXXFLAGS="-march=native" ./configure --enable-single --enable-sse --enable-sse2 --enable-shared --enable-openmp --enable-threads --enable-avx --enable-avx2 --enable-avx-128-fma 
$ make
$ make install
```

./bench --print-precision -onthreads=16 -s irf8192x8192 -s irb8192x8192
single
Problem: irf8192x8192, setup: 28.68 s, time: 265.23 ms, ``mflops'': 16446
Problem: irb8192x8192, setup: 29.14 s, time: 267.86 ms, ``mflops'': 16285

## double precision


```
$ CFLAGS="-march=native" CXXFLAGS="-march=native" ./configure --enable-sse2 --enable-shared --enable-openmp --enable-threads --enable-avx --enable-avx2 --enable-avx-128-fma --prefix=$PREFIX
$ make
```

./bench --print-precision -onthreads=16 -s irf8192x8192 -s irb8192x8192
double
Problem: irf8192x8192, setup: 22.50 s, time: 339.34 ms, ``mflops'': 12855
Problem: irb8192x8192, setup: 22.16 s, time: 319.07 ms, ``mflops'': 13671
