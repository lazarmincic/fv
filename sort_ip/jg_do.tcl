clear -all
analyze -sv09 sort_ip.sv check_sort_ip.sva bind.sva
elaborate -top {sort_ip}
clock clk
reset rst
prove -bg -all
