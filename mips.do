force -freeze sim:/mipstop/resetb 0 0
force -freeze sim:/mipstop/clk 1 0, 0 {5000 ps} -r 10ns
run 15 ns
force -freeze sim:/mipstop/resetb 1 0
run 50 ns
