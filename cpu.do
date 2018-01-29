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
# 39 clock periods x 4 timesteps per period
# = 156 timesteps

run 156
