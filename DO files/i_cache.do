# add signals to the waveform window

add wave *
  
#initialization and addi r1, r0, 1

force input_addr "00000"
run 2;

# addi r2, r0, 2

force input_addr "00001"
run 2;


# add r2, r2, r1

force input_addr "00010"
run 2;

# jump 00010

force input_addr "00011"
run 2;


# don’t care

force input_addr "00100"
run 2;
