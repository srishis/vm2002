run -all
coverage save vm_2002.ucdb
vcover report vm_2002.ucdb -cvg -details
vcover report -html vm2002_cov_report
coverage report -output cov_report_vm2002.txt -srcfile=* -assert -directive -cvg -codeAll
exit
