
k20xm_cuda8_files = $(wildcard ../../results/K20Xm/cuda-8.0.44/*csv)
k20xm_clfft_files = $(wildcard ../../results/K20Xm/clfft-2.12.2/*csv)
k80_cuda8_files = $(wildcard ../../results/K80/cuda-8.0.44/*csv)
k80_clfft_files = $(wildcard ../../results/K80/clfft-2.12.2/*csv)
gtx1080_cuda8_files = $(wildcard ../../results/GTX1080/cuda-8.0.44/*csv)
gtx1080_clfft_files = $(wildcard ../../results/GTX1080/clfft-2.12.2/*csv)

TARGETS = K20Xm K80
# GTX1080
all : $(TARGETS)

k20xm_clfft : $(k80_clfft_files)
	./compare.r -k "all" -a "library,precision,inplace" -f $(@) $? > $(@)_compare.log 2>&1
	@echo "$(@) done"  

k20xm_cuda8 : $(k80_cuda8_files)
	./compare.r -k "all" -a "library,precision,inplace" -f $(@) $? > $(@)_compare.log 2>&1
	@echo "$(@) done"  

k80_clfft : $(k80_clfft_files)
	./compare.r -k "all" -a "library,precision,inplace" -f $(@) $? > $(@)_compare.log 2>&1
	@echo "$(@) done"  

k80_cuda8 : $(k80_cuda8_files)
	./compare.r -k "all" -a "library,precision,inplace" -f $(@) $? > $(@)_compare.log 2>&1
	@echo "$(@) done"


K20Xm : k20xm_clfft k20xm_cuda8
K80 : k80_clfft k80_cuda8

k80_cuda8_clfft :
	gnuplot -e "comp_rc='Real Complex';prec='float';comp_libs='clfft cuda8';dev='k80';filename='$(@)'" plot.gnu
	gnuplot -e "comp_rc='Real Complex';prec='float';comp_libs='clfft cuda8';dev='k80';filename='png_$(@)';render_png=1" plot.gnu # png_.. to avoid clash in latex

k20xm_k80_cuda8 :
	gnuplot -e "comp_rc='Real Complex';prec='float';lib='cuda8';comp_devices='k20xm k80';filename='$(@)'" plot.gnu
	gnuplot -e "comp_rc='Real Complex';prec='float';lib='cuda8';comp_devices='k20xm k80';filename='png_$(@)';render_png=1" plot.gnu # png_.. to avoid clash in latex

plot : k80_cuda8_clfft k20xm_k80_cuda8
