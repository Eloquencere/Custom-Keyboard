cd sim_data/
cls
vlog -f "../Compile_Order_Filelist.f"
vsim TestBench_Top -sv_seed random -c -do "run -all;exit"
@echo off
cd ..
