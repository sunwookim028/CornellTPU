vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xilinx_vip
vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib
vlib modelsim_lib/msim/blk_mem_gen_v8_4_11

vmap xilinx_vip modelsim_lib/msim/xilinx_vip
vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib
vmap blk_mem_gen_v8_4_11 modelsim_lib/msim/blk_mem_gen_v8_4_11

vlog -work xilinx_vip  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"c:/CornellTPU/dmaSystem/dmaSystem.gen/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/design_1_zynq_ultra_ps_e_0_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_dma_0_0/design_1_axi_dma_0_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_smc_0/design_1_axi_smc_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_rst_ps8_0_99M_0/design_1_rst_ps8_0_99M_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_smc_1_0/design_1_axi_smc_1_0_sim_netlist.v" \

vlog -work blk_mem_gen_v8_4_11  -incr -mfcu  "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../../dmaSystem.gen/sources_1/bd/design_1/ip/design_1_tpu_top_0_0/src/blk_mem_gen_0/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_tpu_top_0_0/src/blk_mem_gen_0/sim/blk_mem_gen_0.v" \
"../../../bd/design_1/ipshared/3380/hdl/tpu_top_slave_lite_v1_0_S00_AXI.v" \

vlog -work xil_defaultlib  -incr -mfcu  -sv -L axi_vip_v1_1_21 -L smartconnect_v1_0 -L zynq_ultra_ps_e_vip_v1_0_21 -L xilinx_vip "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ipshared/3380/887b/bram_top.sv" \
"../../../bd/design_1/ipshared/3380/887b/compute_top.sv" \
"../../../bd/design_1/ipshared/3380/887b/vadd.sv" \

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" \
"../../../bd/design_1/ipshared/3380/hdl/tpu_top.v" \
"../../../bd/design_1/ip/design_1_tpu_top_0_0/sim/design_1_tpu_top_0_0.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

