# add signals to the waveform window

add wave *
  
#lui

force in16 X"A316"
force func_se 00
run 2;

#slt
force in16 X"0316"
force func_se 01
run 2;

#arith

force in16 X"A417"
force func_se 10
run 2;

#logical

force func_se 11
run 2;
