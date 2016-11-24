# requires gnuplot 5.0+
#

# comp_prec="prec1 prec2" | prec="prec"
# comp_rc="Real Complex"  | rc="real|complex"
# comp_libs="clfft cuda8" | lib="lib"
# comp_devices="k80 k20x" | dev="dev"
# render_png
# filename

reset
if(!exists("filename")) {
 print "Error. Missing filename."
 quit
}
if(!exists("comp_prec") && !exists("comp_rc")) {
 print "Error. Missing command line parameter."
 quit
}
if(!exists("comp_libs") && !exists("comp_devices")) {
 print "Error. Missing command line parameter."
 quit
}

# loop0 is inplace vs outplace
# loop1: real vs complex | prec1 vs prec2

if(exists("comp_prec")) {
print comp_prec
loop0_in = "comp_prec"
loop0_t = "prec"
#rc
}
if(exists("comp_rc")) {
print comp_rc
loop0_in = "comp_rc"
loop0_t = "rc"
#prec
}

# loop2: lib1 vs lib2 | dev1 vs dev2
# just affects infile

if(exists("comp_libs")) {
print comp_libs
loop2_in = "comp_libs"
loop2_t = "lib"
#dev
}
if(exists("comp_devices")) {
print comp_devices
loop2_in = "comp_devices"
loop2_t = "dev"
#lib
#todo title
}
comp_places="Inplace Outplace"
comp_kinds="powerof2 radix357 oddshape"
comp_dims="1 2 3"

mtitle="Total Time"

set datafile separator ','
set decimalsign '.'

set style line 100 lc rgb "#333333"
set style line 101 lc rgb "#aaaaaa"
set style line 102 lc rgb "#bbbbbb" dt 3
set border 15 front ls 100
set grid xtics mxtics ytics mytics ls 101, ls 102
set tics nomirror out scale 1.0


# real dp1 : complex dp2 -- loop0
dt1=1
dt2=2
# inplace : pt1, outplace : pt2 -- loop1
pt1=2
pt2=6
# lib1 : c1, lib2 : c2 -- loop2
c1="#aa2211"
c2="#331199"

if(!exists("render_png")) {
 llw=1.5
 pps=0.33
}else{
 llw=2
 pps=1.5
}

set linestyle 1 dt dt1 lw llw ps pps pt pt1 lc rgb c1 # inplace real
set linestyle 2 dt dt2 lw llw ps pps pt pt1 lc rgb c1 # inplace comp
set linestyle 3 dt dt1 lw llw ps pps pt pt2 lc rgb c1 # outplace real
set linestyle 4 dt dt2 lw llw ps pps pt pt2 lc rgb c1 # outplace comp

set linestyle 5 dt dt1 lw llw ps pps pt pt1 lc rgb c2 # inplace real
set linestyle 6 dt dt2 lw llw ps pps pt pt1 lc rgb c2 # inplace comp
set linestyle 7 dt dt1 lw llw ps pps pt pt2 lc rgb c2 # outplace real
set linestyle 8 dt dt2 lw llw ps pps pt pt2 lc rgb c2 # outplace comp

#size(d,x,y,z) = d==1 ? x : d==2 ? x*y : x*y*z;

set logscale x 2
set logscale y 10
# set xrange [1e5:1e9]
# set yrange [1:1e4]

#do for [prec in precs] {

if(exists("render_png")) {

set term pngcairo size 1800,1500 font 'Verdana,13' noenhanced
set output filename.".png" # lib."_".arch."_".prec.".png"

}else{ # use latex

set term cairolatex pdf color fontscale 0.5 size 4.95in, 3in dashlength 0.25
set output filename.".tex"
set format y "\\scriptsize{\\num{%.0te+%T}}"
}

# set key off
set ylabel "Time in ms" offset 3

#do for [dim=1:3] {
 #col=12
 # plot for [kind in kinds] for [typ=1:3] infile u (dim==$1 && typ==$5 && stringcolumn(6) eq kind ? $2*$3*$4 : 1/0 ):9 w lp ls id=id+1 ti sprintf("%s Typ=%d", kind, typ)

skiprows=1
#
col_x=13
col_mean=15
col_std=17
#
infile(dev,lib)=dev."_".lib.".csv"
#mdev=system(sprintf("awk -F, 'NR==2{gsub(\"\\\"\",\"\");print $12}' %s", infile(dev,lib)))
mdev="Device"
#set title sprintf("%s - %dD FFT (%s) on %s", mtitle, dim, kind, mdev)
ttitle=""

set multiplot layout 3,2 columnsfirst title ttitle

set key maxrows 2 at screen 0.95, screen 0.99 spacing 2.2

unset xlabel
set format x ''
set tmargin 2
set lmargin 9
set rmargin 0
set bmargin 0
set xrange[10:1e+10]
set yrange[1:1e+4]
set style textbox opaque noborder
counter=0


do for[kind in comp_kinds] {
dim=1
#set title sprintf("%s %dD", kind, dim)
counter=counter+1

if(!exists("render_png")) {
 if(counter==3) { set tmargin 0; set bmargin 3; set format x "\\scriptsize{\\num[exponent-base=2]{%.0le+%L}}"; set xlabel "Size in bytes" }
 set label 1 sprintf("\\scriptsize{\\texttt{%s %dD}}", kind, dim) at 1e+2,2e+3 boxed front # diagram title
}else{
 set label 1 sprintf("%s %dD", kind, dim) at 1e+3,2e+3 boxed front
}
id=0
set macros
plot for [k=1:2] 1/0 w l ls 4*k-1 lw 1.5*llw ti word(@loop2_in,k), \
     for [k=1:2] 1/0 w p ls 2*k-1 ps 1.5*pps ti word(comp_places,k), \
     for [k=1:2] 1/0 w l ls k     lw 1.5*llw ti word(@loop0_in,k), \
     for [@loop2_t in @loop2_in] for [place in comp_places] for [@loop0_t in @loop0_in] infile(dev,lib) every 1::skiprows u ( stringcolumn(3) eq place && stringcolumn(4) eq rc && stringcolumn(5) eq prec && dim==$6 && stringcolumn(7) eq kind ? column(col_x) : 1/0):col_mean w lp ls id=id+1 notitle

set tmargin 1
set bmargin 1
unset macros
unset key
}

#
unset ylabel
unset xlabel
set format y ''
set format x ''
set rmargin 4
set lmargin 5
set tmargin 2
set bmargin 0
counter=0
#

do for[dim in comp_dims] {
kind="powerof2"
dim=0+dim
counter=counter+1

if(!exists("render_png")) {
 if(counter==3) { set tmargin 0; set bmargin 3; set format x "\\scriptsize{\\num[exponent-base=2]{%.0le+%L}}"; set xlabel "Size in bytes" } #x axis tick labels
 set label 1 sprintf("\\scriptsize{\\texttt{%s %dD}}", kind, dim) at 1e+2,2e+3 boxed front # diagram title
}else{
 set label 1 sprintf("%s %dD", kind, dim) at 1e+3,2e+3 boxed front
}
id=0
set macros
plot for [@loop2_t in @loop2_in] for [place in comp_places] for [@loop0_t in @loop0_in] infile(dev,lib) every 1::skiprows u ( stringcolumn(3) eq place && stringcolumn(4) eq rc && stringcolumn(5) eq prec && dim==$6 && stringcolumn(7) eq kind ? column(col_x) : 1/0):col_mean w lp ls id=id+1 #ti sprintf("%s %s %s", place, @loop2_t, @loop0_t)
unset macros
set bmargin 1
set tmargin 1
}

unset multiplot
unset output
