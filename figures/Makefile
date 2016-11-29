
k80_files = $(wildcard ../results/K80/cuda-8.0.44/*csv)
gtx1080_files = $(wildcard ../results/GTX1080/cuda-8.0.44/*csv)

cufft8_files = $(wildcard ../results/*/cuda-8.0.44/cufft*csv)

clfft_cpu_files = $(wildcard ../results/haswell/clfft*/*csv)
clfft_K80_gpu_files = $(wildcard ../results/K80/clfft*/*csv)
cufft8_K80_files = $(wildcard ../results/K80/cuda-8*/*csv)

estimate_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_estimate*csv)
measure_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_gcc*csv)
wisdom_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_wisdom*csv)

svg_files = $(wildcard *.svg)

TARGETS = results_figure1 results_figure2 results_figure3

all : $(TARGETS)

results_figure1 : $(cufft8_files) $(estimate_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --notitle --nolegend -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 -f $(@)b $? > $(@)b.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --notitle --legend-only -f $(@)_legend $? > $(@)_legend.log 2>&1
	#./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --notitle -f $(@)_check $? > $(@)a_check.log 2>&1

results_figure2 : $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "plan_flags" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "plan_flags" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 --ymetric="Time_FFT" -f $(@)b $? > $(@)b.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "plan_flags" --notitle --legend-only -f $(@)_legend $? > $(@)_legend.log 2>&1

results_figure3 : $(clfft_K80_gpu_files) $(cufft8_K80_files) $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "plan_flags,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_PlanInitFwd" --ylabel="Time_for_Planning_[ms]" --notitle --logy=10 --logx=2 -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 1 -a "plan_flags" --xlabel="Signal_Size_[bytes]" --ymetric="Time_PlanInitFwd" --ylabel="Time_for_Planning_[ms]" --notitle --logy=10 --logx=2 -f $(@)b  $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files) > $(@)b.log 2>&1
	#./compare -r -s -o -k "powerof2" -n 1 -a "plan_flags,library" --notitle --legend-only -f $(@)_legend $? > $(@)_legend.log 2>&1

# k80_cuda8_3d : $(k80_files)
# 	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
# 	./compare -r -k "powerof2" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
# 	./compare -r -k "radix357" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
# 	./compare -c -k "oddshape" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
# 	./compare -c -k "powerof2" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
# 	./compare -c -k "radix357" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
# 	@echo "$(@) done"

# k80_cuda8 : $(k80_files)
# 	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" -f $(@)_legend --notitle --legend-only $? > $(@)_legend_only.log 2>&1

# gtx1080_cuda8 : $(gtx1080_files)
# 	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" -f $(@)_legend --notitle --legend-only $? > $(@)_legend_only.log 2>&1


# k80_cuda8_2d : $(k80_files)
# 	./compare -r -k "oddshape" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
# 	./compare -r -k "powerof2" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
# 	./compare -r -k "radix357" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
# 	./compare -c -k "oddshape" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
# 	./compare -c -k "powerof2" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
# 	./compare -c -k "radix357" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
# 	@echo "$(@) done"	

# k80_cuda8_1d : $(k80_files)
# 	./compare -r -k "oddshape" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
# 	./compare -r -k "powerof2" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
# 	./compare -r -k "radix357" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
# 	./compare -c -k "oddshape" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
# 	./compare -c -k "powerof2" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
# 	./compare -c -k "radix357" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
# 	@echo "$(@) done"	

# gtx1080_cuda8_3d : $(gtx1080_files)
# 	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
# 	./compare -r -k "powerof2" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
# 	./compare -r -k "radix357" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
# 	./compare -c -k "oddshape" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
# 	./compare -c -k "powerof2" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
# 	./compare -c -k "radix357" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
# 	@echo "$(@) done"

# gtx1080_cuda8_2d : $(gtx1080_files)
# 	./compare -r -k "oddshape" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
# 	./compare -r -k "powerof2" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
# 	./compare -r -k "radix357" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
# 	./compare -c -k "oddshape" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
# 	./compare -c -k "powerof2" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
# 	./compare -c -k "radix357" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
# 	@echo "$(@) done"	

# gtx1080_cuda8_1d : $(gtx1080_files)
# 	./compare -r -k "oddshape" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
# 	./compare -r -k "powerof2" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
# 	./compare -r -k "radix357" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
# 	./compare -c -k "oddshape" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
# 	./compare -c -k "powerof2" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
# 	./compare -c -k "radix357" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
# 	@echo "$(@) done"	

svg2pdf : $(svg_files)
	$(foreach f,$^,inkscape -z -D --file=$(f) --export-pdf=$(basename $(f)).pdf --export-latex;)

K80 : k80_cuda8_3d 	k80_cuda8_2d 	k80_cuda8_1d k80_cuda8

GTX1080 : gtx1080_cuda8_3d 	gtx1080_cuda8_2d 	gtx1080_cuda8_1d gtx1080_cuda8

clean :
	rm -vf  *tex
	rm -vf *.png
	rm -vf *.pdf
	rm -vf *.svg

distclean : clean
	rm -vf *compare.log
