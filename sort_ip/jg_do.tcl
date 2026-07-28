clear -all
analyze -sv09 {*}[glob *.sv *.sva]
elaborate -top {dup_cnt} ;#-bbox_a 8192
clock clk
reset rst
prove -bg -all