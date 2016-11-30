
k80_files = $(wildcard ../results/K80/cuda-8.0.44/*csv)
gtx1080_files = $(wildcard ../results/GTX1080/cuda-8.0.44/*csv)

cufft8_files = $(wildcard ../results/*/cuda-8.0.44/cufft*.[0-9].csv)

clfft_cpu_files = $(wildcard ../results/haswell/clfft*/*csv)
clfft_gpu_files = $(wildcard ../results/[A-Z]*/clfft-2.12.2/*csv)

cufft8_K20xm_files = $(wildcard ../results/K20*/cuda-8*/*csv)
cufft8_K80_files = $(wildcard ../results/K80/cuda-8*/*csv)
cufft8_P100_files = $(wildcard ../results/P100*/cuda-8*/cufft*.[0-9].csv)
cufft8_GTX1080_files = $(wildcard ../results/GTX1080/cuda-8*/cufft*.[0-9].csv)

estimate_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_estimate*csv)
measure_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_gcc*csv)
wisdom_fftw_files = $(wildcard ../results/haswell/fftw-3.3.5/fftw_wisdom*csv)

TARGETS = results_tts results_plan_flags results_plan_time results_r2c_fwd results_non_power_of_2 results_r2c_vs_c2c

all : $(TARGETS)

results_tts : $(cufft8_files) $(estimate_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --notitle --nolegend -f $(@)_a $? > $(@)_a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 -f $(@)_b $? > $(@)_b.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "hardware,library" --notitle --legend-only -f $(@)_legend $? > $(@)_legend.log 2>&1

results_plan_flags : $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "flags" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 -f $(@)_a $? > $(@)_a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "flags" --xlabel="Signal_Size_[bytes]" --notitle --nolegend --logy=10 --logx=2 --ymetric="Time_FFT" -f $(@)_b $? > $(@)_b.log 2>&1
	./compare -r -s -o -k "powerof2" -n 3 -a "flags" --notitle --legend-only -f $(@)_legend $? > $(@)_legend.log 2>&1

results_plan_time : $(clfft_K80_gpu_files) $(cufft8_K80_files) $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files)
	@echo "input: $(?)"
	./compare -r -s -o -k "powerof2" -n 3 -a "flags,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_PlanInitFwd" --ylabel="Time_for_Planning_[ms]" --notitle --logy=10 --logx=2 -f $(@)_a $? > $(@)_a.log 2>&1
	./compare -r -s -o -k "powerof2" -n 1 -a "flags" --xlabel="Signal_Size_[bytes]" --ymetric="Time_PlanInitFwd" --ylabel="Time_for_Planning_[ms]" --notitle --logy=10 --logx=2 -f $(@)_b  $(estimate_fftw_files) $(measure_fftw_files) $(wisdom_fftw_files) > $(@)_b.log 2>&1

results_transfer_times : $(cufft8_files)
	@echo "input: $(?)"
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --nolegend --ylimit=0,100 --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Download+Time_Upload)/Time_Total" --ylabel="(Upload+Download)/Total_[%]" --notitle --logx=2 -f $(@)a $? > $(@)a.log 2>&1
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Download)/Time_Total" --ylabel="Download/Total_[%]" --notitle --logx=2 -f $(@)_download $? > $(@)_download.log 2>&1
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Upload)/Time_Total" --ylabel="Upload/Total_[%]" --notitle --logx=2 -f $(@)_upload $? > $(@)_upload.log 2>&1
	@echo "input: $(clfft_gpu_files)"	
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --nolegend --ylimit=0,100 --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Download+Time_Upload)/Time_Total" --ylabel="(Upload+Download)/Total_[%]" --notitle --logx=2 -f $(@)b $(clfft_gpu_files) > $(@)b.log 2>&1
	./compare -r -s -k "powerof2" -n 3 -a "hardware,inplace" --legend-only --ylimit=0,100 --xlabel="Signal_Size_[bytes]" --ymetric="100.*(Time_Download+Time_Upload)/Time_Total" --ylabel="(Upload+Download)/Total_[%]" --notitle --logx=2 -f $(@)_legend $? > $(@)_legend.log 2>&1


results_r2c_fwd : $(cufft8_files) $(clfft_gpu_files) $(measure_fftw_files)
	@echo "input: $(?)"
	./compare -r -o -s -k "powerof2" -n 3 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --nolegend --notitle --logy=10 --logx=2 -f $(@)_a $? > $(@)_a.log 2>&1
	./compare -r -o -s -k "powerof2" -n 1 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --nolegend --notitle --logy=10 --logx=2 -f $(@)_b $? > $(@)_b.log 2>&1
	./compare -r -o -s -k "powerof2" -n 1 -a "hardware,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --legend-only --notitle --logy=10 --logx=2 -f $(@)_legend $? > $(@)_legend.log 2>&1

results_non_power_of_2 : $(cufft8_K80_files) $(cufft8_P100_files) $(measure_fftw_files)
	@echo "input: $(?)"
	./compare -k "all" -r -o -s -n 3 -a "hardware,kind,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --nolegend --notitle --logy=10 --logx=2 -f $(@)_a $? > $(@)_a.log 2>&1
	./compare -k "all" -r -o -s -n 3 -a "hardware,kind,library" --xlabel="Signal_Size_[bytes]" --ylabel="Time_for_Planning_[ms]" --ymetric="Time_PlanInitFwd" --nolegend --notitle --logy=10 --logx=2 -f $(@)_b $? > $(@)_b.log 2>&1
	./compare -k "all" -r -o -s -n 1 -a "hardware,kind,library" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --legend-only --notitle --logy=10 --logx=2 -f $(@)_legend $? > $(@)_legend.log 2>&1

results_r2c_vs_c2c : $(cufft8_P100_files) $(measure_fftw_files)
	@echo "input: $(?)"
	#./compare -k "powerof2" -s -o -n 3 -a "hardware,complex" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --nolegend --notitle --logy=10 --logx=2 -f $(@)_a $? > $(@)_a.log 2>&1
	./compare -k "powerof2" -s -o -n 3 -a "hardware,complex" --ylimit=0.0625,1250 --xlimit=1,4096 --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --notitle --logy=2 --logx=2 -f $(@)_a $? > $(@)_a.log 2>&1
	#./compare -k "powerof2" -r -o -n 3 -a "hardware,precision" --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --nolegend --notitle --logx=10 -f $(@)_b $? > $(@)_b.log 2>&1
	./compare -k "powerof2" -r -o -n 3 -a "hardware,precision" --ylimit=0.0625,1250 --xlimit=1,4096 --xlabel="Signal_Size_[bytes]" --ymetric="Time_FFT" --notitle --logy=2 --logx=2 -f $(@)_b $? > $(@)_b.log 2>&1


clean :
	rm -vf  *tex
	rm -vf *.png
	rm -vf *.pdf
	rm -vf *.svg
	rm -vf *.log

distclean : clean
	rm -vf *compare.log
