#############################################################
# vsimsa environment configuration
set dsn $curdir
log $dsn/log/vsimsa.log
@echo
@echo #################### Starting C Code Debug Session ######################
cd $dsn/src
amap work_sim $dsn/work_sim/work_sim.lib
set worklib work_sim
# simulation
asim -callbacks -advdataflow  -O5 -L ovi_ice -L ice +access +r +p+/top_tb/uut/processor_zipi8/decode4_pc_statck_i top_tb Behavioral
run -all
#############################################################