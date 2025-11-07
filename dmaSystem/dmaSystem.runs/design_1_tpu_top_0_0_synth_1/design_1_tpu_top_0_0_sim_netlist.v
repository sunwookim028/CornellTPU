// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
// Date        : Fri Nov  7 16:16:47 2025
// Host        : Mukund_laptop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_tpu_top_0_0_sim_netlist.v
// Design      : design_1_tpu_top_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sbva484-1-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bram_top
   (bram_done,
    \slv_reg6_reg[30] ,
    Q,
    \i_reg[15] ,
    \i_reg[22] ,
    DI,
    \i_reg[22]_0 ,
    s00_axi_aclk,
    SR,
    state1_carry__0_i_12,
    S,
    state2_carry_i_5_0,
    state2_carry_i_3_0,
    state1_carry__0_i_12_0,
    \FSM_sequential_state_reg[0]_0 ,
    state1_carry__0,
    s_axis_valid,
    s_axis_last,
    \FSM_sequential_state_reg[0]_1 ,
    \word_count_reg[31]_0 );
  output bram_done;
  output [16:0]\slv_reg6_reg[30] ;
  output [4:0]Q;
  output [3:0]\i_reg[15] ;
  output [2:0]\i_reg[22] ;
  output [5:0]DI;
  output [3:0]\i_reg[22]_0 ;
  input s00_axi_aclk;
  input [0:0]SR;
  input [30:0]state1_carry__0_i_12;
  input [7:0]S;
  input [7:0]state2_carry_i_5_0;
  input [7:0]state2_carry_i_3_0;
  input [6:0]state1_carry__0_i_12_0;
  input [1:0]\FSM_sequential_state_reg[0]_0 ;
  input [19:0]state1_carry__0;
  input s_axis_valid;
  input s_axis_last;
  input \FSM_sequential_state_reg[0]_1 ;
  input \word_count_reg[31]_0 ;

  wire [5:0]DI;
  wire \FSM_sequential_state[1]_i_1__0_n_0 ;
  wire \FSM_sequential_state[1]_i_3_n_0 ;
  wire [1:0]\FSM_sequential_state_reg[0]_0 ;
  wire \FSM_sequential_state_reg[0]_1 ;
  wire \FSM_sequential_state_reg_n_0_[1] ;
  wire [4:0]Q;
  wire [7:0]S;
  wire [0:0]SR;
  wire bram_done;
  wire done_i_1_n_0;
  wire [3:0]\i_reg[15] ;
  wire [2:0]\i_reg[22] ;
  wire [3:0]\i_reg[22]_0 ;
  wire [31:1]in8;
  wire s00_axi_aclk;
  wire s_axis_last;
  wire s_axis_valid;
  wire [16:0]\slv_reg6_reg[30] ;
  wire [1:0]state;
  wire [19:0]state1_carry__0;
  wire [30:0]state1_carry__0_i_12;
  wire [6:0]state1_carry__0_i_12_0;
  wire [23:4]state2;
  wire state2_carry__0_i_3_n_0;
  wire state2_carry__0_n_5;
  wire state2_carry__0_n_6;
  wire state2_carry__0_n_7;
  wire state2_carry_i_1_n_0;
  wire state2_carry_i_2_n_0;
  wire [7:0]state2_carry_i_3_0;
  wire state2_carry_i_3_n_0;
  wire state2_carry_i_4_n_0;
  wire [7:0]state2_carry_i_5_0;
  wire state2_carry_i_5_n_0;
  wire state2_carry_i_6_n_0;
  wire state2_carry_i_7_n_0;
  wire state2_carry_i_8_n_0;
  wire state2_carry_n_0;
  wire state2_carry_n_1;
  wire state2_carry_n_2;
  wire state2_carry_n_3;
  wire state2_carry_n_4;
  wire state2_carry_n_5;
  wire state2_carry_n_6;
  wire state2_carry_n_7;
  wire state3_carry__0_n_0;
  wire state3_carry__0_n_1;
  wire state3_carry__0_n_2;
  wire state3_carry__0_n_3;
  wire state3_carry__0_n_4;
  wire state3_carry__0_n_5;
  wire state3_carry__0_n_6;
  wire state3_carry__0_n_7;
  wire state3_carry__1_n_0;
  wire state3_carry__1_n_1;
  wire state3_carry__1_n_2;
  wire state3_carry__1_n_3;
  wire state3_carry__1_n_4;
  wire state3_carry__1_n_5;
  wire state3_carry__1_n_6;
  wire state3_carry__1_n_7;
  wire state3_carry__2_n_2;
  wire state3_carry__2_n_3;
  wire state3_carry__2_n_4;
  wire state3_carry__2_n_5;
  wire state3_carry__2_n_6;
  wire state3_carry__2_n_7;
  wire state3_carry_n_0;
  wire state3_carry_n_1;
  wire state3_carry_n_2;
  wire state3_carry_n_3;
  wire state3_carry_n_4;
  wire state3_carry_n_5;
  wire state3_carry_n_6;
  wire state3_carry_n_7;
  wire [0:0]state__0;
  wire [31:0]word_count;
  wire word_count0_carry__0_n_0;
  wire word_count0_carry__0_n_1;
  wire word_count0_carry__0_n_2;
  wire word_count0_carry__0_n_3;
  wire word_count0_carry__0_n_4;
  wire word_count0_carry__0_n_5;
  wire word_count0_carry__0_n_6;
  wire word_count0_carry__0_n_7;
  wire word_count0_carry__1_n_0;
  wire word_count0_carry__1_n_1;
  wire word_count0_carry__1_n_2;
  wire word_count0_carry__1_n_3;
  wire word_count0_carry__1_n_4;
  wire word_count0_carry__1_n_5;
  wire word_count0_carry__1_n_6;
  wire word_count0_carry__1_n_7;
  wire word_count0_carry__2_n_2;
  wire word_count0_carry__2_n_3;
  wire word_count0_carry__2_n_4;
  wire word_count0_carry__2_n_5;
  wire word_count0_carry__2_n_6;
  wire word_count0_carry__2_n_7;
  wire word_count0_carry_n_0;
  wire word_count0_carry_n_1;
  wire word_count0_carry_n_2;
  wire word_count0_carry_n_3;
  wire word_count0_carry_n_4;
  wire word_count0_carry_n_5;
  wire word_count0_carry_n_6;
  wire word_count0_carry_n_7;
  wire \word_count[31]_i_1_n_0 ;
  wire \word_count_reg[31]_0 ;
  wire \word_count_reg_n_0_[0] ;
  wire \word_count_reg_n_0_[10] ;
  wire \word_count_reg_n_0_[11] ;
  wire \word_count_reg_n_0_[12] ;
  wire \word_count_reg_n_0_[13] ;
  wire \word_count_reg_n_0_[14] ;
  wire \word_count_reg_n_0_[15] ;
  wire \word_count_reg_n_0_[16] ;
  wire \word_count_reg_n_0_[17] ;
  wire \word_count_reg_n_0_[18] ;
  wire \word_count_reg_n_0_[19] ;
  wire \word_count_reg_n_0_[1] ;
  wire \word_count_reg_n_0_[20] ;
  wire \word_count_reg_n_0_[21] ;
  wire \word_count_reg_n_0_[22] ;
  wire \word_count_reg_n_0_[23] ;
  wire \word_count_reg_n_0_[24] ;
  wire \word_count_reg_n_0_[25] ;
  wire \word_count_reg_n_0_[26] ;
  wire \word_count_reg_n_0_[2] ;
  wire \word_count_reg_n_0_[3] ;
  wire \word_count_reg_n_0_[4] ;
  wire \word_count_reg_n_0_[5] ;
  wire \word_count_reg_n_0_[6] ;
  wire \word_count_reg_n_0_[7] ;
  wire \word_count_reg_n_0_[8] ;
  wire \word_count_reg_n_0_[9] ;
  wire [7:0]NLW_state2_carry_O_UNCONNECTED;
  wire [7:3]NLW_state2_carry__0_CO_UNCONNECTED;
  wire [7:0]NLW_state2_carry__0_O_UNCONNECTED;
  wire [7:6]NLW_state3_carry__2_CO_UNCONNECTED;
  wire [7:7]NLW_state3_carry__2_O_UNCONNECTED;
  wire [7:6]NLW_word_count0_carry__2_CO_UNCONNECTED;
  wire [7:7]NLW_word_count0_carry__2_O_UNCONNECTED;

  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h5E)) 
    \FSM_sequential_state[0]_i_1__0 
       (.I0(state__0),
        .I1(\FSM_sequential_state_reg[0]_1 ),
        .I2(\FSM_sequential_state_reg_n_0_[1] ),
        .O(state[0]));
  LUT6 #(
    .INIT(64'hFFA8FFFFFFA80000)) 
    \FSM_sequential_state[1]_i_1__0 
       (.I0(s_axis_valid),
        .I1(s_axis_last),
        .I2(state2_carry__0_n_5),
        .I3(\FSM_sequential_state_reg_n_0_[1] ),
        .I4(state__0),
        .I5(\FSM_sequential_state[1]_i_3_n_0 ),
        .O(\FSM_sequential_state[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h67)) 
    \FSM_sequential_state[1]_i_2 
       (.I0(state__0),
        .I1(\FSM_sequential_state_reg_n_0_[1] ),
        .I2(\FSM_sequential_state_reg[0]_1 ),
        .O(state[1]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h0E)) 
    \FSM_sequential_state[1]_i_3 
       (.I0(\word_count_reg[31]_0 ),
        .I1(\FSM_sequential_state_reg[0]_1 ),
        .I2(\FSM_sequential_state_reg_n_0_[1] ),
        .O(\FSM_sequential_state[1]_i_3_n_0 ));
  (* FSM_ENCODED_STATES = "IDLE:00,READ_STREAM:10,WRITE_STREAM:01,DONE:11" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state[1]_i_1__0_n_0 ),
        .CLR(SR),
        .D(state[0]),
        .Q(state__0));
  (* FSM_ENCODED_STATES = "IDLE:00,READ_STREAM:10,WRITE_STREAM:01,DONE:11" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state[1]_i_1__0_n_0 ),
        .CLR(SR),
        .D(state[1]),
        .Q(\FSM_sequential_state_reg_n_0_[1] ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    done_i_1
       (.I0(\FSM_sequential_state_reg_n_0_[1] ),
        .I1(state__0),
        .O(done_i_1_n_0));
  FDCE done_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .CLR(SR),
        .D(done_i_1_n_0),
        .Q(bram_done));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry__0_i_13
       (.I0(state2[23]),
        .I1(state2[22]),
        .I2(state1_carry__0[18]),
        .I3(state1_carry__0[19]),
        .O(\i_reg[22] [2]));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry__0_i_14
       (.I0(state2[20]),
        .I1(state2[21]),
        .I2(state1_carry__0[17]),
        .I3(state1_carry__0[16]),
        .O(\i_reg[22] [1]));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry__0_i_16
       (.I0(state2[17]),
        .I1(state2[16]),
        .I2(state1_carry__0[12]),
        .I3(state1_carry__0[13]),
        .O(\i_reg[22] [0]));
  LUT4 #(
    .INIT(16'h7510)) 
    state1_carry__0_i_5
       (.I0(state2[23]),
        .I1(state2[22]),
        .I2(state1_carry__0[18]),
        .I3(state1_carry__0[19]),
        .O(\i_reg[22]_0 [3]));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry__0_i_6
       (.I0(state2[20]),
        .I1(state1_carry__0[16]),
        .I2(state1_carry__0[17]),
        .I3(state2[21]),
        .O(\i_reg[22]_0 [2]));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry__0_i_7
       (.I0(\slv_reg6_reg[30] [7]),
        .I1(state1_carry__0[14]),
        .I2(state1_carry__0[15]),
        .I3(\slv_reg6_reg[30] [8]),
        .O(\i_reg[22]_0 [1]));
  LUT4 #(
    .INIT(16'h7510)) 
    state1_carry__0_i_8
       (.I0(state2[17]),
        .I1(state2[16]),
        .I2(state1_carry__0[12]),
        .I3(state1_carry__0[13]),
        .O(\i_reg[22]_0 [0]));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry_i_1
       (.I0(state2[14]),
        .I1(state1_carry__0[10]),
        .I2(state1_carry__0[11]),
        .I3(state2[15]),
        .O(DI[5]));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry_i_11
       (.I0(state2[11]),
        .I1(state2[10]),
        .I2(state1_carry__0[6]),
        .I3(state1_carry__0[7]),
        .O(\i_reg[15] [2]));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry_i_12
       (.I0(state2[8]),
        .I1(state2[9]),
        .I2(state1_carry__0[5]),
        .I3(state1_carry__0[4]),
        .O(\i_reg[15] [1]));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry_i_14
       (.I0(state2[5]),
        .I1(state2[4]),
        .I2(state1_carry__0[0]),
        .I3(state1_carry__0[1]),
        .O(\i_reg[15] [0]));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry_i_2
       (.I0(\slv_reg6_reg[30] [5]),
        .I1(state1_carry__0[8]),
        .I2(state1_carry__0[9]),
        .I3(\slv_reg6_reg[30] [6]),
        .O(DI[4]));
  LUT4 #(
    .INIT(16'h7510)) 
    state1_carry_i_3
       (.I0(state2[11]),
        .I1(state2[10]),
        .I2(state1_carry__0[6]),
        .I3(state1_carry__0[7]),
        .O(DI[3]));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry_i_4
       (.I0(state2[8]),
        .I1(state1_carry__0[4]),
        .I2(state1_carry__0[5]),
        .I3(state2[9]),
        .O(DI[2]));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry_i_5
       (.I0(\slv_reg6_reg[30] [3]),
        .I1(state1_carry__0[2]),
        .I2(state1_carry__0[3]),
        .I3(\slv_reg6_reg[30] [4]),
        .O(DI[1]));
  LUT4 #(
    .INIT(16'h7510)) 
    state1_carry_i_6
       (.I0(state2[5]),
        .I1(state2[4]),
        .I2(state1_carry__0[0]),
        .I3(state1_carry__0[1]),
        .O(DI[0]));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry_i_9
       (.I0(state2[14]),
        .I1(state2[15]),
        .I2(state1_carry__0[11]),
        .I3(state1_carry__0[10]),
        .O(\i_reg[15] [3]));
  CARRY8 state2_carry
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({state2_carry_n_0,state2_carry_n_1,state2_carry_n_2,state2_carry_n_3,state2_carry_n_4,state2_carry_n_5,state2_carry_n_6,state2_carry_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_state2_carry_O_UNCONNECTED[7:0]),
        .S({state2_carry_i_1_n_0,state2_carry_i_2_n_0,state2_carry_i_3_n_0,state2_carry_i_4_n_0,state2_carry_i_5_n_0,state2_carry_i_6_n_0,state2_carry_i_7_n_0,state2_carry_i_8_n_0}));
  CARRY8 state2_carry__0
       (.CI(state2_carry_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_state2_carry__0_CO_UNCONNECTED[7:3],state2_carry__0_n_5,state2_carry__0_n_6,state2_carry__0_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(NLW_state2_carry__0_O_UNCONNECTED[7:0]),
        .S({1'b0,1'b0,1'b0,1'b0,1'b0,\FSM_sequential_state_reg[0]_0 ,state2_carry__0_i_3_n_0}));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry__0_i_3
       (.I0(\slv_reg6_reg[30] [11]),
        .I1(\slv_reg6_reg[30] [10]),
        .I2(\word_count_reg_n_0_[24] ),
        .I3(\slv_reg6_reg[30] [9]),
        .I4(\word_count_reg_n_0_[25] ),
        .I5(\word_count_reg_n_0_[26] ),
        .O(state2_carry__0_i_3_n_0));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry_i_1
       (.I0(state2[23]),
        .I1(state2[22]),
        .I2(state2[21]),
        .I3(\word_count_reg_n_0_[21] ),
        .I4(\word_count_reg_n_0_[22] ),
        .I5(\word_count_reg_n_0_[23] ),
        .O(state2_carry_i_1_n_0));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry_i_2
       (.I0(state2[20]),
        .I1(\slv_reg6_reg[30] [8]),
        .I2(\word_count_reg_n_0_[18] ),
        .I3(\slv_reg6_reg[30] [7]),
        .I4(\word_count_reg_n_0_[19] ),
        .I5(\word_count_reg_n_0_[20] ),
        .O(state2_carry_i_2_n_0));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry_i_3
       (.I0(state2[17]),
        .I1(state2[16]),
        .I2(state2[15]),
        .I3(\word_count_reg_n_0_[15] ),
        .I4(\word_count_reg_n_0_[16] ),
        .I5(\word_count_reg_n_0_[17] ),
        .O(state2_carry_i_3_n_0));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry_i_4
       (.I0(state2[14]),
        .I1(\slv_reg6_reg[30] [6]),
        .I2(\word_count_reg_n_0_[12] ),
        .I3(\slv_reg6_reg[30] [5]),
        .I4(\word_count_reg_n_0_[13] ),
        .I5(\word_count_reg_n_0_[14] ),
        .O(state2_carry_i_4_n_0));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry_i_5
       (.I0(state2[11]),
        .I1(state2[10]),
        .I2(state2[9]),
        .I3(\word_count_reg_n_0_[9] ),
        .I4(\word_count_reg_n_0_[10] ),
        .I5(\word_count_reg_n_0_[11] ),
        .O(state2_carry_i_5_n_0));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry_i_6
       (.I0(state2[8]),
        .I1(\slv_reg6_reg[30] [4]),
        .I2(\word_count_reg_n_0_[6] ),
        .I3(\slv_reg6_reg[30] [3]),
        .I4(\word_count_reg_n_0_[7] ),
        .I5(\word_count_reg_n_0_[8] ),
        .O(state2_carry_i_6_n_0));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry_i_7
       (.I0(state2[5]),
        .I1(state2[4]),
        .I2(\slv_reg6_reg[30] [2]),
        .I3(\word_count_reg_n_0_[3] ),
        .I4(\word_count_reg_n_0_[4] ),
        .I5(\word_count_reg_n_0_[5] ),
        .O(state2_carry_i_7_n_0));
  LUT6 #(
    .INIT(64'h4004100180082002)) 
    state2_carry_i_8
       (.I0(\word_count_reg_n_0_[0] ),
        .I1(\slv_reg6_reg[30] [1]),
        .I2(\word_count_reg_n_0_[1] ),
        .I3(\slv_reg6_reg[30] [0]),
        .I4(\word_count_reg_n_0_[2] ),
        .I5(state1_carry__0_i_12[0]),
        .O(state2_carry_i_8_n_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 state3_carry
       (.CI(state1_carry__0_i_12[0]),
        .CI_TOP(1'b0),
        .CO({state3_carry_n_0,state3_carry_n_1,state3_carry_n_2,state3_carry_n_3,state3_carry_n_4,state3_carry_n_5,state3_carry_n_6,state3_carry_n_7}),
        .DI(state1_carry__0_i_12[8:1]),
        .O({state2[8],\slv_reg6_reg[30] [4:3],state2[5:4],\slv_reg6_reg[30] [2:0]}),
        .S(S));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 state3_carry__0
       (.CI(state3_carry_n_0),
        .CI_TOP(1'b0),
        .CO({state3_carry__0_n_0,state3_carry__0_n_1,state3_carry__0_n_2,state3_carry__0_n_3,state3_carry__0_n_4,state3_carry__0_n_5,state3_carry__0_n_6,state3_carry__0_n_7}),
        .DI(state1_carry__0_i_12[16:9]),
        .O({state2[16:14],\slv_reg6_reg[30] [6:5],state2[11:9]}),
        .S(state2_carry_i_5_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 state3_carry__1
       (.CI(state3_carry__0_n_0),
        .CI_TOP(1'b0),
        .CO({state3_carry__1_n_0,state3_carry__1_n_1,state3_carry__1_n_2,state3_carry__1_n_3,state3_carry__1_n_4,state3_carry__1_n_5,state3_carry__1_n_6,state3_carry__1_n_7}),
        .DI(state1_carry__0_i_12[24:17]),
        .O({\slv_reg6_reg[30] [9],state2[23:20],\slv_reg6_reg[30] [8:7],state2[17]}),
        .S(state2_carry_i_3_0));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 state3_carry__2
       (.CI(state3_carry__1_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_state3_carry__2_CO_UNCONNECTED[7:6],state3_carry__2_n_2,state3_carry__2_n_3,state3_carry__2_n_4,state3_carry__2_n_5,state3_carry__2_n_6,state3_carry__2_n_7}),
        .DI({1'b0,1'b0,state1_carry__0_i_12[30:25]}),
        .O({NLW_state3_carry__2_O_UNCONNECTED[7],\slv_reg6_reg[30] [16:10]}),
        .S({1'b0,state1_carry__0_i_12_0}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 word_count0_carry
       (.CI(\word_count_reg_n_0_[0] ),
        .CI_TOP(1'b0),
        .CO({word_count0_carry_n_0,word_count0_carry_n_1,word_count0_carry_n_2,word_count0_carry_n_3,word_count0_carry_n_4,word_count0_carry_n_5,word_count0_carry_n_6,word_count0_carry_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(in8[8:1]),
        .S({\word_count_reg_n_0_[8] ,\word_count_reg_n_0_[7] ,\word_count_reg_n_0_[6] ,\word_count_reg_n_0_[5] ,\word_count_reg_n_0_[4] ,\word_count_reg_n_0_[3] ,\word_count_reg_n_0_[2] ,\word_count_reg_n_0_[1] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 word_count0_carry__0
       (.CI(word_count0_carry_n_0),
        .CI_TOP(1'b0),
        .CO({word_count0_carry__0_n_0,word_count0_carry__0_n_1,word_count0_carry__0_n_2,word_count0_carry__0_n_3,word_count0_carry__0_n_4,word_count0_carry__0_n_5,word_count0_carry__0_n_6,word_count0_carry__0_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(in8[16:9]),
        .S({\word_count_reg_n_0_[16] ,\word_count_reg_n_0_[15] ,\word_count_reg_n_0_[14] ,\word_count_reg_n_0_[13] ,\word_count_reg_n_0_[12] ,\word_count_reg_n_0_[11] ,\word_count_reg_n_0_[10] ,\word_count_reg_n_0_[9] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 word_count0_carry__1
       (.CI(word_count0_carry__0_n_0),
        .CI_TOP(1'b0),
        .CO({word_count0_carry__1_n_0,word_count0_carry__1_n_1,word_count0_carry__1_n_2,word_count0_carry__1_n_3,word_count0_carry__1_n_4,word_count0_carry__1_n_5,word_count0_carry__1_n_6,word_count0_carry__1_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(in8[24:17]),
        .S({\word_count_reg_n_0_[24] ,\word_count_reg_n_0_[23] ,\word_count_reg_n_0_[22] ,\word_count_reg_n_0_[21] ,\word_count_reg_n_0_[20] ,\word_count_reg_n_0_[19] ,\word_count_reg_n_0_[18] ,\word_count_reg_n_0_[17] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 word_count0_carry__2
       (.CI(word_count0_carry__1_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_word_count0_carry__2_CO_UNCONNECTED[7:6],word_count0_carry__2_n_2,word_count0_carry__2_n_3,word_count0_carry__2_n_4,word_count0_carry__2_n_5,word_count0_carry__2_n_6,word_count0_carry__2_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_word_count0_carry__2_O_UNCONNECTED[7],in8[31:25]}),
        .S({1'b0,Q,\word_count_reg_n_0_[26] ,\word_count_reg_n_0_[25] }));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \word_count[0]_i_1 
       (.I0(state__0),
        .I1(\word_count_reg_n_0_[0] ),
        .O(word_count[0]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[10]_i_1 
       (.I0(state__0),
        .I1(in8[10]),
        .O(word_count[10]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[11]_i_1 
       (.I0(state__0),
        .I1(in8[11]),
        .O(word_count[11]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[12]_i_1 
       (.I0(state__0),
        .I1(in8[12]),
        .O(word_count[12]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[13]_i_1 
       (.I0(state__0),
        .I1(in8[13]),
        .O(word_count[13]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[14]_i_1 
       (.I0(state__0),
        .I1(in8[14]),
        .O(word_count[14]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[15]_i_1 
       (.I0(state__0),
        .I1(in8[15]),
        .O(word_count[15]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[16]_i_1 
       (.I0(state__0),
        .I1(in8[16]),
        .O(word_count[16]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[17]_i_1 
       (.I0(state__0),
        .I1(in8[17]),
        .O(word_count[17]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[18]_i_1 
       (.I0(state__0),
        .I1(in8[18]),
        .O(word_count[18]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[19]_i_1 
       (.I0(state__0),
        .I1(in8[19]),
        .O(word_count[19]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[1]_i_1 
       (.I0(state__0),
        .I1(in8[1]),
        .O(word_count[1]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[20]_i_1 
       (.I0(state__0),
        .I1(in8[20]),
        .O(word_count[20]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[21]_i_1 
       (.I0(state__0),
        .I1(in8[21]),
        .O(word_count[21]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[22]_i_1 
       (.I0(state__0),
        .I1(in8[22]),
        .O(word_count[22]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[23]_i_1 
       (.I0(state__0),
        .I1(in8[23]),
        .O(word_count[23]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[24]_i_1 
       (.I0(state__0),
        .I1(in8[24]),
        .O(word_count[24]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[25]_i_1 
       (.I0(state__0),
        .I1(in8[25]),
        .O(word_count[25]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[26]_i_1 
       (.I0(state__0),
        .I1(in8[26]),
        .O(word_count[26]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[27]_i_1 
       (.I0(state__0),
        .I1(in8[27]),
        .O(word_count[27]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[28]_i_1 
       (.I0(state__0),
        .I1(in8[28]),
        .O(word_count[28]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[29]_i_1 
       (.I0(state__0),
        .I1(in8[29]),
        .O(word_count[29]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[2]_i_1 
       (.I0(state__0),
        .I1(in8[2]),
        .O(word_count[2]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[30]_i_1 
       (.I0(state__0),
        .I1(in8[30]),
        .O(word_count[30]));
  LUT5 #(
    .INIT(32'h0000BBB8)) 
    \word_count[31]_i_1 
       (.I0(s_axis_valid),
        .I1(state__0),
        .I2(\word_count_reg[31]_0 ),
        .I3(\FSM_sequential_state_reg[0]_1 ),
        .I4(\FSM_sequential_state_reg_n_0_[1] ),
        .O(\word_count[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[31]_i_2 
       (.I0(state__0),
        .I1(in8[31]),
        .O(word_count[31]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[3]_i_1 
       (.I0(state__0),
        .I1(in8[3]),
        .O(word_count[3]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[4]_i_1 
       (.I0(state__0),
        .I1(in8[4]),
        .O(word_count[4]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[5]_i_1 
       (.I0(state__0),
        .I1(in8[5]),
        .O(word_count[5]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[6]_i_1 
       (.I0(state__0),
        .I1(in8[6]),
        .O(word_count[6]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[7]_i_1 
       (.I0(state__0),
        .I1(in8[7]),
        .O(word_count[7]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[8]_i_1 
       (.I0(state__0),
        .I1(in8[8]),
        .O(word_count[8]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \word_count[9]_i_1 
       (.I0(state__0),
        .I1(in8[9]),
        .O(word_count[9]));
  FDCE \word_count_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[0]),
        .Q(\word_count_reg_n_0_[0] ));
  FDCE \word_count_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[10]),
        .Q(\word_count_reg_n_0_[10] ));
  FDCE \word_count_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[11]),
        .Q(\word_count_reg_n_0_[11] ));
  FDCE \word_count_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[12]),
        .Q(\word_count_reg_n_0_[12] ));
  FDCE \word_count_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[13]),
        .Q(\word_count_reg_n_0_[13] ));
  FDCE \word_count_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[14]),
        .Q(\word_count_reg_n_0_[14] ));
  FDCE \word_count_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[15]),
        .Q(\word_count_reg_n_0_[15] ));
  FDCE \word_count_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[16]),
        .Q(\word_count_reg_n_0_[16] ));
  FDCE \word_count_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[17]),
        .Q(\word_count_reg_n_0_[17] ));
  FDCE \word_count_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[18]),
        .Q(\word_count_reg_n_0_[18] ));
  FDCE \word_count_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[19]),
        .Q(\word_count_reg_n_0_[19] ));
  FDCE \word_count_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[1]),
        .Q(\word_count_reg_n_0_[1] ));
  FDCE \word_count_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[20]),
        .Q(\word_count_reg_n_0_[20] ));
  FDCE \word_count_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[21]),
        .Q(\word_count_reg_n_0_[21] ));
  FDCE \word_count_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[22]),
        .Q(\word_count_reg_n_0_[22] ));
  FDCE \word_count_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[23]),
        .Q(\word_count_reg_n_0_[23] ));
  FDCE \word_count_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[24]),
        .Q(\word_count_reg_n_0_[24] ));
  FDCE \word_count_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[25]),
        .Q(\word_count_reg_n_0_[25] ));
  FDCE \word_count_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[26]),
        .Q(\word_count_reg_n_0_[26] ));
  FDCE \word_count_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[27]),
        .Q(Q[0]));
  FDCE \word_count_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[28]),
        .Q(Q[1]));
  FDCE \word_count_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[29]),
        .Q(Q[2]));
  FDCE \word_count_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[2]),
        .Q(\word_count_reg_n_0_[2] ));
  FDCE \word_count_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[30]),
        .Q(Q[3]));
  FDCE \word_count_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[31]),
        .Q(Q[4]));
  FDCE \word_count_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[3]),
        .Q(\word_count_reg_n_0_[3] ));
  FDCE \word_count_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[4]),
        .Q(\word_count_reg_n_0_[4] ));
  FDCE \word_count_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[5]),
        .Q(\word_count_reg_n_0_[5] ));
  FDCE \word_count_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[6]),
        .Q(\word_count_reg_n_0_[6] ));
  FDCE \word_count_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[7]),
        .Q(\word_count_reg_n_0_[7] ));
  FDCE \word_count_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[8]),
        .Q(\word_count_reg_n_0_[8] ));
  FDCE \word_count_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\word_count[31]_i_1_n_0 ),
        .CLR(SR),
        .D(word_count[9]),
        .Q(\word_count_reg_n_0_[9] ));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_compute_top
   (compute_done,
    Q,
    s00_axi_aclk,
    SR,
    DI,
    state1_carry__0_0,
    \FSM_sequential_state_reg[3]_0 ,
    S,
    state1_carry_0,
    state1_carry__0_1,
    \FSM_sequential_state_reg[0]_0 );
  output compute_done;
  output [25:0]Q;
  input s00_axi_aclk;
  input [0:0]SR;
  input [5:0]DI;
  input [3:0]state1_carry__0_0;
  input [6:0]\FSM_sequential_state_reg[3]_0 ;
  input [4:0]S;
  input [0:0]state1_carry_0;
  input [12:0]state1_carry__0_1;
  input \FSM_sequential_state_reg[0]_0 ;

  wire [5:0]DI;
  wire \FSM_sequential_state[3]_i_1_n_0 ;
  wire \FSM_sequential_state_reg[0]_0 ;
  wire [6:0]\FSM_sequential_state_reg[3]_0 ;
  wire [25:0]Q;
  wire [4:0]S;
  wire [0:0]SR;
  wire compute_done;
  wire done_i_1__0_n_0;
  wire [31:0]i;
  wire i0_carry__0_n_0;
  wire i0_carry__0_n_1;
  wire i0_carry__0_n_2;
  wire i0_carry__0_n_3;
  wire i0_carry__0_n_4;
  wire i0_carry__0_n_5;
  wire i0_carry__0_n_6;
  wire i0_carry__0_n_7;
  wire i0_carry__1_n_0;
  wire i0_carry__1_n_1;
  wire i0_carry__1_n_2;
  wire i0_carry__1_n_3;
  wire i0_carry__1_n_4;
  wire i0_carry__1_n_5;
  wire i0_carry__1_n_6;
  wire i0_carry__1_n_7;
  wire i0_carry__2_n_2;
  wire i0_carry__2_n_3;
  wire i0_carry__2_n_4;
  wire i0_carry__2_n_5;
  wire i0_carry__2_n_6;
  wire i0_carry__2_n_7;
  wire i0_carry_n_0;
  wire i0_carry_n_1;
  wire i0_carry_n_2;
  wire i0_carry_n_3;
  wire i0_carry_n_4;
  wire i0_carry_n_5;
  wire i0_carry_n_6;
  wire i0_carry_n_7;
  wire \i[31]_i_1_n_0 ;
  wire \i_reg_n_0_[0] ;
  wire \i_reg_n_0_[1] ;
  wire \i_reg_n_0_[24] ;
  wire \i_reg_n_0_[25] ;
  wire \i_reg_n_0_[2] ;
  wire \i_reg_n_0_[3] ;
  wire [31:1]in7;
  wire s00_axi_aclk;
  wire [3:0]state;
  wire [0:0]state1_carry_0;
  wire [3:0]state1_carry__0_0;
  wire [12:0]state1_carry__0_1;
  wire state1_carry__0_i_12_n_0;
  wire state1_carry__0_i_15_n_0;
  wire state1_carry__0_i_4_n_0;
  wire state1_carry__0_i_9_n_0;
  wire state1_carry__0_n_0;
  wire state1_carry__0_n_1;
  wire state1_carry__0_n_2;
  wire state1_carry__0_n_3;
  wire state1_carry__0_n_4;
  wire state1_carry__0_n_5;
  wire state1_carry__0_n_6;
  wire state1_carry__0_n_7;
  wire state1_carry_i_10_n_0;
  wire state1_carry_i_13_n_0;
  wire state1_carry_i_15_n_0;
  wire state1_carry_i_16_n_0;
  wire state1_carry_i_7_n_0;
  wire state1_carry_i_8_n_0;
  wire state1_carry_n_0;
  wire state1_carry_n_1;
  wire state1_carry_n_2;
  wire state1_carry_n_3;
  wire state1_carry_n_4;
  wire state1_carry_n_5;
  wire state1_carry_n_6;
  wire state1_carry_n_7;
  wire [3:0]state__0;
  wire [7:6]NLW_i0_carry__2_CO_UNCONNECTED;
  wire [7:7]NLW_i0_carry__2_O_UNCONNECTED;
  wire [7:0]NLW_state1_carry_O_UNCONNECTED;
  wire [7:0]NLW_state1_carry__0_O_UNCONNECTED;

  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h000055D5)) 
    \FSM_sequential_state[0]_i_1__1 
       (.I0(state[0]),
        .I1(state[2]),
        .I2(state[1]),
        .I3(state1_carry__0_n_0),
        .I4(state[3]),
        .O(state__0[0]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \FSM_sequential_state[1]_i_1__1 
       (.I0(state[0]),
        .I1(state[1]),
        .I2(state[3]),
        .O(state__0[1]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT4 #(
    .INIT(16'h0078)) 
    \FSM_sequential_state[2]_i_1 
       (.I0(state[0]),
        .I1(state[1]),
        .I2(state[2]),
        .I3(state[3]),
        .O(state__0[2]));
  LUT5 #(
    .INIT(32'h5555555E)) 
    \FSM_sequential_state[3]_i_1 
       (.I0(state[3]),
        .I1(\FSM_sequential_state_reg[0]_0 ),
        .I2(state[1]),
        .I3(state[0]),
        .I4(state[2]),
        .O(\FSM_sequential_state[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h00008000)) 
    \FSM_sequential_state[3]_i_2 
       (.I0(state[2]),
        .I1(state[0]),
        .I2(state1_carry__0_n_0),
        .I3(state[1]),
        .I4(state[3]),
        .O(state__0[3]));
  (* FSM_ENCODED_STATES = "IDLE:0000,WRITE_OUT:0111,DONE:1000,READ_B_W2:0110,READ_B_W1:0101,READ_A_W2:0011,READ_B:0100,READ_A_W1:0010,READ_A:0001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state[3]_i_1_n_0 ),
        .CLR(SR),
        .D(state__0[0]),
        .Q(state[0]));
  (* FSM_ENCODED_STATES = "IDLE:0000,WRITE_OUT:0111,DONE:1000,READ_B_W2:0110,READ_B_W1:0101,READ_A_W2:0011,READ_B:0100,READ_A_W1:0010,READ_A:0001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state[3]_i_1_n_0 ),
        .CLR(SR),
        .D(state__0[1]),
        .Q(state[1]));
  (* FSM_ENCODED_STATES = "IDLE:0000,WRITE_OUT:0111,DONE:1000,READ_B_W2:0110,READ_B_W1:0101,READ_A_W2:0011,READ_B:0100,READ_A_W1:0010,READ_A:0001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state[3]_i_1_n_0 ),
        .CLR(SR),
        .D(state__0[2]),
        .Q(state[2]));
  (* FSM_ENCODED_STATES = "IDLE:0000,WRITE_OUT:0111,DONE:1000,READ_B_W2:0110,READ_B_W1:0101,READ_A_W2:0011,READ_B:0100,READ_A_W1:0010,READ_A:0001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state[3]_i_1_n_0 ),
        .CLR(SR),
        .D(state__0[3]),
        .Q(state[3]));
  LUT4 #(
    .INIT(16'h0100)) 
    done_i_1__0
       (.I0(state[2]),
        .I1(state[0]),
        .I2(state[1]),
        .I3(state[3]),
        .O(done_i_1__0_n_0));
  FDCE done_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .CLR(SR),
        .D(done_i_1__0_n_0),
        .Q(compute_done));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 i0_carry
       (.CI(\i_reg_n_0_[0] ),
        .CI_TOP(1'b0),
        .CO({i0_carry_n_0,i0_carry_n_1,i0_carry_n_2,i0_carry_n_3,i0_carry_n_4,i0_carry_n_5,i0_carry_n_6,i0_carry_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(in7[8:1]),
        .S({Q[4:0],\i_reg_n_0_[3] ,\i_reg_n_0_[2] ,\i_reg_n_0_[1] }));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 i0_carry__0
       (.CI(i0_carry_n_0),
        .CI_TOP(1'b0),
        .CO({i0_carry__0_n_0,i0_carry__0_n_1,i0_carry__0_n_2,i0_carry__0_n_3,i0_carry__0_n_4,i0_carry__0_n_5,i0_carry__0_n_6,i0_carry__0_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(in7[16:9]),
        .S(Q[12:5]));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 i0_carry__1
       (.CI(i0_carry__0_n_0),
        .CI_TOP(1'b0),
        .CO({i0_carry__1_n_0,i0_carry__1_n_1,i0_carry__1_n_2,i0_carry__1_n_3,i0_carry__1_n_4,i0_carry__1_n_5,i0_carry__1_n_6,i0_carry__1_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O(in7[24:17]),
        .S({\i_reg_n_0_[24] ,Q[19:13]}));
  (* ADDER_THRESHOLD = "35" *) 
  CARRY8 i0_carry__2
       (.CI(i0_carry__1_n_0),
        .CI_TOP(1'b0),
        .CO({NLW_i0_carry__2_CO_UNCONNECTED[7:6],i0_carry__2_n_2,i0_carry__2_n_3,i0_carry__2_n_4,i0_carry__2_n_5,i0_carry__2_n_6,i0_carry__2_n_7}),
        .DI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .O({NLW_i0_carry__2_O_UNCONNECTED[7],in7[31:25]}),
        .S({1'b0,Q[25:20],\i_reg_n_0_[25] }));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT2 #(
    .INIT(4'h4)) 
    \i[0]_i_1 
       (.I0(\i_reg_n_0_[0] ),
        .I1(state[2]),
        .O(i[0]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[10]_i_1 
       (.I0(in7[10]),
        .I1(state[2]),
        .O(i[10]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[11]_i_1 
       (.I0(in7[11]),
        .I1(state[2]),
        .O(i[11]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[12]_i_1 
       (.I0(in7[12]),
        .I1(state[2]),
        .O(i[12]));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[13]_i_1 
       (.I0(in7[13]),
        .I1(state[2]),
        .O(i[13]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[14]_i_1 
       (.I0(in7[14]),
        .I1(state[2]),
        .O(i[14]));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[15]_i_1 
       (.I0(in7[15]),
        .I1(state[2]),
        .O(i[15]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[16]_i_1 
       (.I0(in7[16]),
        .I1(state[2]),
        .O(i[16]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[17]_i_1 
       (.I0(in7[17]),
        .I1(state[2]),
        .O(i[17]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[18]_i_1 
       (.I0(in7[18]),
        .I1(state[2]),
        .O(i[18]));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[19]_i_1 
       (.I0(in7[19]),
        .I1(state[2]),
        .O(i[19]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[1]_i_1 
       (.I0(in7[1]),
        .I1(state[2]),
        .O(i[1]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[20]_i_1 
       (.I0(in7[20]),
        .I1(state[2]),
        .O(i[20]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[21]_i_1 
       (.I0(in7[21]),
        .I1(state[2]),
        .O(i[21]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[22]_i_1 
       (.I0(in7[22]),
        .I1(state[2]),
        .O(i[22]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[23]_i_1 
       (.I0(in7[23]),
        .I1(state[2]),
        .O(i[23]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[24]_i_1 
       (.I0(in7[24]),
        .I1(state[2]),
        .O(i[24]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[25]_i_1 
       (.I0(in7[25]),
        .I1(state[2]),
        .O(i[25]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[26]_i_1 
       (.I0(in7[26]),
        .I1(state[2]),
        .O(i[26]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[27]_i_1 
       (.I0(in7[27]),
        .I1(state[2]),
        .O(i[27]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[28]_i_1 
       (.I0(in7[28]),
        .I1(state[2]),
        .O(i[28]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[29]_i_1 
       (.I0(in7[29]),
        .I1(state[2]),
        .O(i[29]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[2]_i_1 
       (.I0(in7[2]),
        .I1(state[2]),
        .O(i[2]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[30]_i_1 
       (.I0(in7[30]),
        .I1(state[2]),
        .O(i[30]));
  LUT6 #(
    .INIT(64'h000000000002C002)) 
    \i[31]_i_1 
       (.I0(\FSM_sequential_state_reg[0]_0 ),
        .I1(state[0]),
        .I2(state[1]),
        .I3(state[2]),
        .I4(state1_carry__0_n_0),
        .I5(state[3]),
        .O(\i[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[31]_i_2 
       (.I0(in7[31]),
        .I1(state[2]),
        .O(i[31]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[3]_i_1 
       (.I0(in7[3]),
        .I1(state[2]),
        .O(i[3]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[4]_i_1 
       (.I0(in7[4]),
        .I1(state[2]),
        .O(i[4]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[5]_i_1 
       (.I0(in7[5]),
        .I1(state[2]),
        .O(i[5]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[6]_i_1 
       (.I0(in7[6]),
        .I1(state[2]),
        .O(i[6]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[7]_i_1 
       (.I0(in7[7]),
        .I1(state[2]),
        .O(i[7]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[8]_i_1 
       (.I0(in7[8]),
        .I1(state[2]),
        .O(i[8]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \i[9]_i_1 
       (.I0(in7[9]),
        .I1(state[2]),
        .O(i[9]));
  FDCE \i_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[0]),
        .Q(\i_reg_n_0_[0] ));
  FDCE \i_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[10]),
        .Q(Q[6]));
  FDCE \i_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[11]),
        .Q(Q[7]));
  FDCE \i_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[12]),
        .Q(Q[8]));
  FDCE \i_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[13]),
        .Q(Q[9]));
  FDCE \i_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[14]),
        .Q(Q[10]));
  FDCE \i_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[15]),
        .Q(Q[11]));
  FDCE \i_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[16]),
        .Q(Q[12]));
  FDCE \i_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[17]),
        .Q(Q[13]));
  FDCE \i_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[18]),
        .Q(Q[14]));
  FDCE \i_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[19]),
        .Q(Q[15]));
  FDCE \i_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[1]),
        .Q(\i_reg_n_0_[1] ));
  FDCE \i_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[20]),
        .Q(Q[16]));
  FDCE \i_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[21]),
        .Q(Q[17]));
  FDCE \i_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[22]),
        .Q(Q[18]));
  FDCE \i_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[23]),
        .Q(Q[19]));
  FDCE \i_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[24]),
        .Q(\i_reg_n_0_[24] ));
  FDCE \i_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[25]),
        .Q(\i_reg_n_0_[25] ));
  FDCE \i_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[26]),
        .Q(Q[20]));
  FDCE \i_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[27]),
        .Q(Q[21]));
  FDCE \i_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[28]),
        .Q(Q[22]));
  FDCE \i_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[29]),
        .Q(Q[23]));
  FDCE \i_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[2]),
        .Q(\i_reg_n_0_[2] ));
  FDCE \i_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[30]),
        .Q(Q[24]));
  FDCE \i_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[31]),
        .Q(Q[25]));
  FDCE \i_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[3]),
        .Q(\i_reg_n_0_[3] ));
  FDCE \i_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[4]),
        .Q(Q[0]));
  FDCE \i_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[5]),
        .Q(Q[1]));
  FDCE \i_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[6]),
        .Q(Q[2]));
  FDCE \i_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[7]),
        .Q(Q[3]));
  FDCE \i_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[8]),
        .Q(Q[4]));
  FDCE \i_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\i[31]_i_1_n_0 ),
        .CLR(SR),
        .D(i[9]),
        .Q(Q[5]));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY8 state1_carry
       (.CI(1'b1),
        .CI_TOP(1'b0),
        .CO({state1_carry_n_0,state1_carry_n_1,state1_carry_n_2,state1_carry_n_3,state1_carry_n_4,state1_carry_n_5,state1_carry_n_6,state1_carry_n_7}),
        .DI({DI,state1_carry_i_7_n_0,state1_carry_i_8_n_0}),
        .O(NLW_state1_carry_O_UNCONNECTED[7:0]),
        .S({state1_carry__0_0[3],state1_carry_i_10_n_0,state1_carry__0_0[2:1],state1_carry_i_13_n_0,state1_carry__0_0[0],state1_carry_i_15_n_0,state1_carry_i_16_n_0}));
  (* COMPARATOR_THRESHOLD = "11" *) 
  CARRY8 state1_carry__0
       (.CI(state1_carry_n_0),
        .CI_TOP(1'b0),
        .CO({state1_carry__0_n_0,state1_carry__0_n_1,state1_carry__0_n_2,state1_carry__0_n_3,state1_carry__0_n_4,state1_carry__0_n_5,state1_carry__0_n_6,state1_carry__0_n_7}),
        .DI({\FSM_sequential_state_reg[3]_0 [6:4],state1_carry__0_i_4_n_0,\FSM_sequential_state_reg[3]_0 [3:0]}),
        .O(NLW_state1_carry__0_O_UNCONNECTED[7:0]),
        .S({state1_carry__0_i_9_n_0,S[4:3],state1_carry__0_i_12_n_0,S[2:1],state1_carry__0_i_15_n_0,S[0]}));
  LUT4 #(
    .INIT(16'h8421)) 
    state1_carry__0_i_12
       (.I0(\i_reg_n_0_[24] ),
        .I1(state1_carry__0_1[10]),
        .I2(state1_carry__0_1[9]),
        .I3(\i_reg_n_0_[25] ),
        .O(state1_carry__0_i_12_n_0));
  LUT4 #(
    .INIT(16'h8421)) 
    state1_carry__0_i_15
       (.I0(Q[14]),
        .I1(state1_carry__0_1[8]),
        .I2(state1_carry__0_1[7]),
        .I3(Q[15]),
        .O(state1_carry__0_i_15_n_0));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry__0_i_4
       (.I0(state1_carry__0_1[9]),
        .I1(\i_reg_n_0_[24] ),
        .I2(\i_reg_n_0_[25] ),
        .I3(state1_carry__0_1[10]),
        .O(state1_carry__0_i_4_n_0));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry__0_i_9
       (.I0(Q[24]),
        .I1(state1_carry__0_1[12]),
        .I2(Q[25]),
        .I3(state1_carry__0_1[11]),
        .O(state1_carry__0_i_9_n_0));
  LUT4 #(
    .INIT(16'h8421)) 
    state1_carry_i_10
       (.I0(Q[8]),
        .I1(state1_carry__0_1[6]),
        .I2(state1_carry__0_1[5]),
        .I3(Q[9]),
        .O(state1_carry_i_10_n_0));
  LUT4 #(
    .INIT(16'h8421)) 
    state1_carry_i_13
       (.I0(Q[2]),
        .I1(state1_carry__0_1[4]),
        .I2(state1_carry__0_1[3]),
        .I3(Q[3]),
        .O(state1_carry_i_13_n_0));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry_i_15
       (.I0(\i_reg_n_0_[3] ),
        .I1(state1_carry__0_1[1]),
        .I2(\i_reg_n_0_[2] ),
        .I3(state1_carry__0_1[2]),
        .O(state1_carry_i_15_n_0));
  LUT4 #(
    .INIT(16'h4182)) 
    state1_carry_i_16
       (.I0(state1_carry_0),
        .I1(state1_carry__0_1[0]),
        .I2(\i_reg_n_0_[1] ),
        .I3(\i_reg_n_0_[0] ),
        .O(state1_carry_i_16_n_0));
  LUT4 #(
    .INIT(16'h20BA)) 
    state1_carry_i_7
       (.I0(\i_reg_n_0_[3] ),
        .I1(state1_carry__0_1[1]),
        .I2(\i_reg_n_0_[2] ),
        .I3(state1_carry__0_1[2]),
        .O(state1_carry_i_7_n_0));
  LUT4 #(
    .INIT(16'h80F8)) 
    state1_carry_i_8
       (.I0(\i_reg_n_0_[0] ),
        .I1(state1_carry_0),
        .I2(\i_reg_n_0_[1] ),
        .I3(state1_carry__0_1[0]),
        .O(state1_carry_i_8_n_0));
endmodule

(* CHECK_LICENSE_TYPE = "design_1_tpu_top_0_0,tpu_top,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "tpu_top,Vivado 2025.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (s_axis_valid,
    s_axis_data,
    s_axis_last,
    s_axis_ready,
    m_axis_valid,
    m_axis_data,
    m_axis_last,
    m_axis_ready,
    s00_axi_aclk,
    s00_axi_aresetn,
    s00_axi_awaddr,
    s00_axi_awprot,
    s00_axi_awvalid,
    s00_axi_awready,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_wvalid,
    s00_axi_wready,
    s00_axi_bresp,
    s00_axi_bvalid,
    s00_axi_bready,
    s00_axi_araddr,
    s00_axi_arprot,
    s00_axi_arvalid,
    s00_axi_arready,
    s00_axi_rdata,
    s00_axi_rresp,
    s00_axi_rvalid,
    s00_axi_rready);
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TVALID" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME s_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 99999001, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef, INSERT_VIP 0" *) input s_axis_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TDATA" *) input [31:0]s_axis_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TLAST" *) input s_axis_last;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 s_axis TREADY" *) output s_axis_ready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *) (* X_INTERFACE_MODE = "master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 99999001, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef, INSERT_VIP 0" *) output m_axis_valid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *) output [31:0]m_axis_data;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *) output m_axis_last;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *) input m_axis_ready;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI:m_axis:s_axis, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input s00_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_AXI_RST RST" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s00_axi_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 7, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 99999001, ID_WIDTH 0, ADDR_WIDTH 5, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [4:0]s00_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT" *) input [2:0]s00_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID" *) input s00_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY" *) output s00_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WDATA" *) input [31:0]s00_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB" *) input [3:0]s00_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WVALID" *) input s00_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WREADY" *) output s00_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BRESP" *) output [1:0]s00_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BVALID" *) output s00_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BREADY" *) input s00_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR" *) input [4:0]s00_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT" *) input [2:0]s00_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID" *) input s00_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY" *) output s00_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RDATA" *) output [31:0]s00_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RRESP" *) output [1:0]s00_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RVALID" *) output s00_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RREADY" *) input s00_axi_rready;

  wire \<const0> ;
  wire \<const1> ;
  wire s00_axi_aclk;
  wire [4:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arready;
  wire s00_axi_arvalid;
  wire [4:0]s00_axi_awaddr;
  wire s00_axi_awready;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wready;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire s_axis_last;
  wire s_axis_valid;

  assign m_axis_data[31] = \<const0> ;
  assign m_axis_data[30] = \<const0> ;
  assign m_axis_data[29] = \<const0> ;
  assign m_axis_data[28] = \<const0> ;
  assign m_axis_data[27] = \<const0> ;
  assign m_axis_data[26] = \<const0> ;
  assign m_axis_data[25] = \<const0> ;
  assign m_axis_data[24] = \<const0> ;
  assign m_axis_data[23] = \<const0> ;
  assign m_axis_data[22] = \<const0> ;
  assign m_axis_data[21] = \<const0> ;
  assign m_axis_data[20] = \<const0> ;
  assign m_axis_data[19] = \<const0> ;
  assign m_axis_data[18] = \<const0> ;
  assign m_axis_data[17] = \<const0> ;
  assign m_axis_data[16] = \<const0> ;
  assign m_axis_data[15] = \<const0> ;
  assign m_axis_data[14] = \<const0> ;
  assign m_axis_data[13] = \<const0> ;
  assign m_axis_data[12] = \<const0> ;
  assign m_axis_data[11] = \<const0> ;
  assign m_axis_data[10] = \<const0> ;
  assign m_axis_data[9] = \<const0> ;
  assign m_axis_data[8] = \<const0> ;
  assign m_axis_data[7] = \<const0> ;
  assign m_axis_data[6] = \<const0> ;
  assign m_axis_data[5] = \<const0> ;
  assign m_axis_data[4] = \<const0> ;
  assign m_axis_data[3] = \<const0> ;
  assign m_axis_data[2] = \<const0> ;
  assign m_axis_data[1] = \<const0> ;
  assign m_axis_data[0] = \<const0> ;
  assign m_axis_last = \<const0> ;
  assign m_axis_valid = \<const0> ;
  assign s00_axi_bresp[1] = \<const0> ;
  assign s00_axi_bresp[0] = \<const0> ;
  assign s00_axi_rresp[1] = \<const0> ;
  assign s00_axi_rresp[0] = \<const0> ;
  assign s_axis_ready = \<const1> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top inst
       (.axi_arready_reg(s00_axi_arready),
        .axi_awready_reg(s00_axi_awready),
        .axi_rvalid_reg(s00_axi_rvalid),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_araddr(s00_axi_araddr[4:2]),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr[4:2]),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wready(s00_axi_wready),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid),
        .s_axis_last(s_axis_last),
        .s_axis_valid(s_axis_valid));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top
   (axi_awready_reg,
    axi_arready_reg,
    axi_rvalid_reg,
    s00_axi_rdata,
    s00_axi_bvalid,
    s00_axi_wready,
    s00_axi_aclk,
    s00_axi_awaddr,
    s00_axi_wdata,
    s00_axi_araddr,
    s00_axi_awvalid,
    s00_axi_wvalid,
    s00_axi_wstrb,
    s00_axi_arvalid,
    s00_axi_rready,
    s00_axi_aresetn,
    s_axis_valid,
    s_axis_last,
    s00_axi_bready);
  output axi_awready_reg;
  output axi_arready_reg;
  output axi_rvalid_reg;
  output [31:0]s00_axi_rdata;
  output s00_axi_bvalid;
  output s00_axi_wready;
  input s00_axi_aclk;
  input [2:0]s00_axi_awaddr;
  input [31:0]s00_axi_wdata;
  input [2:0]s00_axi_araddr;
  input s00_axi_awvalid;
  input s00_axi_wvalid;
  input [3:0]s00_axi_wstrb;
  input s00_axi_arvalid;
  input s00_axi_rready;
  input s00_axi_aresetn;
  input s_axis_valid;
  input s_axis_last;
  input s00_axi_bready;

  wire axi_arready_reg;
  wire axi_awready_reg;
  wire axi_rvalid_reg;
  wire bram_done;
  wire compute_done;
  wire instr_ready;
  wire s00_axi_aclk;
  wire [2:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [2:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wready;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire s_axis_last;
  wire s_axis_valid;
  wire [30:0]slv_reg6;
  wire start_compute;
  wire start_compute_reg_n_0;
  wire start_read;
  wire start_read_reg_n_0;
  wire start_write;
  wire start_write_reg_n_0;
  wire [2:0]state;
  wire [31:1]state2;
  wire [2:0]state__0;
  wire stream_ready;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_10;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_11;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_113;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_114;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_12;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_13;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_14;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_15;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_16;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_48;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_49;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_50;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_51;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_52;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_53;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_54;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_55;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_56;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_57;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_58;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_59;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_60;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_61;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_62;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_63;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_64;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_65;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_66;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_67;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_68;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_69;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_70;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_71;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_72;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_73;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_74;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_75;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_76;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_77;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8;
  wire tpu_top_slave_lite_v1_0_S00_AXI_inst_n_9;
  wire u_bram_top_n_18;
  wire u_bram_top_n_19;
  wire u_bram_top_n_20;
  wire u_bram_top_n_21;
  wire u_bram_top_n_22;
  wire u_bram_top_n_23;
  wire u_bram_top_n_24;
  wire u_bram_top_n_25;
  wire u_bram_top_n_26;
  wire u_bram_top_n_27;
  wire u_bram_top_n_28;
  wire u_bram_top_n_29;
  wire u_bram_top_n_30;
  wire u_bram_top_n_31;
  wire u_bram_top_n_32;
  wire u_bram_top_n_33;
  wire u_bram_top_n_34;
  wire u_bram_top_n_35;
  wire u_bram_top_n_36;
  wire u_bram_top_n_37;
  wire u_bram_top_n_38;
  wire u_bram_top_n_39;
  wire u_compute_top_n_1;
  wire u_compute_top_n_10;
  wire u_compute_top_n_11;
  wire u_compute_top_n_12;
  wire u_compute_top_n_13;
  wire u_compute_top_n_14;
  wire u_compute_top_n_15;
  wire u_compute_top_n_16;
  wire u_compute_top_n_17;
  wire u_compute_top_n_18;
  wire u_compute_top_n_19;
  wire u_compute_top_n_2;
  wire u_compute_top_n_20;
  wire u_compute_top_n_21;
  wire u_compute_top_n_22;
  wire u_compute_top_n_23;
  wire u_compute_top_n_24;
  wire u_compute_top_n_25;
  wire u_compute_top_n_26;
  wire u_compute_top_n_3;
  wire u_compute_top_n_4;
  wire u_compute_top_n_5;
  wire u_compute_top_n_6;
  wire u_compute_top_n_7;
  wire u_compute_top_n_8;
  wire u_compute_top_n_9;

  LUT3 #(
    .INIT(8'h0E)) 
    \FSM_sequential_state[2]_i_2 
       (.I0(state[1]),
        .I1(state[0]),
        .I2(state[2]),
        .O(state__0[2]));
  (* FSM_ENCODED_STATES = "IDLE:000,WAIT_DONE:100,EXEC_COMPUTE:011,EXEC_READ:010,EXEC_WRITE:001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[0] 
       (.C(s00_axi_aclk),
        .CE(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8),
        .CLR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .D(state__0[0]),
        .Q(state[0]));
  (* FSM_ENCODED_STATES = "IDLE:000,WAIT_DONE:100,EXEC_COMPUTE:011,EXEC_READ:010,EXEC_WRITE:001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[1] 
       (.C(s00_axi_aclk),
        .CE(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8),
        .CLR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .D(state__0[1]),
        .Q(state[1]));
  (* FSM_ENCODED_STATES = "IDLE:000,WAIT_DONE:100,EXEC_COMPUTE:011,EXEC_READ:010,EXEC_WRITE:001" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[2] 
       (.C(s00_axi_aclk),
        .CE(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8),
        .CLR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .D(state__0[2]),
        .Q(state[2]));
  FDPE instr_ready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_113),
        .PRE(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .Q(instr_ready));
  FDCE start_compute_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .CLR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .D(start_compute),
        .Q(start_compute_reg_n_0));
  FDCE start_read_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .CLR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .D(start_read),
        .Q(start_read_reg_n_0));
  FDCE start_write_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .CLR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .D(start_write),
        .Q(start_write_reg_n_0));
  FDPE stream_ready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_114),
        .PRE(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .Q(stream_ready));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top_slave_lite_v1_0_S00_AXI tpu_top_slave_lite_v1_0_S00_AXI_inst
       (.D(state__0[1:0]),
        .DI({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_75,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_76,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_77}),
        .E(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8),
        .\FSM_sequential_state_reg[2] (tpu_top_slave_lite_v1_0_S00_AXI_inst_n_113),
        .O(state2[31:26]),
        .Q(state),
        .S({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_9,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_10,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_11,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_12,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_13,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_14,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_15,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_16}),
        .SR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .axi_arready_reg_0(axi_arready_reg),
        .axi_awready_reg_0(axi_awready_reg),
        .axi_rvalid_reg_0(axi_rvalid_reg),
        .bram_done(bram_done),
        .compute_done(compute_done),
        .\i_reg[28] ({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_73,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_74}),
        .instr_ready(instr_ready),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_araddr(s00_axi_araddr),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wready(s00_axi_wready),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid),
        .\slv_reg0_reg[1]_0 (tpu_top_slave_lite_v1_0_S00_AXI_inst_n_114),
        .\slv_reg6_reg[16]_0 ({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_48,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_49,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_50,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_51,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_52,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_53,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_54,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_55}),
        .\slv_reg6_reg[24]_0 ({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_56,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_57,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_58,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_59,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_60,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_61,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_62,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_63}),
        .\slv_reg6_reg[30]_0 (slv_reg6),
        .\slv_reg6_reg[31]_0 ({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_64,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_65,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_66,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_67,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_68,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_69,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_70}),
        .start_compute(start_compute),
        .start_read(start_read),
        .start_write(start_write),
        .state1_carry__0({u_compute_top_n_1,u_compute_top_n_2,u_compute_top_n_3,u_compute_top_n_4,u_compute_top_n_5,u_compute_top_n_6}),
        .state2_carry__0({u_bram_top_n_18,u_bram_top_n_19,u_bram_top_n_20,u_bram_top_n_21,u_bram_top_n_22}),
        .stream_ready(stream_ready),
        .\word_count_reg[31] ({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_71,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_72}));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bram_top u_bram_top
       (.DI({u_bram_top_n_30,u_bram_top_n_31,u_bram_top_n_32,u_bram_top_n_33,u_bram_top_n_34,u_bram_top_n_35}),
        .\FSM_sequential_state_reg[0]_0 ({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_71,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_72}),
        .\FSM_sequential_state_reg[0]_1 (start_write_reg_n_0),
        .Q({u_bram_top_n_18,u_bram_top_n_19,u_bram_top_n_20,u_bram_top_n_21,u_bram_top_n_22}),
        .S({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_9,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_10,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_11,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_12,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_13,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_14,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_15,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_16}),
        .SR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .bram_done(bram_done),
        .\i_reg[15] ({u_bram_top_n_23,u_bram_top_n_24,u_bram_top_n_25,u_bram_top_n_26}),
        .\i_reg[22] ({u_bram_top_n_27,u_bram_top_n_28,u_bram_top_n_29}),
        .\i_reg[22]_0 ({u_bram_top_n_36,u_bram_top_n_37,u_bram_top_n_38,u_bram_top_n_39}),
        .s00_axi_aclk(s00_axi_aclk),
        .s_axis_last(s_axis_last),
        .s_axis_valid(s_axis_valid),
        .\slv_reg6_reg[30] ({state2[31:24],state2[19:18],state2[13:12],state2[7:6],state2[3:1]}),
        .state1_carry__0({u_compute_top_n_7,u_compute_top_n_8,u_compute_top_n_9,u_compute_top_n_10,u_compute_top_n_11,u_compute_top_n_12,u_compute_top_n_13,u_compute_top_n_14,u_compute_top_n_15,u_compute_top_n_16,u_compute_top_n_17,u_compute_top_n_18,u_compute_top_n_19,u_compute_top_n_20,u_compute_top_n_21,u_compute_top_n_22,u_compute_top_n_23,u_compute_top_n_24,u_compute_top_n_25,u_compute_top_n_26}),
        .state1_carry__0_i_12(slv_reg6),
        .state1_carry__0_i_12_0({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_64,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_65,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_66,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_67,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_68,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_69,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_70}),
        .state2_carry_i_3_0({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_56,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_57,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_58,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_59,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_60,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_61,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_62,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_63}),
        .state2_carry_i_5_0({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_48,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_49,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_50,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_51,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_52,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_53,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_54,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_55}),
        .\word_count_reg[31]_0 (start_read_reg_n_0));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_compute_top u_compute_top
       (.DI({u_bram_top_n_30,u_bram_top_n_31,u_bram_top_n_32,u_bram_top_n_33,u_bram_top_n_34,u_bram_top_n_35}),
        .\FSM_sequential_state_reg[0]_0 (start_compute_reg_n_0),
        .\FSM_sequential_state_reg[3]_0 ({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_75,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_76,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_77,u_bram_top_n_36,u_bram_top_n_37,u_bram_top_n_38,u_bram_top_n_39}),
        .Q({u_compute_top_n_1,u_compute_top_n_2,u_compute_top_n_3,u_compute_top_n_4,u_compute_top_n_5,u_compute_top_n_6,u_compute_top_n_7,u_compute_top_n_8,u_compute_top_n_9,u_compute_top_n_10,u_compute_top_n_11,u_compute_top_n_12,u_compute_top_n_13,u_compute_top_n_14,u_compute_top_n_15,u_compute_top_n_16,u_compute_top_n_17,u_compute_top_n_18,u_compute_top_n_19,u_compute_top_n_20,u_compute_top_n_21,u_compute_top_n_22,u_compute_top_n_23,u_compute_top_n_24,u_compute_top_n_25,u_compute_top_n_26}),
        .S({tpu_top_slave_lite_v1_0_S00_AXI_inst_n_73,tpu_top_slave_lite_v1_0_S00_AXI_inst_n_74,u_bram_top_n_27,u_bram_top_n_28,u_bram_top_n_29}),
        .SR(tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0),
        .compute_done(compute_done),
        .s00_axi_aclk(s00_axi_aclk),
        .state1_carry_0(slv_reg6[0]),
        .state1_carry__0_0({u_bram_top_n_23,u_bram_top_n_24,u_bram_top_n_25,u_bram_top_n_26}),
        .state1_carry__0_1({state2[31:30],state2[25:24],state2[19:18],state2[13:12],state2[7:6],state2[3:1]}));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top_slave_lite_v1_0_S00_AXI
   (SR,
    axi_awready_reg_0,
    s00_axi_bvalid,
    s00_axi_wready,
    axi_rvalid_reg_0,
    axi_arready_reg_0,
    D,
    E,
    S,
    \slv_reg6_reg[30]_0 ,
    \slv_reg6_reg[16]_0 ,
    \slv_reg6_reg[24]_0 ,
    \slv_reg6_reg[31]_0 ,
    \word_count_reg[31] ,
    \i_reg[28] ,
    DI,
    start_compute,
    start_read,
    start_write,
    s00_axi_rdata,
    \FSM_sequential_state_reg[2] ,
    \slv_reg0_reg[1]_0 ,
    instr_ready,
    s00_axi_aclk,
    stream_ready,
    Q,
    bram_done,
    compute_done,
    O,
    state2_carry__0,
    state1_carry__0,
    s00_axi_awvalid,
    s00_axi_wvalid,
    s00_axi_bready,
    s00_axi_arvalid,
    s00_axi_rready,
    s00_axi_aresetn,
    s00_axi_awaddr,
    s00_axi_wdata,
    s00_axi_araddr,
    s00_axi_wstrb);
  output [0:0]SR;
  output axi_awready_reg_0;
  output s00_axi_bvalid;
  output s00_axi_wready;
  output axi_rvalid_reg_0;
  output axi_arready_reg_0;
  output [1:0]D;
  output [0:0]E;
  output [7:0]S;
  output [30:0]\slv_reg6_reg[30]_0 ;
  output [7:0]\slv_reg6_reg[16]_0 ;
  output [7:0]\slv_reg6_reg[24]_0 ;
  output [6:0]\slv_reg6_reg[31]_0 ;
  output [1:0]\word_count_reg[31] ;
  output [1:0]\i_reg[28] ;
  output [2:0]DI;
  output start_compute;
  output start_read;
  output start_write;
  output [31:0]s00_axi_rdata;
  output \FSM_sequential_state_reg[2] ;
  output \slv_reg0_reg[1]_0 ;
  input instr_ready;
  input s00_axi_aclk;
  input stream_ready;
  input [2:0]Q;
  input bram_done;
  input compute_done;
  input [5:0]O;
  input [4:0]state2_carry__0;
  input [5:0]state1_carry__0;
  input s00_axi_awvalid;
  input s00_axi_wvalid;
  input s00_axi_bready;
  input s00_axi_arvalid;
  input s00_axi_rready;
  input s00_axi_aresetn;
  input [2:0]s00_axi_awaddr;
  input [31:0]s00_axi_wdata;
  input [2:0]s00_axi_araddr;
  input [3:0]s00_axi_wstrb;

  wire [1:0]D;
  wire [2:0]DI;
  wire [0:0]E;
  wire \FSM_sequential_state[2]_i_3_n_0 ;
  wire \FSM_sequential_state[2]_i_4_n_0 ;
  wire \FSM_sequential_state_read[1]_i_1_n_0 ;
  wire \FSM_sequential_state_reg[2] ;
  wire \FSM_sequential_state_write[1]_i_1_n_0 ;
  wire [5:0]O;
  wire [2:0]Q;
  wire [7:0]S;
  wire [0:0]SR;
  wire \axi_araddr[4]_i_1_n_0 ;
  wire axi_arready_i_1_n_0;
  wire axi_arready_reg_0;
  wire axi_awaddr;
  wire \axi_awaddr_reg_n_0_[2] ;
  wire \axi_awaddr_reg_n_0_[3] ;
  wire \axi_awaddr_reg_n_0_[4] ;
  wire axi_awready0__0;
  wire axi_awready_i_2_n_0;
  wire axi_awready_reg_0;
  wire axi_bvalid_i_1_n_0;
  wire axi_rvalid_i_1_n_0;
  wire axi_rvalid_reg_0;
  wire axi_wready_i_1_n_0;
  wire bram_done;
  wire compute_done;
  wire [1:0]\i_reg[28] ;
  wire instr_ready;
  wire [31:7]p_1_in;
  wire s00_axi_aclk;
  wire [2:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [2:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire \s00_axi_rdata[0]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[0]_INST_0_i_2_n_0 ;
  wire \s00_axi_rdata[10]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[11]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[12]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[13]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[14]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[15]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[16]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[17]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[18]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[19]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[1]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[20]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[21]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[22]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[23]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[24]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[25]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[26]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[27]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[28]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[29]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[2]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[30]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[31]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[3]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[4]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[5]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[6]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[7]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[8]_INST_0_i_1_n_0 ;
  wire \s00_axi_rdata[9]_INST_0_i_1_n_0 ;
  wire s00_axi_rready;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wready;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire [2:0]sel0;
  wire [31:2]slv_reg0;
  wire \slv_reg0[31]_i_2_n_0 ;
  wire [1:0]slv_reg0_bus;
  wire \slv_reg0_reg[1]_0 ;
  wire [0:0]slv_reg1_reg;
  wire [0:0]slv_reg2_reg;
  wire [31:0]slv_reg3;
  wire \slv_reg3[15]_i_1_n_0 ;
  wire \slv_reg3[23]_i_1_n_0 ;
  wire \slv_reg3[31]_i_1_n_0 ;
  wire \slv_reg3[31]_i_2_n_0 ;
  wire \slv_reg3[7]_i_1_n_0 ;
  wire [31:0]slv_reg4;
  wire \slv_reg4[15]_i_1_n_0 ;
  wire \slv_reg4[23]_i_1_n_0 ;
  wire \slv_reg4[31]_i_1_n_0 ;
  wire \slv_reg4[7]_i_1_n_0 ;
  wire [31:0]slv_reg5;
  wire \slv_reg5[15]_i_1_n_0 ;
  wire \slv_reg5[23]_i_1_n_0 ;
  wire \slv_reg5[31]_i_1_n_0 ;
  wire \slv_reg5[31]_i_2_n_0 ;
  wire \slv_reg5[7]_i_1_n_0 ;
  wire [31:31]slv_reg6;
  wire \slv_reg6[15]_i_1_n_0 ;
  wire \slv_reg6[23]_i_1_n_0 ;
  wire \slv_reg6[31]_i_1_n_0 ;
  wire \slv_reg6[31]_i_2_n_0 ;
  wire \slv_reg6[7]_i_1_n_0 ;
  wire [7:0]\slv_reg6_reg[16]_0 ;
  wire [7:0]\slv_reg6_reg[24]_0 ;
  wire [30:0]\slv_reg6_reg[30]_0 ;
  wire [6:0]\slv_reg6_reg[31]_0 ;
  wire start_compute;
  wire start_read;
  wire start_write;
  wire [5:0]state1_carry__0;
  wire [4:0]state2_carry__0;
  wire [1:0]state_read;
  wire [1:0]state_read__0;
  wire [1:0]state_write;
  wire [1:0]state_write__0;
  wire stream_ready;
  wire [1:0]\word_count_reg[31] ;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000045)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(Q[0]),
        .I1(slv_reg0_bus[0]),
        .I2(slv_reg0_bus[1]),
        .I3(Q[1]),
        .I4(Q[2]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000405)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(Q[0]),
        .I1(slv_reg0_bus[1]),
        .I2(Q[1]),
        .I3(slv_reg0_bus[0]),
        .I4(Q[2]),
        .O(D[1]));
  LUT6 #(
    .INIT(64'h404040400505050A)) 
    \FSM_sequential_state[2]_i_3 
       (.I0(Q[2]),
        .I1(compute_done),
        .I2(Q[1]),
        .I3(slv_reg0_bus[0]),
        .I4(slv_reg0_bus[1]),
        .I5(Q[0]),
        .O(\FSM_sequential_state[2]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h455545554555455A)) 
    \FSM_sequential_state[2]_i_4 
       (.I0(Q[2]),
        .I1(compute_done),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(slv_reg0_bus[0]),
        .I5(slv_reg0_bus[1]),
        .O(\FSM_sequential_state[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h07070707FF0F0F0F)) 
    \FSM_sequential_state_read[0]_i_1 
       (.I0(s00_axi_arvalid),
        .I1(axi_arready_reg_0),
        .I2(state_read[1]),
        .I3(s00_axi_rready),
        .I4(axi_rvalid_reg_0),
        .I5(state_read[0]),
        .O(state_read__0[0]));
  LUT2 #(
    .INIT(4'h7)) 
    \FSM_sequential_state_read[1]_i_1 
       (.I0(state_read[0]),
        .I1(state_read[1]),
        .O(\FSM_sequential_state_read[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00800F800F800F80)) 
    \FSM_sequential_state_read[1]_i_2 
       (.I0(axi_arready_reg_0),
        .I1(s00_axi_arvalid),
        .I2(state_read[0]),
        .I3(state_read[1]),
        .I4(s00_axi_rready),
        .I5(axi_rvalid_reg_0),
        .O(state_read__0[1]));
  (* FSM_ENCODED_STATES = "Idle:00,Rdata:10,Raddr:01" *) 
  FDRE \FSM_sequential_state_read_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state_read[1]_i_1_n_0 ),
        .D(state_read__0[0]),
        .Q(state_read[0]),
        .R(SR));
  (* FSM_ENCODED_STATES = "Idle:00,Rdata:10,Raddr:01" *) 
  FDRE \FSM_sequential_state_read_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state_read[1]_i_1_n_0 ),
        .D(state_read__0[1]),
        .Q(state_read[1]),
        .R(SR));
  MUXF7 \FSM_sequential_state_reg[2]_i_1 
       (.I0(\FSM_sequential_state[2]_i_3_n_0 ),
        .I1(\FSM_sequential_state[2]_i_4_n_0 ),
        .O(E),
        .S(bram_done));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h0F07FF0F)) 
    \FSM_sequential_state_write[0]_i_1 
       (.I0(axi_awready_reg_0),
        .I1(s00_axi_awvalid),
        .I2(state_write[1]),
        .I3(s00_axi_wvalid),
        .I4(state_write[0]),
        .O(state_write__0[0]));
  LUT2 #(
    .INIT(4'h7)) 
    \FSM_sequential_state_write[1]_i_1 
       (.I0(state_write[0]),
        .I1(state_write[1]),
        .O(\FSM_sequential_state_write[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'h00000F80)) 
    \FSM_sequential_state_write[1]_i_2 
       (.I0(s00_axi_awvalid),
        .I1(axi_awready_reg_0),
        .I2(state_write[0]),
        .I3(state_write[1]),
        .I4(s00_axi_wvalid),
        .O(state_write__0[1]));
  (* FSM_ENCODED_STATES = "Idle:00,Wdata:10,Waddr:01" *) 
  FDRE \FSM_sequential_state_write_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state_write[1]_i_1_n_0 ),
        .D(state_write__0[0]),
        .Q(state_write[0]),
        .R(SR));
  (* FSM_ENCODED_STATES = "Idle:00,Wdata:10,Waddr:01" *) 
  FDRE \FSM_sequential_state_write_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\FSM_sequential_state_write[1]_i_1_n_0 ),
        .D(state_write__0[1]),
        .Q(state_write[1]),
        .R(SR));
  LUT5 #(
    .INIT(32'h00008000)) 
    \axi_araddr[4]_i_1 
       (.I0(s00_axi_aresetn),
        .I1(axi_arready_reg_0),
        .I2(s00_axi_arvalid),
        .I3(state_read[0]),
        .I4(state_read[1]),
        .O(\axi_araddr[4]_i_1_n_0 ));
  FDRE \axi_araddr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\axi_araddr[4]_i_1_n_0 ),
        .D(s00_axi_araddr[0]),
        .Q(sel0[0]),
        .R(1'b0));
  FDRE \axi_araddr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\axi_araddr[4]_i_1_n_0 ),
        .D(s00_axi_araddr[1]),
        .Q(sel0[1]),
        .R(1'b0));
  FDRE \axi_araddr_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\axi_araddr[4]_i_1_n_0 ),
        .D(s00_axi_araddr[2]),
        .Q(sel0[2]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hC4C4C4C4FFCFCFCF)) 
    axi_arready_i_1
       (.I0(s00_axi_arvalid),
        .I1(axi_arready_reg_0),
        .I2(state_read[1]),
        .I3(s00_axi_rready),
        .I4(axi_rvalid_reg_0),
        .I5(state_read[0]),
        .O(axi_arready_i_1_n_0));
  FDRE axi_arready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_arready_i_1_n_0),
        .Q(axi_arready_reg_0),
        .R(SR));
  LUT4 #(
    .INIT(16'h4000)) 
    \axi_awaddr[4]_i_1 
       (.I0(state_write[1]),
        .I1(state_write[0]),
        .I2(s00_axi_awvalid),
        .I3(axi_awready_reg_0),
        .O(axi_awaddr));
  FDRE \axi_awaddr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(axi_awaddr),
        .D(s00_axi_awaddr[0]),
        .Q(\axi_awaddr_reg_n_0_[2] ),
        .R(SR));
  FDRE \axi_awaddr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(axi_awaddr),
        .D(s00_axi_awaddr[1]),
        .Q(\axi_awaddr_reg_n_0_[3] ),
        .R(SR));
  FDRE \axi_awaddr_reg[4] 
       (.C(s00_axi_aclk),
        .CE(axi_awaddr),
        .D(s00_axi_awaddr[2]),
        .Q(\axi_awaddr_reg_n_0_[4] ),
        .R(SR));
  LUT1 #(
    .INIT(2'h1)) 
    axi_awready_i_1
       (.I0(s00_axi_aresetn),
        .O(SR));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hCCC4FFCF)) 
    axi_awready_i_2
       (.I0(s00_axi_awvalid),
        .I1(axi_awready_reg_0),
        .I2(state_write[1]),
        .I3(s00_axi_wvalid),
        .I4(state_write[0]),
        .O(axi_awready_i_2_n_0));
  FDRE axi_awready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_awready_i_2_n_0),
        .Q(axi_awready_reg_0),
        .R(SR));
  LUT6 #(
    .INIT(64'hFBFF3838C3FF0000)) 
    axi_bvalid_i_1
       (.I0(axi_awready0__0),
        .I1(state_write[0]),
        .I2(state_write[1]),
        .I3(s00_axi_bready),
        .I4(s00_axi_bvalid),
        .I5(s00_axi_wvalid),
        .O(axi_bvalid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    axi_bvalid_i_2
       (.I0(s00_axi_awvalid),
        .I1(axi_awready_reg_0),
        .O(axi_awready0__0));
  FDRE axi_bvalid_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_bvalid_i_1_n_0),
        .Q(s00_axi_bvalid),
        .R(SR));
  LUT6 #(
    .INIT(64'hF0FFFFFF00800080)) 
    axi_rvalid_i_1
       (.I0(axi_arready_reg_0),
        .I1(s00_axi_arvalid),
        .I2(state_read[0]),
        .I3(state_read[1]),
        .I4(s00_axi_rready),
        .I5(axi_rvalid_reg_0),
        .O(axi_rvalid_i_1_n_0));
  FDRE axi_rvalid_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_rvalid_i_1_n_0),
        .Q(axi_rvalid_reg_0),
        .R(SR));
  LUT3 #(
    .INIT(8'hF1)) 
    axi_wready_i_1
       (.I0(state_write[1]),
        .I1(state_write[0]),
        .I2(s00_axi_wready),
        .O(axi_wready_i_1_n_0));
  FDRE axi_wready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_wready_i_1_n_0),
        .Q(s00_axi_wready),
        .R(SR));
  LUT6 #(
    .INIT(64'hFFFFFFAB000000AB)) 
    instr_ready_i_1
       (.I0(Q[2]),
        .I1(slv_reg0_bus[1]),
        .I2(slv_reg0_bus[0]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(instr_ready),
        .O(\FSM_sequential_state_reg[2] ));
  MUXF7 \s00_axi_rdata[0]_INST_0 
       (.I0(\s00_axi_rdata[0]_INST_0_i_1_n_0 ),
        .I1(\s00_axi_rdata[0]_INST_0_i_2_n_0 ),
        .O(s00_axi_rdata[0]),
        .S(sel0[2]));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \s00_axi_rdata[0]_INST_0_i_1 
       (.I0(slv_reg3[0]),
        .I1(slv_reg2_reg),
        .I2(sel0[1]),
        .I3(slv_reg1_reg),
        .I4(sel0[0]),
        .I5(slv_reg0_bus[0]),
        .O(\s00_axi_rdata[0]_INST_0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[0]_INST_0_i_2 
       (.I0(\slv_reg6_reg[30]_0 [0]),
        .I1(sel0[1]),
        .I2(slv_reg5[0]),
        .I3(sel0[0]),
        .I4(slv_reg4[0]),
        .O(\s00_axi_rdata[0]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[10]_INST_0 
       (.I0(\s00_axi_rdata[10]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[10]),
        .I3(sel0[1]),
        .I4(slv_reg0[10]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[10]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[10]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [10]),
        .I1(sel0[1]),
        .I2(slv_reg5[10]),
        .I3(sel0[0]),
        .I4(slv_reg4[10]),
        .O(\s00_axi_rdata[10]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[11]_INST_0 
       (.I0(\s00_axi_rdata[11]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[11]),
        .I3(sel0[1]),
        .I4(slv_reg0[11]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[11]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[11]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [11]),
        .I1(sel0[1]),
        .I2(slv_reg5[11]),
        .I3(sel0[0]),
        .I4(slv_reg4[11]),
        .O(\s00_axi_rdata[11]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[12]_INST_0 
       (.I0(\s00_axi_rdata[12]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[12]),
        .I3(sel0[1]),
        .I4(slv_reg0[12]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[12]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[12]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [12]),
        .I1(sel0[1]),
        .I2(slv_reg5[12]),
        .I3(sel0[0]),
        .I4(slv_reg4[12]),
        .O(\s00_axi_rdata[12]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[13]_INST_0 
       (.I0(\s00_axi_rdata[13]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[13]),
        .I3(sel0[1]),
        .I4(slv_reg0[13]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[13]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[13]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [13]),
        .I1(sel0[1]),
        .I2(slv_reg5[13]),
        .I3(sel0[0]),
        .I4(slv_reg4[13]),
        .O(\s00_axi_rdata[13]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[14]_INST_0 
       (.I0(\s00_axi_rdata[14]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[14]),
        .I3(sel0[1]),
        .I4(slv_reg0[14]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[14]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[14]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [14]),
        .I1(sel0[1]),
        .I2(slv_reg5[14]),
        .I3(sel0[0]),
        .I4(slv_reg4[14]),
        .O(\s00_axi_rdata[14]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[15]_INST_0 
       (.I0(\s00_axi_rdata[15]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[15]),
        .I3(sel0[1]),
        .I4(slv_reg0[15]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[15]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[15]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [15]),
        .I1(sel0[1]),
        .I2(slv_reg5[15]),
        .I3(sel0[0]),
        .I4(slv_reg4[15]),
        .O(\s00_axi_rdata[15]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[16]_INST_0 
       (.I0(\s00_axi_rdata[16]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[16]),
        .I3(sel0[1]),
        .I4(slv_reg0[16]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[16]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[16]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [16]),
        .I1(sel0[1]),
        .I2(slv_reg5[16]),
        .I3(sel0[0]),
        .I4(slv_reg4[16]),
        .O(\s00_axi_rdata[16]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[17]_INST_0 
       (.I0(\s00_axi_rdata[17]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[17]),
        .I3(sel0[1]),
        .I4(slv_reg0[17]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[17]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[17]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [17]),
        .I1(sel0[1]),
        .I2(slv_reg5[17]),
        .I3(sel0[0]),
        .I4(slv_reg4[17]),
        .O(\s00_axi_rdata[17]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[18]_INST_0 
       (.I0(\s00_axi_rdata[18]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[18]),
        .I3(sel0[1]),
        .I4(slv_reg0[18]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[18]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[18]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [18]),
        .I1(sel0[1]),
        .I2(slv_reg5[18]),
        .I3(sel0[0]),
        .I4(slv_reg4[18]),
        .O(\s00_axi_rdata[18]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[19]_INST_0 
       (.I0(\s00_axi_rdata[19]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[19]),
        .I3(sel0[1]),
        .I4(slv_reg0[19]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[19]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[19]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [19]),
        .I1(sel0[1]),
        .I2(slv_reg5[19]),
        .I3(sel0[0]),
        .I4(slv_reg4[19]),
        .O(\s00_axi_rdata[19]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[1]_INST_0 
       (.I0(\s00_axi_rdata[1]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[1]),
        .I3(sel0[1]),
        .I4(slv_reg0_bus[1]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[1]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[1]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [1]),
        .I1(sel0[1]),
        .I2(slv_reg5[1]),
        .I3(sel0[0]),
        .I4(slv_reg4[1]),
        .O(\s00_axi_rdata[1]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[20]_INST_0 
       (.I0(\s00_axi_rdata[20]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[20]),
        .I3(sel0[1]),
        .I4(slv_reg0[20]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[20]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[20]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [20]),
        .I1(sel0[1]),
        .I2(slv_reg5[20]),
        .I3(sel0[0]),
        .I4(slv_reg4[20]),
        .O(\s00_axi_rdata[20]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[21]_INST_0 
       (.I0(\s00_axi_rdata[21]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[21]),
        .I3(sel0[1]),
        .I4(slv_reg0[21]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[21]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[21]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [21]),
        .I1(sel0[1]),
        .I2(slv_reg5[21]),
        .I3(sel0[0]),
        .I4(slv_reg4[21]),
        .O(\s00_axi_rdata[21]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[22]_INST_0 
       (.I0(\s00_axi_rdata[22]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[22]),
        .I3(sel0[1]),
        .I4(slv_reg0[22]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[22]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[22]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [22]),
        .I1(sel0[1]),
        .I2(slv_reg5[22]),
        .I3(sel0[0]),
        .I4(slv_reg4[22]),
        .O(\s00_axi_rdata[22]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[23]_INST_0 
       (.I0(\s00_axi_rdata[23]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[23]),
        .I3(sel0[1]),
        .I4(slv_reg0[23]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[23]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[23]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [23]),
        .I1(sel0[1]),
        .I2(slv_reg5[23]),
        .I3(sel0[0]),
        .I4(slv_reg4[23]),
        .O(\s00_axi_rdata[23]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[24]_INST_0 
       (.I0(\s00_axi_rdata[24]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[24]),
        .I3(sel0[1]),
        .I4(slv_reg0[24]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[24]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[24]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [24]),
        .I1(sel0[1]),
        .I2(slv_reg5[24]),
        .I3(sel0[0]),
        .I4(slv_reg4[24]),
        .O(\s00_axi_rdata[24]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[25]_INST_0 
       (.I0(\s00_axi_rdata[25]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[25]),
        .I3(sel0[1]),
        .I4(slv_reg0[25]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[25]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[25]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [25]),
        .I1(sel0[1]),
        .I2(slv_reg5[25]),
        .I3(sel0[0]),
        .I4(slv_reg4[25]),
        .O(\s00_axi_rdata[25]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[26]_INST_0 
       (.I0(\s00_axi_rdata[26]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[26]),
        .I3(sel0[1]),
        .I4(slv_reg0[26]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[26]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[26]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [26]),
        .I1(sel0[1]),
        .I2(slv_reg5[26]),
        .I3(sel0[0]),
        .I4(slv_reg4[26]),
        .O(\s00_axi_rdata[26]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[27]_INST_0 
       (.I0(\s00_axi_rdata[27]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[27]),
        .I3(sel0[1]),
        .I4(slv_reg0[27]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[27]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[27]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [27]),
        .I1(sel0[1]),
        .I2(slv_reg5[27]),
        .I3(sel0[0]),
        .I4(slv_reg4[27]),
        .O(\s00_axi_rdata[27]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[28]_INST_0 
       (.I0(\s00_axi_rdata[28]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[28]),
        .I3(sel0[1]),
        .I4(slv_reg0[28]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[28]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[28]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [28]),
        .I1(sel0[1]),
        .I2(slv_reg5[28]),
        .I3(sel0[0]),
        .I4(slv_reg4[28]),
        .O(\s00_axi_rdata[28]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[29]_INST_0 
       (.I0(\s00_axi_rdata[29]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[29]),
        .I3(sel0[1]),
        .I4(slv_reg0[29]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[29]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[29]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [29]),
        .I1(sel0[1]),
        .I2(slv_reg5[29]),
        .I3(sel0[0]),
        .I4(slv_reg4[29]),
        .O(\s00_axi_rdata[29]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[2]_INST_0 
       (.I0(\s00_axi_rdata[2]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[2]),
        .I3(sel0[1]),
        .I4(slv_reg0[2]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[2]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[2]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [2]),
        .I1(sel0[1]),
        .I2(slv_reg5[2]),
        .I3(sel0[0]),
        .I4(slv_reg4[2]),
        .O(\s00_axi_rdata[2]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[30]_INST_0 
       (.I0(\s00_axi_rdata[30]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[30]),
        .I3(sel0[1]),
        .I4(slv_reg0[30]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[30]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[30]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [30]),
        .I1(sel0[1]),
        .I2(slv_reg5[30]),
        .I3(sel0[0]),
        .I4(slv_reg4[30]),
        .O(\s00_axi_rdata[30]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[31]_INST_0 
       (.I0(\s00_axi_rdata[31]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[31]),
        .I3(sel0[1]),
        .I4(slv_reg0[31]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[31]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[31]_INST_0_i_1 
       (.I0(slv_reg6),
        .I1(sel0[1]),
        .I2(slv_reg5[31]),
        .I3(sel0[0]),
        .I4(slv_reg4[31]),
        .O(\s00_axi_rdata[31]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[3]_INST_0 
       (.I0(\s00_axi_rdata[3]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[3]),
        .I3(sel0[1]),
        .I4(slv_reg0[3]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[3]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[3]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [3]),
        .I1(sel0[1]),
        .I2(slv_reg5[3]),
        .I3(sel0[0]),
        .I4(slv_reg4[3]),
        .O(\s00_axi_rdata[3]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[4]_INST_0 
       (.I0(\s00_axi_rdata[4]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[4]),
        .I3(sel0[1]),
        .I4(slv_reg0[4]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[4]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[4]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [4]),
        .I1(sel0[1]),
        .I2(slv_reg5[4]),
        .I3(sel0[0]),
        .I4(slv_reg4[4]),
        .O(\s00_axi_rdata[4]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[5]_INST_0 
       (.I0(\s00_axi_rdata[5]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[5]),
        .I3(sel0[1]),
        .I4(slv_reg0[5]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[5]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[5]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [5]),
        .I1(sel0[1]),
        .I2(slv_reg5[5]),
        .I3(sel0[0]),
        .I4(slv_reg4[5]),
        .O(\s00_axi_rdata[5]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[6]_INST_0 
       (.I0(\s00_axi_rdata[6]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[6]),
        .I3(sel0[1]),
        .I4(slv_reg0[6]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[6]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[6]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [6]),
        .I1(sel0[1]),
        .I2(slv_reg5[6]),
        .I3(sel0[0]),
        .I4(slv_reg4[6]),
        .O(\s00_axi_rdata[6]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[7]_INST_0 
       (.I0(\s00_axi_rdata[7]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[7]),
        .I3(sel0[1]),
        .I4(slv_reg0[7]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[7]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[7]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [7]),
        .I1(sel0[1]),
        .I2(slv_reg5[7]),
        .I3(sel0[0]),
        .I4(slv_reg4[7]),
        .O(\s00_axi_rdata[7]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[8]_INST_0 
       (.I0(\s00_axi_rdata[8]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[8]),
        .I3(sel0[1]),
        .I4(slv_reg0[8]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[8]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[8]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [8]),
        .I1(sel0[1]),
        .I2(slv_reg5[8]),
        .I3(sel0[0]),
        .I4(slv_reg4[8]),
        .O(\s00_axi_rdata[8]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB888B88888BB8888)) 
    \s00_axi_rdata[9]_INST_0 
       (.I0(\s00_axi_rdata[9]_INST_0_i_1_n_0 ),
        .I1(sel0[2]),
        .I2(slv_reg3[9]),
        .I3(sel0[1]),
        .I4(slv_reg0[9]),
        .I5(sel0[0]),
        .O(s00_axi_rdata[9]));
  LUT5 #(
    .INIT(32'h30BB3088)) 
    \s00_axi_rdata[9]_INST_0_i_1 
       (.I0(\slv_reg6_reg[30]_0 [9]),
        .I1(sel0[1]),
        .I2(slv_reg5[9]),
        .I3(sel0[0]),
        .I4(slv_reg4[9]),
        .O(\s00_axi_rdata[9]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0002220200000000)) 
    \slv_reg0[15]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg0[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .I5(s00_axi_wstrb[1]),
        .O(p_1_in[15]));
  LUT6 #(
    .INIT(64'h0002220200000000)) 
    \slv_reg0[23]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg0[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .I5(s00_axi_wstrb[2]),
        .O(p_1_in[23]));
  LUT6 #(
    .INIT(64'h0002220200000000)) 
    \slv_reg0[31]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg0[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .I5(s00_axi_wstrb[3]),
        .O(p_1_in[31]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hFFFACCFA)) 
    \slv_reg0[31]_i_2 
       (.I0(\axi_awaddr_reg_n_0_[3] ),
        .I1(s00_axi_awaddr[1]),
        .I2(\axi_awaddr_reg_n_0_[2] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[0]),
        .O(\slv_reg0[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0002220200000000)) 
    \slv_reg0[7]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg0[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .I5(s00_axi_wstrb[0]),
        .O(p_1_in[7]));
  FDRE \slv_reg0_reg[0] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg0_bus[0]),
        .R(SR));
  FDRE \slv_reg0_reg[10] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg0[10]),
        .R(SR));
  FDRE \slv_reg0_reg[11] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg0[11]),
        .R(SR));
  FDRE \slv_reg0_reg[12] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg0[12]),
        .R(SR));
  FDRE \slv_reg0_reg[13] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg0[13]),
        .R(SR));
  FDRE \slv_reg0_reg[14] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg0[14]),
        .R(SR));
  FDRE \slv_reg0_reg[15] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg0[15]),
        .R(SR));
  FDRE \slv_reg0_reg[16] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg0[16]),
        .R(SR));
  FDRE \slv_reg0_reg[17] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg0[17]),
        .R(SR));
  FDRE \slv_reg0_reg[18] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg0[18]),
        .R(SR));
  FDRE \slv_reg0_reg[19] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg0[19]),
        .R(SR));
  FDRE \slv_reg0_reg[1] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg0_bus[1]),
        .R(SR));
  FDRE \slv_reg0_reg[20] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg0[20]),
        .R(SR));
  FDRE \slv_reg0_reg[21] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg0[21]),
        .R(SR));
  FDRE \slv_reg0_reg[22] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg0[22]),
        .R(SR));
  FDRE \slv_reg0_reg[23] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[23]),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg0[23]),
        .R(SR));
  FDRE \slv_reg0_reg[24] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[31]),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg0[24]),
        .R(SR));
  FDRE \slv_reg0_reg[25] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[31]),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg0[25]),
        .R(SR));
  FDRE \slv_reg0_reg[26] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[31]),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg0[26]),
        .R(SR));
  FDRE \slv_reg0_reg[27] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[31]),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg0[27]),
        .R(SR));
  FDRE \slv_reg0_reg[28] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[31]),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg0[28]),
        .R(SR));
  FDRE \slv_reg0_reg[29] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[31]),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg0[29]),
        .R(SR));
  FDRE \slv_reg0_reg[2] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg0[2]),
        .R(SR));
  FDRE \slv_reg0_reg[30] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[31]),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg0[30]),
        .R(SR));
  FDRE \slv_reg0_reg[31] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[31]),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg0[31]),
        .R(SR));
  FDRE \slv_reg0_reg[3] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg0[3]),
        .R(SR));
  FDRE \slv_reg0_reg[4] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg0[4]),
        .R(SR));
  FDRE \slv_reg0_reg[5] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg0[5]),
        .R(SR));
  FDRE \slv_reg0_reg[6] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg0[6]),
        .R(SR));
  FDRE \slv_reg0_reg[7] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[7]),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg0[7]),
        .R(SR));
  FDRE \slv_reg0_reg[8] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg0[8]),
        .R(SR));
  FDRE \slv_reg0_reg[9] 
       (.C(s00_axi_aclk),
        .CE(p_1_in[15]),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg0[9]),
        .R(SR));
  FDRE \slv_reg1_reg[0] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(instr_ready),
        .Q(slv_reg1_reg),
        .R(SR));
  FDRE \slv_reg2_reg[0] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(stream_ready),
        .Q(slv_reg2_reg),
        .R(SR));
  LUT6 #(
    .INIT(64'h2220002000000000)) 
    \slv_reg3[15]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg3[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[2] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[0]),
        .I5(s00_axi_wstrb[1]),
        .O(\slv_reg3[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2220002000000000)) 
    \slv_reg3[23]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg3[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[2] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[0]),
        .I5(s00_axi_wstrb[2]),
        .O(\slv_reg3[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2220002000000000)) 
    \slv_reg3[31]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg3[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[2] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[0]),
        .I5(s00_axi_wstrb[3]),
        .O(\slv_reg3[31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hCCAFFFAF)) 
    \slv_reg3[31]_i_2 
       (.I0(\axi_awaddr_reg_n_0_[4] ),
        .I1(s00_axi_awaddr[2]),
        .I2(\axi_awaddr_reg_n_0_[3] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[1]),
        .O(\slv_reg3[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2220002000000000)) 
    \slv_reg3[7]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg3[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[2] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[0]),
        .I5(s00_axi_wstrb[0]),
        .O(\slv_reg3[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg3[0]),
        .R(SR));
  FDRE \slv_reg3_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg3[10]),
        .R(SR));
  FDRE \slv_reg3_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg3[11]),
        .R(SR));
  FDRE \slv_reg3_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg3[12]),
        .R(SR));
  FDRE \slv_reg3_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg3[13]),
        .R(SR));
  FDRE \slv_reg3_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg3[14]),
        .R(SR));
  FDRE \slv_reg3_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg3[15]),
        .R(SR));
  FDRE \slv_reg3_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg3[16]),
        .R(SR));
  FDRE \slv_reg3_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg3[17]),
        .R(SR));
  FDRE \slv_reg3_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg3[18]),
        .R(SR));
  FDRE \slv_reg3_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg3[19]),
        .R(SR));
  FDRE \slv_reg3_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg3[1]),
        .R(SR));
  FDRE \slv_reg3_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg3[20]),
        .R(SR));
  FDRE \slv_reg3_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg3[21]),
        .R(SR));
  FDRE \slv_reg3_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg3[22]),
        .R(SR));
  FDRE \slv_reg3_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg3[23]),
        .R(SR));
  FDRE \slv_reg3_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg3[24]),
        .R(SR));
  FDRE \slv_reg3_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg3[25]),
        .R(SR));
  FDRE \slv_reg3_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg3[26]),
        .R(SR));
  FDRE \slv_reg3_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg3[27]),
        .R(SR));
  FDRE \slv_reg3_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg3[28]),
        .R(SR));
  FDRE \slv_reg3_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg3[29]),
        .R(SR));
  FDRE \slv_reg3_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg3[2]),
        .R(SR));
  FDRE \slv_reg3_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg3[30]),
        .R(SR));
  FDRE \slv_reg3_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg3[31]),
        .R(SR));
  FDRE \slv_reg3_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg3[3]),
        .R(SR));
  FDRE \slv_reg3_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg3[4]),
        .R(SR));
  FDRE \slv_reg3_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg3[5]),
        .R(SR));
  FDRE \slv_reg3_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg3[6]),
        .R(SR));
  FDRE \slv_reg3_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg3[7]),
        .R(SR));
  FDRE \slv_reg3_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg3[8]),
        .R(SR));
  FDRE \slv_reg3_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg3[9]),
        .R(SR));
  LUT6 #(
    .INIT(64'h2220002000000000)) 
    \slv_reg4[15]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg0[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .I5(s00_axi_wstrb[1]),
        .O(\slv_reg4[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2220002000000000)) 
    \slv_reg4[23]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg0[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .I5(s00_axi_wstrb[2]),
        .O(\slv_reg4[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2220002000000000)) 
    \slv_reg4[31]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg0[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .I5(s00_axi_wstrb[3]),
        .O(\slv_reg4[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2220002000000000)) 
    \slv_reg4[7]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg0[31]_i_2_n_0 ),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .I5(s00_axi_wstrb[0]),
        .O(\slv_reg4[7]_i_1_n_0 ));
  FDRE \slv_reg4_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg4[0]),
        .R(SR));
  FDRE \slv_reg4_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg4[10]),
        .R(SR));
  FDRE \slv_reg4_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg4[11]),
        .R(SR));
  FDRE \slv_reg4_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg4[12]),
        .R(SR));
  FDRE \slv_reg4_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg4[13]),
        .R(SR));
  FDRE \slv_reg4_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg4[14]),
        .R(SR));
  FDRE \slv_reg4_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg4[15]),
        .R(SR));
  FDRE \slv_reg4_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg4[16]),
        .R(SR));
  FDRE \slv_reg4_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg4[17]),
        .R(SR));
  FDRE \slv_reg4_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg4[18]),
        .R(SR));
  FDRE \slv_reg4_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg4[19]),
        .R(SR));
  FDRE \slv_reg4_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg4[1]),
        .R(SR));
  FDRE \slv_reg4_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg4[20]),
        .R(SR));
  FDRE \slv_reg4_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg4[21]),
        .R(SR));
  FDRE \slv_reg4_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg4[22]),
        .R(SR));
  FDRE \slv_reg4_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg4[23]),
        .R(SR));
  FDRE \slv_reg4_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg4[24]),
        .R(SR));
  FDRE \slv_reg4_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg4[25]),
        .R(SR));
  FDRE \slv_reg4_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg4[26]),
        .R(SR));
  FDRE \slv_reg4_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg4[27]),
        .R(SR));
  FDRE \slv_reg4_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg4[28]),
        .R(SR));
  FDRE \slv_reg4_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg4[29]),
        .R(SR));
  FDRE \slv_reg4_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg4[2]),
        .R(SR));
  FDRE \slv_reg4_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg4[30]),
        .R(SR));
  FDRE \slv_reg4_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg4[31]),
        .R(SR));
  FDRE \slv_reg4_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg4[3]),
        .R(SR));
  FDRE \slv_reg4_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg4[4]),
        .R(SR));
  FDRE \slv_reg4_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg4[5]),
        .R(SR));
  FDRE \slv_reg4_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg4[6]),
        .R(SR));
  FDRE \slv_reg4_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg4[7]),
        .R(SR));
  FDRE \slv_reg4_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg4[8]),
        .R(SR));
  FDRE \slv_reg4_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg4[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg4[9]),
        .R(SR));
  LUT6 #(
    .INIT(64'h0000000002A20000)) 
    \slv_reg5[15]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\axi_awaddr_reg_n_0_[3] ),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_awaddr[1]),
        .I4(s00_axi_wstrb[1]),
        .I5(\slv_reg5[31]_i_2_n_0 ),
        .O(\slv_reg5[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A20000)) 
    \slv_reg5[23]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\axi_awaddr_reg_n_0_[3] ),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_awaddr[1]),
        .I4(s00_axi_wstrb[2]),
        .I5(\slv_reg5[31]_i_2_n_0 ),
        .O(\slv_reg5[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A20000)) 
    \slv_reg5[31]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\axi_awaddr_reg_n_0_[3] ),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_awaddr[1]),
        .I4(s00_axi_wstrb[3]),
        .I5(\slv_reg5[31]_i_2_n_0 ),
        .O(\slv_reg5[31]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h335FFF5F)) 
    \slv_reg5[31]_i_2 
       (.I0(\axi_awaddr_reg_n_0_[2] ),
        .I1(s00_axi_awaddr[0]),
        .I2(\axi_awaddr_reg_n_0_[4] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[2]),
        .O(\slv_reg5[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h0000000002A20000)) 
    \slv_reg5[7]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\axi_awaddr_reg_n_0_[3] ),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_awaddr[1]),
        .I4(s00_axi_wstrb[0]),
        .I5(\slv_reg5[31]_i_2_n_0 ),
        .O(\slv_reg5[7]_i_1_n_0 ));
  FDRE \slv_reg5_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg5[0]),
        .R(SR));
  FDRE \slv_reg5_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg5[10]),
        .R(SR));
  FDRE \slv_reg5_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg5[11]),
        .R(SR));
  FDRE \slv_reg5_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg5[12]),
        .R(SR));
  FDRE \slv_reg5_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg5[13]),
        .R(SR));
  FDRE \slv_reg5_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg5[14]),
        .R(SR));
  FDRE \slv_reg5_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg5[15]),
        .R(SR));
  FDRE \slv_reg5_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg5[16]),
        .R(SR));
  FDRE \slv_reg5_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg5[17]),
        .R(SR));
  FDRE \slv_reg5_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg5[18]),
        .R(SR));
  FDRE \slv_reg5_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg5[19]),
        .R(SR));
  FDRE \slv_reg5_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg5[1]),
        .R(SR));
  FDRE \slv_reg5_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg5[20]),
        .R(SR));
  FDRE \slv_reg5_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg5[21]),
        .R(SR));
  FDRE \slv_reg5_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg5[22]),
        .R(SR));
  FDRE \slv_reg5_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg5[23]),
        .R(SR));
  FDRE \slv_reg5_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg5[24]),
        .R(SR));
  FDRE \slv_reg5_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg5[25]),
        .R(SR));
  FDRE \slv_reg5_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg5[26]),
        .R(SR));
  FDRE \slv_reg5_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg5[27]),
        .R(SR));
  FDRE \slv_reg5_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg5[28]),
        .R(SR));
  FDRE \slv_reg5_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg5[29]),
        .R(SR));
  FDRE \slv_reg5_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg5[2]),
        .R(SR));
  FDRE \slv_reg5_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg5[30]),
        .R(SR));
  FDRE \slv_reg5_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg5[31]),
        .R(SR));
  FDRE \slv_reg5_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg5[3]),
        .R(SR));
  FDRE \slv_reg5_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg5[4]),
        .R(SR));
  FDRE \slv_reg5_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg5[5]),
        .R(SR));
  FDRE \slv_reg5_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg5[6]),
        .R(SR));
  FDRE \slv_reg5_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg5[7]),
        .R(SR));
  FDRE \slv_reg5_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg5[8]),
        .R(SR));
  FDRE \slv_reg5_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg5[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg5[9]),
        .R(SR));
  LUT6 #(
    .INIT(64'h2020200000002000)) 
    \slv_reg6[15]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg6[31]_i_2_n_0 ),
        .I2(s00_axi_wstrb[1]),
        .I3(\axi_awaddr_reg_n_0_[4] ),
        .I4(s00_axi_awvalid),
        .I5(s00_axi_awaddr[2]),
        .O(\slv_reg6[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2020200000002000)) 
    \slv_reg6[23]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg6[31]_i_2_n_0 ),
        .I2(s00_axi_wstrb[2]),
        .I3(\axi_awaddr_reg_n_0_[4] ),
        .I4(s00_axi_awvalid),
        .I5(s00_axi_awaddr[2]),
        .O(\slv_reg6[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h2020200000002000)) 
    \slv_reg6[31]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg6[31]_i_2_n_0 ),
        .I2(s00_axi_wstrb[3]),
        .I3(\axi_awaddr_reg_n_0_[4] ),
        .I4(s00_axi_awvalid),
        .I5(s00_axi_awaddr[2]),
        .O(\slv_reg6[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hCCAFFFAF)) 
    \slv_reg6[31]_i_2 
       (.I0(\axi_awaddr_reg_n_0_[2] ),
        .I1(s00_axi_awaddr[0]),
        .I2(\axi_awaddr_reg_n_0_[3] ),
        .I3(s00_axi_awvalid),
        .I4(s00_axi_awaddr[1]),
        .O(\slv_reg6[31]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2020200000002000)) 
    \slv_reg6[7]_i_1 
       (.I0(s00_axi_wvalid),
        .I1(\slv_reg6[31]_i_2_n_0 ),
        .I2(s00_axi_wstrb[0]),
        .I3(\axi_awaddr_reg_n_0_[4] ),
        .I4(s00_axi_awvalid),
        .I5(s00_axi_awaddr[2]),
        .O(\slv_reg6[7]_i_1_n_0 ));
  FDRE \slv_reg6_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(\slv_reg6_reg[30]_0 [0]),
        .R(SR));
  FDRE \slv_reg6_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(\slv_reg6_reg[30]_0 [10]),
        .R(SR));
  FDRE \slv_reg6_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(\slv_reg6_reg[30]_0 [11]),
        .R(SR));
  FDRE \slv_reg6_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(\slv_reg6_reg[30]_0 [12]),
        .R(SR));
  FDRE \slv_reg6_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(\slv_reg6_reg[30]_0 [13]),
        .R(SR));
  FDRE \slv_reg6_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(\slv_reg6_reg[30]_0 [14]),
        .R(SR));
  FDRE \slv_reg6_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(\slv_reg6_reg[30]_0 [15]),
        .R(SR));
  FDRE \slv_reg6_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(\slv_reg6_reg[30]_0 [16]),
        .R(SR));
  FDRE \slv_reg6_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(\slv_reg6_reg[30]_0 [17]),
        .R(SR));
  FDRE \slv_reg6_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(\slv_reg6_reg[30]_0 [18]),
        .R(SR));
  FDRE \slv_reg6_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(\slv_reg6_reg[30]_0 [19]),
        .R(SR));
  FDRE \slv_reg6_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(\slv_reg6_reg[30]_0 [1]),
        .R(SR));
  FDRE \slv_reg6_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(\slv_reg6_reg[30]_0 [20]),
        .R(SR));
  FDRE \slv_reg6_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(\slv_reg6_reg[30]_0 [21]),
        .R(SR));
  FDRE \slv_reg6_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(\slv_reg6_reg[30]_0 [22]),
        .R(SR));
  FDRE \slv_reg6_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(\slv_reg6_reg[30]_0 [23]),
        .R(SR));
  FDRE \slv_reg6_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(\slv_reg6_reg[30]_0 [24]),
        .R(SR));
  FDRE \slv_reg6_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(\slv_reg6_reg[30]_0 [25]),
        .R(SR));
  FDRE \slv_reg6_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(\slv_reg6_reg[30]_0 [26]),
        .R(SR));
  FDRE \slv_reg6_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(\slv_reg6_reg[30]_0 [27]),
        .R(SR));
  FDRE \slv_reg6_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(\slv_reg6_reg[30]_0 [28]),
        .R(SR));
  FDRE \slv_reg6_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(\slv_reg6_reg[30]_0 [29]),
        .R(SR));
  FDRE \slv_reg6_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(\slv_reg6_reg[30]_0 [2]),
        .R(SR));
  FDRE \slv_reg6_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(\slv_reg6_reg[30]_0 [30]),
        .R(SR));
  FDRE \slv_reg6_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg6),
        .R(SR));
  FDRE \slv_reg6_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(\slv_reg6_reg[30]_0 [3]),
        .R(SR));
  FDRE \slv_reg6_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(\slv_reg6_reg[30]_0 [4]),
        .R(SR));
  FDRE \slv_reg6_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(\slv_reg6_reg[30]_0 [5]),
        .R(SR));
  FDRE \slv_reg6_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(\slv_reg6_reg[30]_0 [6]),
        .R(SR));
  FDRE \slv_reg6_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(\slv_reg6_reg[30]_0 [7]),
        .R(SR));
  FDRE \slv_reg6_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(\slv_reg6_reg[30]_0 [8]),
        .R(SR));
  FDRE \slv_reg6_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg6[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(\slv_reg6_reg[30]_0 [9]),
        .R(SR));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00001000)) 
    start_compute_i_1
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(slv_reg0_bus[0]),
        .I3(slv_reg0_bus[1]),
        .I4(Q[2]),
        .O(start_compute));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h00000100)) 
    start_read_i_1
       (.I0(Q[0]),
        .I1(slv_reg0_bus[0]),
        .I2(Q[1]),
        .I3(slv_reg0_bus[1]),
        .I4(Q[2]),
        .O(start_read));
  LUT5 #(
    .INIT(32'h00000010)) 
    start_write_i_1
       (.I0(Q[0]),
        .I1(Q[1]),
        .I2(slv_reg0_bus[0]),
        .I3(slv_reg0_bus[1]),
        .I4(Q[2]),
        .O(start_write));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry__0_i_1
       (.I0(O[4]),
        .I1(state1_carry__0[4]),
        .I2(state1_carry__0[5]),
        .I3(O[5]),
        .O(DI[2]));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry__0_i_10
       (.I0(O[3]),
        .I1(O[2]),
        .I2(state1_carry__0[2]),
        .I3(state1_carry__0[3]),
        .O(\i_reg[28] [1]));
  LUT4 #(
    .INIT(16'h8241)) 
    state1_carry__0_i_11
       (.I0(O[0]),
        .I1(O[1]),
        .I2(state1_carry__0[1]),
        .I3(state1_carry__0[0]),
        .O(\i_reg[28] [0]));
  LUT4 #(
    .INIT(16'h7510)) 
    state1_carry__0_i_2
       (.I0(O[3]),
        .I1(O[2]),
        .I2(state1_carry__0[2]),
        .I3(state1_carry__0[3]),
        .O(DI[1]));
  LUT4 #(
    .INIT(16'h40F4)) 
    state1_carry__0_i_3
       (.I0(O[0]),
        .I1(state1_carry__0[0]),
        .I2(state1_carry__0[1]),
        .I3(O[1]),
        .O(DI[0]));
  LUT4 #(
    .INIT(16'h8241)) 
    state2_carry__0_i_1
       (.I0(O[4]),
        .I1(state2_carry__0[4]),
        .I2(O[5]),
        .I3(state2_carry__0[3]),
        .O(\word_count_reg[31] [1]));
  LUT6 #(
    .INIT(64'h8008200240041001)) 
    state2_carry__0_i_2
       (.I0(O[3]),
        .I1(O[2]),
        .I2(O[1]),
        .I3(state2_carry__0[0]),
        .I4(state2_carry__0[1]),
        .I5(state2_carry__0[2]),
        .O(\word_count_reg[31] [0]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__0_i_1
       (.I0(\slv_reg6_reg[30]_0 [16]),
        .O(\slv_reg6_reg[16]_0 [7]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__0_i_2
       (.I0(\slv_reg6_reg[30]_0 [15]),
        .O(\slv_reg6_reg[16]_0 [6]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__0_i_3
       (.I0(\slv_reg6_reg[30]_0 [14]),
        .O(\slv_reg6_reg[16]_0 [5]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__0_i_4
       (.I0(\slv_reg6_reg[30]_0 [13]),
        .O(\slv_reg6_reg[16]_0 [4]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__0_i_5
       (.I0(\slv_reg6_reg[30]_0 [12]),
        .O(\slv_reg6_reg[16]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__0_i_6
       (.I0(\slv_reg6_reg[30]_0 [11]),
        .O(\slv_reg6_reg[16]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__0_i_7
       (.I0(\slv_reg6_reg[30]_0 [10]),
        .O(\slv_reg6_reg[16]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__0_i_8
       (.I0(\slv_reg6_reg[30]_0 [9]),
        .O(\slv_reg6_reg[16]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__1_i_1
       (.I0(\slv_reg6_reg[30]_0 [24]),
        .O(\slv_reg6_reg[24]_0 [7]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__1_i_2
       (.I0(\slv_reg6_reg[30]_0 [23]),
        .O(\slv_reg6_reg[24]_0 [6]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__1_i_3
       (.I0(\slv_reg6_reg[30]_0 [22]),
        .O(\slv_reg6_reg[24]_0 [5]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__1_i_4
       (.I0(\slv_reg6_reg[30]_0 [21]),
        .O(\slv_reg6_reg[24]_0 [4]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__1_i_5
       (.I0(\slv_reg6_reg[30]_0 [20]),
        .O(\slv_reg6_reg[24]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__1_i_6
       (.I0(\slv_reg6_reg[30]_0 [19]),
        .O(\slv_reg6_reg[24]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__1_i_7
       (.I0(\slv_reg6_reg[30]_0 [18]),
        .O(\slv_reg6_reg[24]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__1_i_8
       (.I0(\slv_reg6_reg[30]_0 [17]),
        .O(\slv_reg6_reg[24]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__2_i_1
       (.I0(slv_reg6),
        .O(\slv_reg6_reg[31]_0 [6]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__2_i_2
       (.I0(\slv_reg6_reg[30]_0 [30]),
        .O(\slv_reg6_reg[31]_0 [5]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__2_i_3
       (.I0(\slv_reg6_reg[30]_0 [29]),
        .O(\slv_reg6_reg[31]_0 [4]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__2_i_4
       (.I0(\slv_reg6_reg[30]_0 [28]),
        .O(\slv_reg6_reg[31]_0 [3]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__2_i_5
       (.I0(\slv_reg6_reg[30]_0 [27]),
        .O(\slv_reg6_reg[31]_0 [2]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__2_i_6
       (.I0(\slv_reg6_reg[30]_0 [26]),
        .O(\slv_reg6_reg[31]_0 [1]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry__2_i_7
       (.I0(\slv_reg6_reg[30]_0 [25]),
        .O(\slv_reg6_reg[31]_0 [0]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry_i_1
       (.I0(\slv_reg6_reg[30]_0 [8]),
        .O(S[7]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry_i_2
       (.I0(\slv_reg6_reg[30]_0 [7]),
        .O(S[6]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry_i_3
       (.I0(\slv_reg6_reg[30]_0 [6]),
        .O(S[5]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry_i_4
       (.I0(\slv_reg6_reg[30]_0 [5]),
        .O(S[4]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry_i_5
       (.I0(\slv_reg6_reg[30]_0 [4]),
        .O(S[3]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry_i_6
       (.I0(\slv_reg6_reg[30]_0 [3]),
        .O(S[2]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry_i_7
       (.I0(\slv_reg6_reg[30]_0 [2]),
        .O(S[1]));
  LUT1 #(
    .INIT(2'h1)) 
    state3_carry_i_8
       (.I0(\slv_reg6_reg[30]_0 [1]),
        .O(S[0]));
  LUT6 #(
    .INIT(64'hFFFFFFF700000FF6)) 
    stream_ready_i_1
       (.I0(slv_reg0_bus[1]),
        .I1(slv_reg0_bus[0]),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(Q[2]),
        .I5(stream_ready),
        .O(\slv_reg0_reg[1]_0 ));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
