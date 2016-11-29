
k80_files = $(wildcard ../results/K80/cuda-8.0.44/*csv)
gtx1080_files = $(wildcard ../results/GTX1080/cuda-8.0.44/*csv)

cufft8_files = $(wildcard ../results/*/cuda-8.0.44/cufft*.[0-9].csv)

clfft_cpu_files = $(wildcard ../results/haswell/clfft*/*csv)
clfft_gpu_files = $(wildcard ../results/[A-Z]*/clfft-2.12.2/*csv)
cufft8_K80_files = $(wildcard ../results/K80/cuda-8*/*csv)

estimate_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_estimate*csv)
measure_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_gcc*csv)
wisdom_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_wisdom*csv)

svg_files = $(wildcard *.svg)

TARGETS = results_figure1 results_figure2 results_figure3 results_figure4

all : $(TARGETS)

results_figure1 : $(cufft8_files) $(estimate_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --notitle --nolegend -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 -f $(@)b $? > $(@)b.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --notitle --legend-only -f $(@)_legend $? > $(@)_legend.log 2>&1

results_figure2 : $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "flags" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "flags" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 --ymetric="Time_FFT" -f $(@)b $? > $(@)b.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "flags" --notitle --legend-only -f $(@)_legend $? > $(@)_legend.log 2>&1

results_figure3 : $(clfft_K80_gpu_files) $(cufft8_K80_files) $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "flags,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_PlanInitFwd" --ylabel="Time_for_Planning_[ms]" --notitle --logy=10 --logx=2 -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 1 -a "flags" --xlabel="Signal_Size_[bytes]" --ymetric="Time_PlanInitFwd" --ylabel="Time_for_Planning_[ms]" --notitle --logy=10 --logx=2 -f $(@)b  $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files) > $(@)b.log 2>&1

results_figure4 : $(cufft8_files)
	@echo "input: $(?)"
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --nolegend --ylimit=0,100 --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Download+Time_Upload)/Time_Total" --ylabel="(Upload+Download)/Total_[%]" --notitle --logx=2 -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Download)/Time_Total" --ylabel="Download/Total_[%]" --notitle --logx=2 -f $(@)_download $? > $(@)_download.log 2>&1
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Upload)/Time_Total" --ylabel="Upload/Total_[%]" --notitle --logx=2 -f $(@)_upload $? > $(@)_upload.log 2>&1
	@echo "input: $(clfft_gpu_files)"	
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --nolegend --ylimit=0,100 --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Download+Time_Upload)/Time_Total" --ylabel="(Upload+Download)/Total_[%]" --notitle --logx=2 -f $(@)b $(clfft_gpu_files) > $(@)b.log 2>&1
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --legend-only --ylimit=0,100 --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Download+Time_Upload)/Time_Total" --ylabel="(Upload+Download)/Total_[%]" --notitle --logx=2 -f $(@)_legend $? > $(@)_legend.log 2>&1


results_figure5 : $(cufft8_files) $(clfft_gpu_files) $(measure_fftw_files)
	@echo "input: $(?)"
	./compare -r -o -s -k "powerof2" -n 3 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --nolegend --notitle --logy=10 --logx=2 -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -o -s -k "powerof2" -n 1 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --nolegend --notitle --logy=10 --logx=2 -f $(@)b $? > $(@)b.log 2>&1
	./compare -r -o -s -k "powerof2" -n 1 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --legend-only --notitle --logy=10 --logx=2 -f $(@)_legend $? > $(@)_legend.log 2>&1

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
