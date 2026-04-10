module load mentor/QUESTA_ULTRA/2021.1

curdir=$(pwd)

rm -rf ${curdir}/work

# Create output directory

vlib -p ${curdir}/work

vlog \
    ${curdir}/syst_ws.sv \
    ${curdir}/syst_ws_tb.sv \
        +incdir+${curdir} -work ${curdir}/work -l ${curdir}/compile.log

vopt -64 -work ${curdir}/work syst_ws_tb -o testbench_opt +acc \
    -l ${curdir}/opt.log

vsim -64 testbench_opt -work ${curdir}/work -gui -sv_seed $RANDOM \
    -l ${curdir}/run.log -do questa.tcl -do "run -a; quit;"
