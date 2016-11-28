
k80_files = $(wildcard ../results/K80/cuda-8.0.44/*csv)
gtx1080_files = $(wildcard ../results/GTX1080/cuda-8.0.44/*csv)

svg_files = $(wildcard *.svg)

TARGETS = K80 GTX1080

all : $(TARGETS)

k80_cuda8_3d : $(k80_files)
	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"

k80_cuda8 : $(k80_files)
	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" -f $(@)_legend --notitle --legend-only $? > $(@)_legend_only.log 2>&1

gtx1080_cuda8 : $(gtx1080_files)
	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" -f $(@)_legend --notitle --legend-only $? > $(@)_legend_only.log 2>&1


k80_cuda8_2d : $(k80_files)
	./compare -r -k "oddshape" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"	

k80_cuda8_1d : $(k80_files)
	./compare -r -k "oddshape" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"	

gtx1080_cuda8_3d : $(gtx1080_files)
	./compare -r -k "oddshape" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 3 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"

gtx1080_cuda8_2d : $(gtx1080_files)
	./compare -r -k "oddshape" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 2 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"	

gtx1080_cuda8_1d : $(gtx1080_files)
	./compare -r -k "oddshape" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_real $? > $(@)_oddshape_real_compare.log 2>&1
	./compare -r -k "powerof2" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_real $?	> $(@)_powerof2_real_compare.log 2>&1
	./compare -r -k "radix357" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_real $? > $(@)_radix357_real_compare.log 2>&1
	./compare -c -k "oddshape" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_oddshape_comp $? > $(@)_oddshape_comp_compare.log 2>&1
	./compare -c -k "powerof2" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_powerof2_comp $?	> $(@)_powerof2_comp_compare.log 2>&1
	./compare -c -k "radix357" -n 1 -a "library,precision,inplace" --notitle --nolegend -f $(@)_radix357_comp $? > $(@)_radix357_comp_compare.log 2>&1
	@echo "$(@) done"	

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
