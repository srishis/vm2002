all: setup compile run clean

setup:
		vlib work
		vmap work work

compile:
		vlog vm2002_pkg.svh vm2002.sv vm2002_cov.sv vm2002Top.sv vm2002_if.sv 
		vopt vm2002Top -o top_optimized  +acc +cover=sbfec
		
run:
		vsim top_optimized -coverage  

clean: 
		rm -rf work transcript *~ vsim.wlf *.log
		


