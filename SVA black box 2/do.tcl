clear -all
analyze -sv09 v_bb_model.v v_bb_model_checker.sv bind.sv
elaborate -top v_bb_model
clock CLK
reset RST
prove -bg -all
