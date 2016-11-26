#!/bin/bash

# $1 (compare|plot)

devs="GTX1080 K80 K20Xm P100-PCIE-16GB haswell"
path="../../results/"

runflag=$1

if [ "$runflag" == "compare" ]; then
    for dev in $devs; do
        for lib in `ls $path$dev`; do
            for f in `ls $path$dev/$lib/*.csv`; do
                filename="${f##*/}"
#                if [[ ! $filename =~ .*[123]d\.csv ]]; then #exclude intermediate results (e.g. haswell/fftw, requires)
                    filename="${filename%.*}"
                    outname="result_${dev}_${lib}_${filename}"
                # elif [[ $filename =~ .*1d\.csv ]]; then
                #     echo "combine $filename"
                #     sh combine.sh $f
                #     filename="${filename%.1d.csv}"
                #     outname="result_${dev}_${lib}_${filename}"
                #     f="$filename"
                # else
                #     continue;
                # fi
                echo "compare script: $f -> $outname.csv"
                ./compare.r -k "all" -a "library,precision,inplace" -f "${outname}" "$f" > "${outname}_compare.log" 2>&1 &
            done
        done
    done
    wait
    for f in `ls result_*.1d.csv`; do
        sh combine.sh $f 1
    done
fi



# 1 texfile
# 2 plotname
function add_plot {
    echo '\begin{mfigure}
        {\small{
          \input{'${2}'.tex}
        }}
        \caption{'${2//_/ }'}
\end{mfigure}' >> "$1"
}

# 1 texfile
# 2 sectitle
function add_section {
    echo '\msection{'${2//_/-}'}'>> "$1"
}
# 1 texfile
# 2 sectitle
function add_subsection {
    echo '\msubsection{'${2//_/-}'}'>> "$1"
}

if [ "$runflag" == "plot" ]; then
    texfile="figures.tex"
    >$texfile
    counter1=0
    processed=0
    for dev1 in $devs; do
        for lib1 in `ls $path$dev1`; do
            for f1 in `ls $path$dev1/$lib1/*.csv | grep -v "[23]d.csv$"`; do
                filename1="${f1##*/}"
                filename1="${filename1%.*}"
                filename1="${filename1%.1d}"
                add_section $texfile "$dev1 -- $lib1"
                counter1=$((counter1+1))
#                outname1="result_${dev1}_${lib1}_${filename1}"
                counter2=0
                for dev2 in $devs; do
                    for lib2 in `ls $path$dev2`; do
                        for f2 in `ls $path$dev2/$lib2/*.csv | grep -v "[23]d.csv$"`; do
                            counter2=$((counter2+1))
                            if [ "$counter1" -gt "$counter2" ]; then
                                continue;
                            fi
                            filename2="${f2##*/}"
                            filename2="${filename2%.*}"
                            filename2="${filename2%.1d}"
                            #                            outname2="result_${dev2}_${lib2}_${filename2}"
                            if [ "$dev1" == "$dev2" ] && [ "$lib1" == "$lib2" ] && [ "$filename1" == "$filename2" ]; then
                                add_subsection $texfile "$filename1 -- float vs. double"
#                                echo "[rc,prec,file] $outname1.csv  <->  $outname2.csv"
                                plotname="plot_${lib1}_${dev1}_${filename1}_float_double"
                                gnuplot -e "file='${filename1}';comp_rc='Real Complex';comp_prec='float double';lib='${lib1}';dev='${dev1}';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))

                            elif [ "$dev1" == "$dev2" ] && [ "$lib1" == "$lib2" ]; then
                                add_subsection $texfile "$filename2"
                                # float
                                plotname="plot_${lib1}_${dev1}_${filename1}_${filename2}_float"
                                gnuplot -e "comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='float';lib='${lib1}';dev='${dev1}';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))
                                # double
                                plotname="plot_${lib1}_${dev1}_${filename1}_${filename2}_double"
                                gnuplot -e "comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='double';lib='${lib1}';dev='${dev1}';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))
                            elif [ "$dev1" == "$dev2" ]; then
                                add_subsection $texfile "$lib2 $filename2"
                                # comp libs (comp_files still required, lib1 matches filename1, lib2 matches with filename2)
                                plotname="plot_${lib1}_${lib2}_${dev1}_${filename1}_${filename2}_float"
                                gnuplot -e "comp_libs='${lib1} ${lib2}';comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='float';dev='${dev1}';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))
                                plotname="plot_${lib1}_${lib2}_${dev1}_${filename1}_${filename2}_double"
                                gnuplot -e "comp_libs='${lib1} ${lib2}';comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='double';dev='${dev1}';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))
                            elif [ "$lib1" == "$lib2" ]; then
                                add_subsection $texfile "$dev2 $filename2"
                                # comp devices (comp_files still required, lib1 matches filename1, lib2 matches with filename2)
                                plotname="plot_${lib1}_${dev1}_${dev2}_${filename1}_${filename2}_float"
                                gnuplot -e "comp_devices='${dev1} ${dev2}';comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='float';lib='${lib1}';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))
                                plotname="plot_${lib1}_${dev1}_${dev2}_${filename1}_${filename2}_double"
                                gnuplot -e "comp_devices='${dev1} ${dev2}';comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='double';lib='${lib1}';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))
                            else
                                add_subsection $texfile "$lib2 $dev2 $filename2"
                                plotname="plot_${lib1}_${lib2}_${dev1}_${dev2}_${filename1}_${filename2}_float"
                                gnuplot -e "comp_libs='${lib1} ${lib2}';comp_files='${filename1} ${filename2}';comp_devices='${dev1} ${dev2}';comp_rc='Real Complex';prec='float';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))
                                plotname="plot_${lib1}_${lib2}_${dev1}_${dev2}_${filename1}_${filename2}_double"
                                gnuplot -e "comp_libs='${lib1} ${lib2}';comp_files='${filename1} ${filename2}';comp_devices='${dev1} ${dev2}';comp_rc='Real Complex';prec='double';filename='${plotname}'" plot.gnu &
                                add_plot $texfile $plotname && processed=$((processed+1))
                            fi
                        done
                    done
                done
            done
        done
    done
    wait
    echo "$processed processed diagrams."
fi
