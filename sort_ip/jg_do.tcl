clear -all
analyze -sv09 {*}[glob *.sv *.sva]
elaborate -top {sort_ip} ;#-bbox_a 8192
clock clk
reset rst
stopat {pe_array_u.pe_chain[*].genblk1.pe_u.reg_a}
prove -bg -all