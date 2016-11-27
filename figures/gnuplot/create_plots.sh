#!/bin/bash

# $1 (compare|plot)
# $2 [ymetric=Time_Total][ ...]
runflag=$1
if [ -z "$2" ]; then
    ymetrics="Time_Total"
else
    ymetrics=${2}
fi

devs="GTX1080 K80 K20Xm P100-PCIE-16GB haswell"
path="../../results/"
inpath="build/" # path for results*.csv used by gnuplot
outpath="figures/" # path for gnuplot diagrams

mkdir -p $inpath
mkdir -p $outpath

if [ "$runflag" == "compare" ]; then
for ymetric in ${ymetrics}; do
    echo $ymetric
    for dev in $devs; do
        for lib in `ls $path$dev`; do
            for f in `ls $path$dev/$lib/*.csv`; do
                filename="${f##*/}"
                filename="${filename%.*}"
                outname="result_${ymetric}_${dev}_${lib}_${filename}"  # result_* name pattern is also set in gnuplot script
                echo "$f -> ${inpath}$outname.csv"
                ./compare.r -k "all" --ymetric=${ymetric} -a "library,precision,inplace" -f "${inpath}${outname}" "$f" > "${inpath}${outname}_compare.log" 2>&1 &
            done
        done
    done
    wait
    cd "${inpath}"
    for f in `ls result_${ymetric}_*.1d.csv`; do
        sh ../combine.sh $f 1 # skip first row in csv files (header)
    done
    cd ..
done
fi



# 1 texfile
# 2 plotname
function add_plot {
    echo '\begin{mfigure}
        {\small{
          \input{\detokenize{'${outpath}${2}'.tex}}
        }}
        \caption{\detokenize{'${2//\~/ : }'}}
\end{mfigure}' >> "$1"
}

# 1 texfile
# 2 title
function add_chapter {
    echo '\mchapter{'${2//_/ }'}'>> "$1"
}

# 1 texfile
# 2 sectitle
function add_section {
    echo '\msection{'${2//_/-}'}'>> "$1"
}

# 1 texfile
# 2 subsectitle
function add_subsection {
    echo '\msubsection{'${2//_/-}'}'>> "$1"
}


if [ "$runflag" == "plot" ]; then
    texfile="figures.tex"
    >$texfile
for ymetric in ${ymetrics}; do
    echo $ymetric
    add_chapter ${texfile} ${ymetric}
    counter1=0
    processed=0
    gpdef="inpath='${inpath}';outpath='${outpath}';ymetric='${ymetric}';" # gnuplot default input parameter

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
                                add_subsection ${texfile} "$filename1 -- float vs. double"
#                                echo "[rc,prec,file] $outname1.csv  <->  $outname2.csv"
                                plotname="plot~${ymetric}~${lib1}~${dev1}~${filename1}~float~double"
                                gnuplot -e "file='${filename1}';comp_rc='Real Complex';comp_prec='float double';lib='${lib1}';dev='${dev1}';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))

                            elif [ "$dev1" == "$dev2" ] && [ "$lib1" == "$lib2" ]; then
                                add_subsection ${texfile} "$filename2"
                                # float
                                plotname="plot~${ymetric}~${lib1}~${dev1}~${filename1}~${filename2}~float"
                                gnuplot -e "comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='float';lib='${lib1}';dev='${dev1}';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))
                                # double
                                plotname="plot~${ymetric}~${lib1}~${dev1}~${filename1}~${filename2}~double"
                                gnuplot -e "comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='double';lib='${lib1}';dev='${dev1}';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))
                            elif [ "$dev1" == "$dev2" ]; then
                                add_subsection ${texfile} "$lib2 $filename2"
                                # comp libs (comp_files still required, lib1 matches filename1, lib2 matches with filename2)
                                plotname="plot~${ymetric}~${lib1}~${lib2}~${dev1}~${filename1}~${filename2}~float"
                                gnuplot -e "comp_libs='${lib1} ${lib2}';comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='float';dev='${dev1}';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))
                                plotname="plot~${ymetric}~${lib1}~${lib2}~${dev1}~${filename1}~${filename2}~double"
                                gnuplot -e "comp_libs='${lib1} ${lib2}';comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='double';dev='${dev1}';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))
                            elif [ "$lib1" == "$lib2" ]; then
                                add_subsection ${texfile} "$dev2 $filename2"
                                # comp devices (comp_files still required, lib1 matches filename1, lib2 matches with filename2)
                                plotname="plot~${ymetric}~${lib1}~${dev1}~${dev2}~${filename1}~${filename2}~float"
                                gnuplot -e "comp_devices='${dev1} ${dev2}';comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='float';lib='${lib1}';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))
                                plotname="plot~${ymetric}~${lib1}~${dev1}~${dev2}~${filename1}~${filename2}~double"
                                gnuplot -e "comp_devices='${dev1} ${dev2}';comp_files='${filename1} ${filename2}';comp_rc='Real Complex';prec='double';lib='${lib1}';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))
                            else
                                add_subsection ${texfile} "$lib2 $dev2 $filename2"
                                plotname="plot~${ymetric}~${lib1}~${lib2}~${dev1}~${dev2}~${filename1}~${filename2}~float"
                                gnuplot -e "comp_libs='${lib1} ${lib2}';comp_files='${filename1} ${filename2}';comp_devices='${dev1} ${dev2}';comp_rc='Real Complex';prec='float';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))
                                plotname="plot~${ymetric}~${lib1}~${lib2}~${dev1}~${dev2}~${filename1}~${filename2}~double"
                                gnuplot -e "comp_libs='${lib1} ${lib2}';comp_files='${filename1} ${filename2}';comp_devices='${dev1} ${dev2}';comp_rc='Real Complex';prec='double';filename='${plotname}';${gpdef}" plot.gnu &
                                add_plot ${texfile} ${plotname} && processed=$((processed+1))
                            fi
                        done # f2
                    done # lib2
                done # dev2
                wait
            done # f1
        done # lib1
    done # dev1
    echo "$processed processed diagrams."
done # ymetric
fi
