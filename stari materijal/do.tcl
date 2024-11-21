clear -all
analyze -sv09 zadaci_checker.sv bind.sv
analyze -vhdl zadaci.vhd
# elaborate -top and_case
elaborate -vhdl -top zadaci
clock clk
reset rst
prove -bg -all
