# add all signals to the waveform window
add wave x
add wave y
add wave add_sub
add wave ans
add wave logic_func
add wave logic_unit
add wave func
add wave true_out
add wave true_ovrflw
add wave true_zero
add wave output
add wave overflow
add wave zero
add wave over_check

force x "01111111111111111111111111111111"
force y "01111111111111111111111111111100"
force add_sub '0'
force logic_func "00"
force func "00"
run 2

force logic_func "01"
force func "10"
run 2

force add_sub '1'
force logic_func "10"
force func "11"
run 2

force logic_func "11"
run 2


force x "10000000010000000000000000000000"
force y "01110000000000000000000000000000"
force add_sub '0'
force logic_func "00"
force func "00"
run 2

force logic_func "01"
force func "10"
run 2

force add_sub '1'
force logic_func "10"
force func "11"
run 2

force logic_func "11"
run 2


force x "10000000000000000000000000000001"
force y "10000000000000000000000000000001"
force add_sub '0'
force logic_func "00"
force func "00"
run 2

force logic_func "01"
force func "10"
run 2

force add_sub '1'
force logic_func "10"
force func "11"
run 2

force logic_func "11"
run 2


force x "00000000000011111111000000000001"
force y "10000000000000000000000000000001"
force add_sub '0'
force logic_func "00"
force func "00"
run 2

force logic_func "01"
force func "10"
run 2

force add_sub '1'
force logic_func "10"
force func "11"
run 2

force logic_func "11"
run 2
