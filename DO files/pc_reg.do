# add signals to the waveform window

add wave rt
add wave rs
add wave pc
add wave target_address
add wave branch_type
add wave pc_sel
add wave pc_host
add wave next_pc
  
#initialization

force pc X"00000000"
force pc_sel "00"
force target_address "00111011001110001100010110"

# no branch

force rt X"00000001"
force rs X"00000002"
force branch_type "00"
run 2


# branch on equal_ fail

force pc X"00000001"
force branch_type "01"
run 2

# branch on equal_ pass

force pc X"00000002"
force rt X"00000003"
force rs X"00000003"
run 2


# branch when not equal_ fail

force pc X"00000003"
force branch_type "10"
run 2

# branch when not equal_ pass

force pc X"00000004"
force rt X"00000004"
force rs X"00000005"
run 2


# branch when less than zero_ fail

force pc X"00000005"
force branch_type "11"
run 2

# branch when less than zero_ pass

force pc X"00000006"
force rs X"F1234567"
run 2

# testing the jump

force target_address "00111011001110001100010111"
force pc X"00000007"
force pc_sel "01"
run 2

# testing jump register

force pc X"00000008"
force pc_sel "10"
force rs X"ABCD0000"
run 2
