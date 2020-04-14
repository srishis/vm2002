all: setup compile run quit

setup:
		vlib work
		vmap work work

compile:
		vlog vm2002_pkg.svh vm2002.sv #vm2002_tb.sv 
		 
		
run:
		#vsim vm2002_tb -coverage &
		#log /* -r
		#run -all
		#coverage save vm_2002.ucdb
		#vcover report vm_2002.ucdb 
		#vcover report vm_2002.ucdb -cvg -details
		
quit: 
		quit -sim
