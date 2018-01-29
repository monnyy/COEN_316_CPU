# This is a comment line in a .do file
# add all signals to the Waveform window
add wave *

force reset_al 1
force clk_al 0
run 2

force clk_al 1

force reset_al 0 2 -r 4
force clk_al 1  2 -r 4
force clk_al 0  4 -r 4

# run for 9 clock periods
# 9 clock periods x timesteps per period
# = 36 timesteps

run 155
