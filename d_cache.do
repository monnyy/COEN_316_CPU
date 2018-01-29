# add signals to the waveform window

add wave *

# reset

force reset 1
force clk 0
force input X"FAFA3B3B"
force data_write 0
run 2


# deassert reset and write into one of the locations

force reset 0
force data_write 1
force clk 1
run 2
force clk 0
run 2

# write into another location

force input X"FAFCCDE3"
force clk 1
run 2
force clk 0
run 2

# try writing into another location when clock is not asserted _fail

force input X"00003234"
run 2

# try writing into another location when clock is now asserted _pass

force clk 1
run 2
