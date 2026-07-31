analyze -sv09 "panex.sv"
elaborate -top {panex}
clock clk -factor 1 -phase 1
reset -expression {rst}
# S > 3, sa J:
#set_engine_mode {J}
#set_engineJ_attempts 1000 ;# jedino obavezno polje
#set_engineJ_max_trace_length 0
#set_engineJ_restarts 0
#set_engineJ_seed 0
#set_engineJ_single_property true
# S = 3, sa Tri:
#set_engine_mode {Tri}
#set_engine_threads 6 ;# samo ako se koristi 1 endzin
#prove -bg -property {panex.c_solved}
prove -bg -all
