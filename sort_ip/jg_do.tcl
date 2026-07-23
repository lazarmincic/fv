clear -all
analyze -sv09 sort_ip.sv pe_array.sv fsm.sv pe.sv dup_cnt.sv check_sort_ip.sva bind.sva
elaborate -top {sort_ip}
clock clk
reset rst
prove -bg -all
