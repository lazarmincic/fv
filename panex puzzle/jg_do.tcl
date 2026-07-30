analyze -sv "panex.sv"
elaborate -top {panex}
clock clk -factor 1 -phase 1
reset -expression {rst}
#set_engine_mode {Tri}
#set_engineJ_max_trace_length 0
#ostalo za J..
prove -bg -all
