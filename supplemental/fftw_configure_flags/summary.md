# Summary of study regarding configure flags

Small analysis to see if the configure flags influence fftw runtime. The bottom line, the default flags appear to yield 3x faster runtimes than the manual aggressive flags. This is backed by the authors recommendation:

> Special note for distribution maintainers: Although FFTW supports a zillion SIMD instruction sets, enabling them all at the same time is a bad idea, because it increases the planning time for minimal gain. We recommend that general-purpose x86 distributions only enable SSE2 and perhaps AVX. Users who care about the last ounce of performance should recompile FFTW themselves.

That can be found in the [release notes for fftw 3.3.5](http://www.fftw.org/release-notes.html).

# minimal 

## single precision

```
$ ./configure -enable-static=yes --enable-shared=yes --with-gnu-ld  --enable-silent-rules --with-pic --enable-openmp --enable-single --enable-sse --enable-sse2 --prefix=$PREFIX
$ make
$ make install
```

Running the benchmarks

```
./bench --print-precision -onthreads=16 -s irf8192x8192 -s irb8192x8192
Problem: irf8192x8192, setup: 8.70 s, time: 58.57 ms, ``mflops'': 74470
Problem: irb8192x8192, setup: 9.05 s, time: 77.94 ms, ``mflops'': 55966
```

## double precision

```
$ ./configure -enable-static=yes --enable-shared=yes --with-gnu-ld  --enable-silent-rules --with-pic --enable-openmp --enable-sse2 --prefix=$PREFIX
$ make
$ make install
```

Running the benchmarks

```
$ cd tests && ./bench --print-precision -onthreads=16 -s irf8192 -s irb8192 -s irf8192x8192 -s irb8192x8192 -s irf256x256x256 -s irb256x256x256
double
Problem: irf8192, setup: 1.14 s, time: 52.43 us, ``mflops'': 5078.4
Problem: irb8192, setup: 1.31 s, time: 55.21 us, ``mflops'': 4821.9
Problem: irf8192x8192, setup: 9.43 s, time: 94.82 ms, ``mflops'': 46006
Problem: irb8192x8192, setup: 9.26 s, time: 147.05 ms, ``mflops'': 29663
Problem: irf256x256x256, setup: 5.31 s, time: 26.05 ms, ``mflops'': 38635
Problem: irb256x256x256, setup: 5.33 s, time: 25.13 ms, ``mflops'': 40063
```

# aggressive 

## single precision

```
$ CFLAGS="-march=native" CXXFLAGS="-march=native" ./configure --enable-single --enable-sse --enable-sse2 --enable-shared --enable-openmp --enable-threads --enable-avx --enable-avx2 --enable-avx-128-fma 
$ make
$ make install
```

Running the benchmarks

```
$ cd tests &&./bench --print-precision -onthreads=16 -s irf8192x8192 -s irb8192x8192
single
Problem: irf8192x8192, setup: 28.68 s, time: 265.23 ms, ``mflops'': 16446
Problem: irb8192x8192, setup: 29.14 s, time: 267.86 ms, ``mflops'': 16285
```

## double precision


```
$ CFLAGS="-march=native" CXXFLAGS="-march=native" ./configure --enable-sse2 --enable-shared --enable-openmp --enable-threads --enable-avx --enable-avx2 
$ make
```

Running the benchmarks

```
$ cd tests && ./bench --print-precision -onthreads=16 -s irf8192 -s irb8192 -s irf8192x8192 -s irb8192x8192 -s irf256x256x256 -s irb256x256x256
double
Problem: irf8192, setup: 3.90 s, time: 176.47 us, ``mflops'': 1508.7
Problem: irb8192, setup: 4.90 s, time: 183.42 us, ``mflops'': 1451.5
Problem: irf8192x8192, setup: 22.53 s, time: 333.45 ms, ``mflops'': 13081
Problem: irb8192x8192, setup: 22.89 s, time: 329.62 ms, ``mflops'': 13233
Problem: irf256x256x256, setup: 11.65 s, time: 79.19 ms, ``mflops'': 12712
Problem: irb256x256x256, setup: 12.56 s, time: 72.34 ms, ``mflops'': 13915
```

### only openmp

```
$ CFLAGS="-march=native" CXXFLAGS="-march=native" ./configure --enable-sse2 --enable-shared --enable-openmp --enable-avx --enable-avx2 
$ make
```

Running the benchmarks

```
$ cd tests && ./bench --print-precision -onthreads=16 -s irf8192 -s irb8192 -s irf8192x8192 -s irb8192x8192 -s irf256x256x256 -s irb256x256x256
double
Problem: irf8192, setup: 2.93 s, time: 98.40 us, ``mflops'': 2705.7
Problem: irb8192, setup: 3.36 s, time: 92.01 us, ``mflops'': 2893.7
Problem: irf8192x8192, setup: 20.29 s, time: 324.57 ms, ``mflops'': 13440
Problem: irb8192x8192, setup: 20.04 s, time: 320.52 ms, ``mflops'': 13609
Problem: irf256x256x256, setup: 8.97 s, time: 67.00 ms, ``mflops'': 15025
Problem: irb256x256x256, setup: 9.34 s, time: 69.53 ms, ``mflops'': 14477
```

### only pthreads

```
$ CFLAGS="-march=native" CXXFLAGS="-march=native" ./configure --enable-sse2 --enable-shared --enable-threads --enable-avx --enable-avx2 
$ make
```

Running the benchmarks

```
$ cd tests && ./bench --print-precision -onthreads=16 -s irf8192 -s irb8192 -s irf8192x8192 -s irb8192x8192 -s irf256x256x256 -s irb256x256x256
double
Problem: irf8192, setup: 4.10 s, time: 172.16 us, ``mflops'': 1546.5
Problem: irb8192, setup: 5.13 s, time: 178.19 us, ``mflops'': 1494.2
Problem: irf8192x8192, setup: 21.38 s, time: 296.41 ms, ``mflops'': 14717
Problem: irb8192x8192, setup: 22.87 s, time: 327.23 ms, ``mflops'': 13330
Problem: irf256x256x256, setup: 11.88 s, time: 73.39 ms, ``mflops'': 13715
Problem: irb256x256x256, setup: 11.65 s, time: 90.13 ms, ``mflops'': 11168
```
