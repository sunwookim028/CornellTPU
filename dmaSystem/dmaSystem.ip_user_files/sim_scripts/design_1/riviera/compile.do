transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xilinx_vip
vlib riviera/xpm
vlib riviera/xil_defaultlib
vlib riviera/blk_mem_gen_v8_4_11

vmap xilinx_vip riviera/xilinx_vip
vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib
vmap blk_mem_gen_v8_4_11 riviera/blk_mem_gen_v8_4_11

vlog -work xilinx_vip  -incr -l axi_vip_v1_1_21 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_21 "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l blk_mem_gen_v8_4_11 \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/2025.1/Vivado/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xpm  -incr -l axi_vip_v1_1_21 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_21 "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l blk_mem_gen_v8_4_11 \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_fifo/hdl/xpm_fifo.sv" \
"C:/Xilinx/2025.1/Vivado/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l blk_mem_gen_v8_4_11 \
"c:/CornellTPU/dmaSystem/dmaSystem.gen/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/design_1_zynq_ultra_ps_e_0_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_dma_0_0/design_1_axi_dma_0_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_smc_0/design_1_axi_smc_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_rst_ps8_0_99M_0/design_1_rst_ps8_0_99M_0_sim_netlist.v" \
"../../../bd/design_1/ip/design_1_axi_smc_1_0/design_1_axi_smc_1_0_sim_netlist.v" \

vlog -work blk_mem_gen_v8_4_11  -incr -v2k5 "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l blk_mem_gen_v8_4_11 \
"../../../../dmaSystem.gen/sources_1/bd/design_1/ip/design_1_tpu_top_0_0/src/blk_mem_gen_0/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l blk_mem_gen_v8_4_11 \
"../../../bd/design_1/ip/design_1_tpu_top_0_0/src/blk_mem_gen_0/sim/blk_mem_gen_0.v" \
"../../../bd/design_1/ipshared/3380/hdl/tpu_top_slave_lite_v1_0_S00_AXI.v" \

vlog -work xil_defaultlib  -incr -l axi_vip_v1_1_21 -l smartconnect_v1_0 -l zynq_ultra_ps_e_vip_v1_0_21 "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l blk_mem_gen_v8_4_11 \
"../../../bd/design_1/ipshared/3380/887b/bram_top.sv" \
"../../../bd/design_1/ipshared/3380/887b/compute_top.sv" \
"../../../bd/design_1/ipshared/3380/887b/vadd.sv" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../Xilinx/2025.1/Vivado/data/rsb/busdef" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/7711/hdl" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/f0b6/hdl/verilog" "+incdir+../../../../dmaSystem.gen/sources_1/bd/design_1/ipshared/a8e4/hdl/verilog" "+incdir+C:/Xilinx/2025.1/Vivado/data/xilinx_vip/include" -l xilinx_vip -l xpm -l xil_defaultlib -l blk_mem_gen_v8_4_11 \
"../../../bd/design_1/ipshared/3380/hdl/tpu_top.v" \
"../../../bd/design_1/ip/design_1_tpu_top_0_0/sim/design_1_tpu_top_0_0.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"

