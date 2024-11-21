clear -all
analyze -sv09 sv_model.sv sv_model_checker.sv bind.sv
elaborate -top {sv_model}
clock clk
reset rst
prove -bg -all
