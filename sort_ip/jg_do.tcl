clear -all
analyze -sv09 sort_ip.sv pe_array.sv fsm.sv pe.sv dup_cnt.sv check_sort_ip.sva check_pe.sva bind.sva
elaborate -bbox_a 8192 -top {pe}
clock clk
reset rst
prove -bg -all
