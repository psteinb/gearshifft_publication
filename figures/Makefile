
k80_files = $(wildcard ../results/K80/cuda-8.0.44/*csv)

TARGETS = K80

all : $(TARGETS)

k80_cuda8_3d : $(k80_files)
	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 3 -a "library,precision,inplace" -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 3 -a "library,precision,inplace" -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 3 -a "library,precision,inplace" -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 3 -a "library,precision,inplace" -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 3 -a "library,precision,inplace" -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"

k80_cuda8_2d : $(k80_files)
	./compare -r -k "oddshape" -n 2 -a "library,precision,inplace" -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 2 -a "library,precision,inplace" -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 2 -a "library,precision,inplace" -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 2 -a "library,precision,inplace" -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 2 -a "library,precision,inplace" -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 2 -a "library,precision,inplace" -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"	

k80_cuda8_1d : $(k80_files)
	./compare -r -k "oddshape" -n 1 -a "library,precision,inplace" -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 1 -a "library,precision,inplace" -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 1 -a "library,precision,inplace" -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 1 -a "library,precision,inplace" -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 1 -a "library,precision,inplace" -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 1 -a "library,precision,inplace" -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"	



K80 : k80_cuda8_3d 	k80_cuda8_2d 	k80_cuda8_1d 	k80_cuda8_3d 	k80_cuda8_2d 	k80_cuda8_1d 

clean :
	rm -vf  k80_cuda8*.{png,svg,tex} 
	# rm -vf  k80_cuda8_2d*.{svg.png,tex} 
	# rm -vf  k80_cuda8_1d*.{svg.png,tex} 
	# rm -vf k80_cuda8_3d*.{svg.png,tex}
	# rm -vf k80_cuda8_2d*.{svg.png,tex}
	# rm -vf k80_cuda8_1d*.{svg.png,tex}

distclean : clean
	rm -vf *_oddshape*compare.log
	rm -vf *_powerof2*compare.log
	rm -vf *_radix357*compare.log
