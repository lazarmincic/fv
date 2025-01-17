analyze -sv "panex.sv"
elaborate -top {panex}
clock clk -factor 1 -phase 1
reset -expression {rst}
prove -bg -all
