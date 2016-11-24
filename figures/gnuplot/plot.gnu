# requires gnuplot 5.0+
reset

#set terminal cairolatex standalone pdf size 27cm,17.5cm color transparent font 'Verdana,8'
#set output "cufft_1d_2d_3d_float_k80.tex"
#set output "cufft_1d_2d_3d_float_k20.tex"

libs="ClFFT CuFFT"

set datafile separator ','
skiprows=4

places="Inplace Outplace"
types="Real Complex"
precs="float double"
kinds="oddshape powerof2 radix357"

llw=1
pps=1
set linestyle 1 lw llw ps pps pt 1 lc rgb "#ff2200"
set linestyle 2 lw llw+1 ps pps pt 1 lc rgb "#ff2200"
set linestyle 3 lw llw+2 ps pps pt 1 lc rgb "#ff2200"

set linestyle 4 dt 2 lw llw ps 2*pps pt 3 lc rgb "#009900"
set linestyle 5 dt 2 lw llw+1 ps 2*pps pt 3 lc rgb "#009900"
set linestyle 6 dt 2 lw llw+2 ps 2*pps pt 3 lc rgb "#009900"

set linestyle 7 dt 2 lw llw ps pps pt 6 lc rgb "#0044ff"
set linestyle 8 dt 2 lw llw+1 ps pps pt 6 lc rgb "#0044ff"
set linestyle 9 dt 2 lw llw+2 ps pps pt 6 lc rgb "#0044ff"

set linestyle 10 dt 2 lw llw ps pps pt 7 lc rgb "#000000"
set linestyle 11 dt 2 lw llw+1 ps pps pt 7 lc rgb "#000000"
set linestyle 12 dt 2 lw llw+2 ps pps pt 7 lc rgb "#000000"

size(d,x,y,z) = d==1 ? x : d==2 ? x*y : x*y*z;

# set logscale xy
# set xrange [1e5:1e9]
# set yrange [1:1e4]

#do for [prec in precs] {
# set term pngcairo size 1800,1500 font 'Verdana,13' noenhanced
# set output lib."_".arch."_".prec.".png"
#set multiplot layout 3,2 columnsfirst title ttitle
# set key off
# set ylabel "runtime in ms"
#do for [dim=1:3] {
 #id=0
 #set title sprintf("Device FFT Runtime - %dD", dim)
 #col=12
 # plot for [kind in kinds] for [typ=1:3] infile u (dim==$1 && typ==$5 && stringcolumn(6) eq kind ? $2*$3*$4 : 1/0 ):9 w lp ls id=id+1 ti sprintf("%s Typ=%d", kind, typ)

kind="oddshape"
prec="float"
skiprows=1
dim=2
col_mean=15
id=0
plot for [place in places] for [type in types] for [lib in libs] lib.".csv" every 1::skiprows u (stringcolumn(5) eq prec && dim==$6 && stringcolumn(7) eq kind && stringcolumn(3) eq place && stringcolumn(4) eq type ? size(dim,$8,$9,$10) : 1/0):col_mean w lp ls id=id+1 ti sprintf("%s %s %s", place, type, lib)
#}

#unset multiplot
#unset output
#}#precs
