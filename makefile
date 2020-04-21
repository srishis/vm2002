all: setup compile run quit

setup:
		vlib work
		vmap work work

compile:
		vlog vm2002_pkg.svh vm2002.sv vm2002Top.sv vm2002_if.sv 
		vopt vm2002_tb -o top_optimized  +acc +cover=sbfec
		
run:
		vsim top_optimized -coverage
		log /* -r
		run -all
		coverage save vm_2002.ucdb
		vcover report vm_2002.ucdb 
		vcover report vm_2002.ucdb -cvg -details
		
quit: 
		quit -sim
