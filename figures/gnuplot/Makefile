# GTX1080
all : compare plot pdf

compare :
	sh ./create_plots.sh compare "Time_Total Time_FFT Time_Upload Time_PlanInitFwd"
	@echo "$(@) done"  

plot :
	sh ./create_plots.sh plot "Time_Total Time_FFT Time_Upload Time_PlanInitFwd"
	@echo "$(@) done"

pdf :
	pdflatex \\nonstopmode\\input figures_master.tex > figures_master.err 2>&1
	@echo "For TOC update you need to run 2 times"

clean :
	rm build/* figures/* figures_*.toc figures_*.aux figures_*.out figures_*.log
