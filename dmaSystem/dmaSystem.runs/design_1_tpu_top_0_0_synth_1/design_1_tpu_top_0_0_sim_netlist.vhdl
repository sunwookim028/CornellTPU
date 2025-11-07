-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
-- Date        : Fri Nov  7 16:16:47 2025
-- Host        : Mukund_laptop running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_tpu_top_0_0_sim_netlist.vhdl
-- Design      : design_1_tpu_top_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu3eg-sbva484-1-i
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bram_top is
  port (
    bram_done : out STD_LOGIC;
    \slv_reg6_reg[30]\ : out STD_LOGIC_VECTOR ( 16 downto 0 );
    Q : out STD_LOGIC_VECTOR ( 4 downto 0 );
    \i_reg[15]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \i_reg[22]\ : out STD_LOGIC_VECTOR ( 2 downto 0 );
    DI : out STD_LOGIC_VECTOR ( 5 downto 0 );
    \i_reg[22]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_aclk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    \state1_carry__0_i_12\ : in STD_LOGIC_VECTOR ( 30 downto 0 );
    S : in STD_LOGIC_VECTOR ( 7 downto 0 );
    state2_carry_i_5_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    state2_carry_i_3_0 : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \state1_carry__0_i_12_0\ : in STD_LOGIC_VECTOR ( 6 downto 0 );
    \FSM_sequential_state_reg[0]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \state1_carry__0\ : in STD_LOGIC_VECTOR ( 19 downto 0 );
    s_axis_valid : in STD_LOGIC;
    s_axis_last : in STD_LOGIC;
    \FSM_sequential_state_reg[0]_1\ : in STD_LOGIC;
    \word_count_reg[31]_0\ : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bram_top;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bram_top is
  signal \FSM_sequential_state[1]_i_1__0_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[1]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state_reg_n_0_[1]\ : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal done_i_1_n_0 : STD_LOGIC;
  signal in8 : STD_LOGIC_VECTOR ( 31 downto 1 );
  signal \^slv_reg6_reg[30]\ : STD_LOGIC_VECTOR ( 16 downto 0 );
  signal state : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal state2 : STD_LOGIC_VECTOR ( 23 downto 4 );
  signal \state2_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \state2_carry__0_n_5\ : STD_LOGIC;
  signal \state2_carry__0_n_6\ : STD_LOGIC;
  signal \state2_carry__0_n_7\ : STD_LOGIC;
  signal state2_carry_i_1_n_0 : STD_LOGIC;
  signal state2_carry_i_2_n_0 : STD_LOGIC;
  signal state2_carry_i_3_n_0 : STD_LOGIC;
  signal state2_carry_i_4_n_0 : STD_LOGIC;
  signal state2_carry_i_5_n_0 : STD_LOGIC;
  signal state2_carry_i_6_n_0 : STD_LOGIC;
  signal state2_carry_i_7_n_0 : STD_LOGIC;
  signal state2_carry_i_8_n_0 : STD_LOGIC;
  signal state2_carry_n_0 : STD_LOGIC;
  signal state2_carry_n_1 : STD_LOGIC;
  signal state2_carry_n_2 : STD_LOGIC;
  signal state2_carry_n_3 : STD_LOGIC;
  signal state2_carry_n_4 : STD_LOGIC;
  signal state2_carry_n_5 : STD_LOGIC;
  signal state2_carry_n_6 : STD_LOGIC;
  signal state2_carry_n_7 : STD_LOGIC;
  signal \state3_carry__0_n_0\ : STD_LOGIC;
  signal \state3_carry__0_n_1\ : STD_LOGIC;
  signal \state3_carry__0_n_2\ : STD_LOGIC;
  signal \state3_carry__0_n_3\ : STD_LOGIC;
  signal \state3_carry__0_n_4\ : STD_LOGIC;
  signal \state3_carry__0_n_5\ : STD_LOGIC;
  signal \state3_carry__0_n_6\ : STD_LOGIC;
  signal \state3_carry__0_n_7\ : STD_LOGIC;
  signal \state3_carry__1_n_0\ : STD_LOGIC;
  signal \state3_carry__1_n_1\ : STD_LOGIC;
  signal \state3_carry__1_n_2\ : STD_LOGIC;
  signal \state3_carry__1_n_3\ : STD_LOGIC;
  signal \state3_carry__1_n_4\ : STD_LOGIC;
  signal \state3_carry__1_n_5\ : STD_LOGIC;
  signal \state3_carry__1_n_6\ : STD_LOGIC;
  signal \state3_carry__1_n_7\ : STD_LOGIC;
  signal \state3_carry__2_n_2\ : STD_LOGIC;
  signal \state3_carry__2_n_3\ : STD_LOGIC;
  signal \state3_carry__2_n_4\ : STD_LOGIC;
  signal \state3_carry__2_n_5\ : STD_LOGIC;
  signal \state3_carry__2_n_6\ : STD_LOGIC;
  signal \state3_carry__2_n_7\ : STD_LOGIC;
  signal state3_carry_n_0 : STD_LOGIC;
  signal state3_carry_n_1 : STD_LOGIC;
  signal state3_carry_n_2 : STD_LOGIC;
  signal state3_carry_n_3 : STD_LOGIC;
  signal state3_carry_n_4 : STD_LOGIC;
  signal state3_carry_n_5 : STD_LOGIC;
  signal state3_carry_n_6 : STD_LOGIC;
  signal state3_carry_n_7 : STD_LOGIC;
  signal \state__0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal word_count : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \word_count0_carry__0_n_0\ : STD_LOGIC;
  signal \word_count0_carry__0_n_1\ : STD_LOGIC;
  signal \word_count0_carry__0_n_2\ : STD_LOGIC;
  signal \word_count0_carry__0_n_3\ : STD_LOGIC;
  signal \word_count0_carry__0_n_4\ : STD_LOGIC;
  signal \word_count0_carry__0_n_5\ : STD_LOGIC;
  signal \word_count0_carry__0_n_6\ : STD_LOGIC;
  signal \word_count0_carry__0_n_7\ : STD_LOGIC;
  signal \word_count0_carry__1_n_0\ : STD_LOGIC;
  signal \word_count0_carry__1_n_1\ : STD_LOGIC;
  signal \word_count0_carry__1_n_2\ : STD_LOGIC;
  signal \word_count0_carry__1_n_3\ : STD_LOGIC;
  signal \word_count0_carry__1_n_4\ : STD_LOGIC;
  signal \word_count0_carry__1_n_5\ : STD_LOGIC;
  signal \word_count0_carry__1_n_6\ : STD_LOGIC;
  signal \word_count0_carry__1_n_7\ : STD_LOGIC;
  signal \word_count0_carry__2_n_2\ : STD_LOGIC;
  signal \word_count0_carry__2_n_3\ : STD_LOGIC;
  signal \word_count0_carry__2_n_4\ : STD_LOGIC;
  signal \word_count0_carry__2_n_5\ : STD_LOGIC;
  signal \word_count0_carry__2_n_6\ : STD_LOGIC;
  signal \word_count0_carry__2_n_7\ : STD_LOGIC;
  signal word_count0_carry_n_0 : STD_LOGIC;
  signal word_count0_carry_n_1 : STD_LOGIC;
  signal word_count0_carry_n_2 : STD_LOGIC;
  signal word_count0_carry_n_3 : STD_LOGIC;
  signal word_count0_carry_n_4 : STD_LOGIC;
  signal word_count0_carry_n_5 : STD_LOGIC;
  signal word_count0_carry_n_6 : STD_LOGIC;
  signal word_count0_carry_n_7 : STD_LOGIC;
  signal \word_count[31]_i_1_n_0\ : STD_LOGIC;
  signal \word_count_reg_n_0_[0]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[10]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[11]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[12]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[13]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[14]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[15]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[16]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[17]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[18]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[19]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[1]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[20]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[21]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[22]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[23]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[24]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[25]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[26]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[2]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[3]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[4]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[5]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[6]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[7]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[8]\ : STD_LOGIC;
  signal \word_count_reg_n_0_[9]\ : STD_LOGIC;
  signal NLW_state2_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_state2_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 3 );
  signal \NLW_state2_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_state3_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_state3_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal \NLW_word_count0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_word_count0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[0]_i_1__0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_2\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_3\ : label is "soft_lutpair6";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "IDLE:00,READ_STREAM:10,WRITE_STREAM:01,DONE:11";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "IDLE:00,READ_STREAM:10,WRITE_STREAM:01,DONE:11";
  attribute SOFT_HLUTNM of done_i_1 : label is "soft_lutpair6";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of state3_carry : label is 35;
  attribute ADDER_THRESHOLD of \state3_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \state3_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \state3_carry__2\ : label is 35;
  attribute ADDER_THRESHOLD of word_count0_carry : label is 35;
  attribute ADDER_THRESHOLD of \word_count0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \word_count0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \word_count0_carry__2\ : label is 35;
  attribute SOFT_HLUTNM of \word_count[0]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \word_count[10]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \word_count[11]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \word_count[12]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \word_count[13]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \word_count[14]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \word_count[15]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \word_count[16]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \word_count[17]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \word_count[18]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \word_count[19]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \word_count[1]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \word_count[20]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \word_count[21]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \word_count[22]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \word_count[23]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \word_count[24]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \word_count[25]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \word_count[26]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \word_count[27]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \word_count[28]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \word_count[29]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \word_count[2]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \word_count[30]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \word_count[31]_i_2\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \word_count[3]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \word_count[4]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \word_count[5]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \word_count[6]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \word_count[7]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \word_count[8]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \word_count[9]_i_1\ : label is "soft_lutpair18";
begin
  Q(4 downto 0) <= \^q\(4 downto 0);
  \slv_reg6_reg[30]\(16 downto 0) <= \^slv_reg6_reg[30]\(16 downto 0);
\FSM_sequential_state[0]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"5E"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \FSM_sequential_state_reg[0]_1\,
      I2 => \FSM_sequential_state_reg_n_0_[1]\,
      O => state(0)
    );
\FSM_sequential_state[1]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFA8FFFFFFA80000"
    )
        port map (
      I0 => s_axis_valid,
      I1 => s_axis_last,
      I2 => \state2_carry__0_n_5\,
      I3 => \FSM_sequential_state_reg_n_0_[1]\,
      I4 => \state__0\(0),
      I5 => \FSM_sequential_state[1]_i_3_n_0\,
      O => \FSM_sequential_state[1]_i_1__0_n_0\
    );
\FSM_sequential_state[1]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"67"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \FSM_sequential_state_reg_n_0_[1]\,
      I2 => \FSM_sequential_state_reg[0]_1\,
      O => state(1)
    );
\FSM_sequential_state[1]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0E"
    )
        port map (
      I0 => \word_count_reg[31]_0\,
      I1 => \FSM_sequential_state_reg[0]_1\,
      I2 => \FSM_sequential_state_reg_n_0_[1]\,
      O => \FSM_sequential_state[1]_i_3_n_0\
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state[1]_i_1__0_n_0\,
      CLR => SR(0),
      D => state(0),
      Q => \state__0\(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state[1]_i_1__0_n_0\,
      CLR => SR(0),
      D => state(1),
      Q => \FSM_sequential_state_reg_n_0_[1]\
    );
done_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \FSM_sequential_state_reg_n_0_[1]\,
      I1 => \state__0\(0),
      O => done_i_1_n_0
    );
done_reg: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      CLR => SR(0),
      D => done_i_1_n_0,
      Q => bram_done
    );
\state1_carry__0_i_13\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => state2(23),
      I1 => state2(22),
      I2 => \state1_carry__0\(18),
      I3 => \state1_carry__0\(19),
      O => \i_reg[22]\(2)
    );
\state1_carry__0_i_14\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => state2(20),
      I1 => state2(21),
      I2 => \state1_carry__0\(17),
      I3 => \state1_carry__0\(16),
      O => \i_reg[22]\(1)
    );
\state1_carry__0_i_16\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => state2(17),
      I1 => state2(16),
      I2 => \state1_carry__0\(12),
      I3 => \state1_carry__0\(13),
      O => \i_reg[22]\(0)
    );
\state1_carry__0_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7510"
    )
        port map (
      I0 => state2(23),
      I1 => state2(22),
      I2 => \state1_carry__0\(18),
      I3 => \state1_carry__0\(19),
      O => \i_reg[22]_0\(3)
    );
\state1_carry__0_i_6\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => state2(20),
      I1 => \state1_carry__0\(16),
      I2 => \state1_carry__0\(17),
      I3 => state2(21),
      O => \i_reg[22]_0\(2)
    );
\state1_carry__0_i_7\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => \^slv_reg6_reg[30]\(7),
      I1 => \state1_carry__0\(14),
      I2 => \state1_carry__0\(15),
      I3 => \^slv_reg6_reg[30]\(8),
      O => \i_reg[22]_0\(1)
    );
\state1_carry__0_i_8\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7510"
    )
        port map (
      I0 => state2(17),
      I1 => state2(16),
      I2 => \state1_carry__0\(12),
      I3 => \state1_carry__0\(13),
      O => \i_reg[22]_0\(0)
    );
state1_carry_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => state2(14),
      I1 => \state1_carry__0\(10),
      I2 => \state1_carry__0\(11),
      I3 => state2(15),
      O => DI(5)
    );
state1_carry_i_11: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => state2(11),
      I1 => state2(10),
      I2 => \state1_carry__0\(6),
      I3 => \state1_carry__0\(7),
      O => \i_reg[15]\(2)
    );
state1_carry_i_12: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => state2(8),
      I1 => state2(9),
      I2 => \state1_carry__0\(5),
      I3 => \state1_carry__0\(4),
      O => \i_reg[15]\(1)
    );
state1_carry_i_14: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => state2(5),
      I1 => state2(4),
      I2 => \state1_carry__0\(0),
      I3 => \state1_carry__0\(1),
      O => \i_reg[15]\(0)
    );
state1_carry_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => \^slv_reg6_reg[30]\(5),
      I1 => \state1_carry__0\(8),
      I2 => \state1_carry__0\(9),
      I3 => \^slv_reg6_reg[30]\(6),
      O => DI(4)
    );
state1_carry_i_3: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7510"
    )
        port map (
      I0 => state2(11),
      I1 => state2(10),
      I2 => \state1_carry__0\(6),
      I3 => \state1_carry__0\(7),
      O => DI(3)
    );
state1_carry_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => state2(8),
      I1 => \state1_carry__0\(4),
      I2 => \state1_carry__0\(5),
      I3 => state2(9),
      O => DI(2)
    );
state1_carry_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => \^slv_reg6_reg[30]\(3),
      I1 => \state1_carry__0\(2),
      I2 => \state1_carry__0\(3),
      I3 => \^slv_reg6_reg[30]\(4),
      O => DI(1)
    );
state1_carry_i_6: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7510"
    )
        port map (
      I0 => state2(5),
      I1 => state2(4),
      I2 => \state1_carry__0\(0),
      I3 => \state1_carry__0\(1),
      O => DI(0)
    );
state1_carry_i_9: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => state2(14),
      I1 => state2(15),
      I2 => \state1_carry__0\(11),
      I3 => \state1_carry__0\(10),
      O => \i_reg[15]\(3)
    );
state2_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => state2_carry_n_0,
      CO(6) => state2_carry_n_1,
      CO(5) => state2_carry_n_2,
      CO(4) => state2_carry_n_3,
      CO(3) => state2_carry_n_4,
      CO(2) => state2_carry_n_5,
      CO(1) => state2_carry_n_6,
      CO(0) => state2_carry_n_7,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => NLW_state2_carry_O_UNCONNECTED(7 downto 0),
      S(7) => state2_carry_i_1_n_0,
      S(6) => state2_carry_i_2_n_0,
      S(5) => state2_carry_i_3_n_0,
      S(4) => state2_carry_i_4_n_0,
      S(3) => state2_carry_i_5_n_0,
      S(2) => state2_carry_i_6_n_0,
      S(1) => state2_carry_i_7_n_0,
      S(0) => state2_carry_i_8_n_0
    );
\state2_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => state2_carry_n_0,
      CI_TOP => '0',
      CO(7 downto 3) => \NLW_state2_carry__0_CO_UNCONNECTED\(7 downto 3),
      CO(2) => \state2_carry__0_n_5\,
      CO(1) => \state2_carry__0_n_6\,
      CO(0) => \state2_carry__0_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => \NLW_state2_carry__0_O_UNCONNECTED\(7 downto 0),
      S(7 downto 3) => B"00000",
      S(2 downto 1) => \FSM_sequential_state_reg[0]_0\(1 downto 0),
      S(0) => \state2_carry__0_i_3_n_0\
    );
\state2_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => \^slv_reg6_reg[30]\(11),
      I1 => \^slv_reg6_reg[30]\(10),
      I2 => \word_count_reg_n_0_[24]\,
      I3 => \^slv_reg6_reg[30]\(9),
      I4 => \word_count_reg_n_0_[25]\,
      I5 => \word_count_reg_n_0_[26]\,
      O => \state2_carry__0_i_3_n_0\
    );
state2_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => state2(23),
      I1 => state2(22),
      I2 => state2(21),
      I3 => \word_count_reg_n_0_[21]\,
      I4 => \word_count_reg_n_0_[22]\,
      I5 => \word_count_reg_n_0_[23]\,
      O => state2_carry_i_1_n_0
    );
state2_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => state2(20),
      I1 => \^slv_reg6_reg[30]\(8),
      I2 => \word_count_reg_n_0_[18]\,
      I3 => \^slv_reg6_reg[30]\(7),
      I4 => \word_count_reg_n_0_[19]\,
      I5 => \word_count_reg_n_0_[20]\,
      O => state2_carry_i_2_n_0
    );
state2_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => state2(17),
      I1 => state2(16),
      I2 => state2(15),
      I3 => \word_count_reg_n_0_[15]\,
      I4 => \word_count_reg_n_0_[16]\,
      I5 => \word_count_reg_n_0_[17]\,
      O => state2_carry_i_3_n_0
    );
state2_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => state2(14),
      I1 => \^slv_reg6_reg[30]\(6),
      I2 => \word_count_reg_n_0_[12]\,
      I3 => \^slv_reg6_reg[30]\(5),
      I4 => \word_count_reg_n_0_[13]\,
      I5 => \word_count_reg_n_0_[14]\,
      O => state2_carry_i_4_n_0
    );
state2_carry_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => state2(11),
      I1 => state2(10),
      I2 => state2(9),
      I3 => \word_count_reg_n_0_[9]\,
      I4 => \word_count_reg_n_0_[10]\,
      I5 => \word_count_reg_n_0_[11]\,
      O => state2_carry_i_5_n_0
    );
state2_carry_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => state2(8),
      I1 => \^slv_reg6_reg[30]\(4),
      I2 => \word_count_reg_n_0_[6]\,
      I3 => \^slv_reg6_reg[30]\(3),
      I4 => \word_count_reg_n_0_[7]\,
      I5 => \word_count_reg_n_0_[8]\,
      O => state2_carry_i_6_n_0
    );
state2_carry_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => state2(5),
      I1 => state2(4),
      I2 => \^slv_reg6_reg[30]\(2),
      I3 => \word_count_reg_n_0_[3]\,
      I4 => \word_count_reg_n_0_[4]\,
      I5 => \word_count_reg_n_0_[5]\,
      O => state2_carry_i_7_n_0
    );
state2_carry_i_8: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4004100180082002"
    )
        port map (
      I0 => \word_count_reg_n_0_[0]\,
      I1 => \^slv_reg6_reg[30]\(1),
      I2 => \word_count_reg_n_0_[1]\,
      I3 => \^slv_reg6_reg[30]\(0),
      I4 => \word_count_reg_n_0_[2]\,
      I5 => \state1_carry__0_i_12\(0),
      O => state2_carry_i_8_n_0
    );
state3_carry: unisim.vcomponents.CARRY8
     port map (
      CI => \state1_carry__0_i_12\(0),
      CI_TOP => '0',
      CO(7) => state3_carry_n_0,
      CO(6) => state3_carry_n_1,
      CO(5) => state3_carry_n_2,
      CO(4) => state3_carry_n_3,
      CO(3) => state3_carry_n_4,
      CO(2) => state3_carry_n_5,
      CO(1) => state3_carry_n_6,
      CO(0) => state3_carry_n_7,
      DI(7 downto 0) => \state1_carry__0_i_12\(8 downto 1),
      O(7) => state2(8),
      O(6 downto 5) => \^slv_reg6_reg[30]\(4 downto 3),
      O(4 downto 3) => state2(5 downto 4),
      O(2 downto 0) => \^slv_reg6_reg[30]\(2 downto 0),
      S(7 downto 0) => S(7 downto 0)
    );
\state3_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => state3_carry_n_0,
      CI_TOP => '0',
      CO(7) => \state3_carry__0_n_0\,
      CO(6) => \state3_carry__0_n_1\,
      CO(5) => \state3_carry__0_n_2\,
      CO(4) => \state3_carry__0_n_3\,
      CO(3) => \state3_carry__0_n_4\,
      CO(2) => \state3_carry__0_n_5\,
      CO(1) => \state3_carry__0_n_6\,
      CO(0) => \state3_carry__0_n_7\,
      DI(7 downto 0) => \state1_carry__0_i_12\(16 downto 9),
      O(7 downto 5) => state2(16 downto 14),
      O(4 downto 3) => \^slv_reg6_reg[30]\(6 downto 5),
      O(2 downto 0) => state2(11 downto 9),
      S(7 downto 0) => state2_carry_i_5_0(7 downto 0)
    );
\state3_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \state3_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \state3_carry__1_n_0\,
      CO(6) => \state3_carry__1_n_1\,
      CO(5) => \state3_carry__1_n_2\,
      CO(4) => \state3_carry__1_n_3\,
      CO(3) => \state3_carry__1_n_4\,
      CO(2) => \state3_carry__1_n_5\,
      CO(1) => \state3_carry__1_n_6\,
      CO(0) => \state3_carry__1_n_7\,
      DI(7 downto 0) => \state1_carry__0_i_12\(24 downto 17),
      O(7) => \^slv_reg6_reg[30]\(9),
      O(6 downto 3) => state2(23 downto 20),
      O(2 downto 1) => \^slv_reg6_reg[30]\(8 downto 7),
      O(0) => state2(17),
      S(7 downto 0) => state2_carry_i_3_0(7 downto 0)
    );
\state3_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \state3_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_state3_carry__2_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \state3_carry__2_n_2\,
      CO(4) => \state3_carry__2_n_3\,
      CO(3) => \state3_carry__2_n_4\,
      CO(2) => \state3_carry__2_n_5\,
      CO(1) => \state3_carry__2_n_6\,
      CO(0) => \state3_carry__2_n_7\,
      DI(7 downto 6) => B"00",
      DI(5 downto 0) => \state1_carry__0_i_12\(30 downto 25),
      O(7) => \NLW_state3_carry__2_O_UNCONNECTED\(7),
      O(6 downto 0) => \^slv_reg6_reg[30]\(16 downto 10),
      S(7) => '0',
      S(6 downto 0) => \state1_carry__0_i_12_0\(6 downto 0)
    );
word_count0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => \word_count_reg_n_0_[0]\,
      CI_TOP => '0',
      CO(7) => word_count0_carry_n_0,
      CO(6) => word_count0_carry_n_1,
      CO(5) => word_count0_carry_n_2,
      CO(4) => word_count0_carry_n_3,
      CO(3) => word_count0_carry_n_4,
      CO(2) => word_count0_carry_n_5,
      CO(1) => word_count0_carry_n_6,
      CO(0) => word_count0_carry_n_7,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => in8(8 downto 1),
      S(7) => \word_count_reg_n_0_[8]\,
      S(6) => \word_count_reg_n_0_[7]\,
      S(5) => \word_count_reg_n_0_[6]\,
      S(4) => \word_count_reg_n_0_[5]\,
      S(3) => \word_count_reg_n_0_[4]\,
      S(2) => \word_count_reg_n_0_[3]\,
      S(1) => \word_count_reg_n_0_[2]\,
      S(0) => \word_count_reg_n_0_[1]\
    );
\word_count0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => word_count0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \word_count0_carry__0_n_0\,
      CO(6) => \word_count0_carry__0_n_1\,
      CO(5) => \word_count0_carry__0_n_2\,
      CO(4) => \word_count0_carry__0_n_3\,
      CO(3) => \word_count0_carry__0_n_4\,
      CO(2) => \word_count0_carry__0_n_5\,
      CO(1) => \word_count0_carry__0_n_6\,
      CO(0) => \word_count0_carry__0_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => in8(16 downto 9),
      S(7) => \word_count_reg_n_0_[16]\,
      S(6) => \word_count_reg_n_0_[15]\,
      S(5) => \word_count_reg_n_0_[14]\,
      S(4) => \word_count_reg_n_0_[13]\,
      S(3) => \word_count_reg_n_0_[12]\,
      S(2) => \word_count_reg_n_0_[11]\,
      S(1) => \word_count_reg_n_0_[10]\,
      S(0) => \word_count_reg_n_0_[9]\
    );
\word_count0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \word_count0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \word_count0_carry__1_n_0\,
      CO(6) => \word_count0_carry__1_n_1\,
      CO(5) => \word_count0_carry__1_n_2\,
      CO(4) => \word_count0_carry__1_n_3\,
      CO(3) => \word_count0_carry__1_n_4\,
      CO(2) => \word_count0_carry__1_n_5\,
      CO(1) => \word_count0_carry__1_n_6\,
      CO(0) => \word_count0_carry__1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => in8(24 downto 17),
      S(7) => \word_count_reg_n_0_[24]\,
      S(6) => \word_count_reg_n_0_[23]\,
      S(5) => \word_count_reg_n_0_[22]\,
      S(4) => \word_count_reg_n_0_[21]\,
      S(3) => \word_count_reg_n_0_[20]\,
      S(2) => \word_count_reg_n_0_[19]\,
      S(1) => \word_count_reg_n_0_[18]\,
      S(0) => \word_count_reg_n_0_[17]\
    );
\word_count0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \word_count0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_word_count0_carry__2_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \word_count0_carry__2_n_2\,
      CO(4) => \word_count0_carry__2_n_3\,
      CO(3) => \word_count0_carry__2_n_4\,
      CO(2) => \word_count0_carry__2_n_5\,
      CO(1) => \word_count0_carry__2_n_6\,
      CO(0) => \word_count0_carry__2_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \NLW_word_count0_carry__2_O_UNCONNECTED\(7),
      O(6 downto 0) => in8(31 downto 25),
      S(7) => '0',
      S(6 downto 2) => \^q\(4 downto 0),
      S(1) => \word_count_reg_n_0_[26]\,
      S(0) => \word_count_reg_n_0_[25]\
    );
\word_count[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \state__0\(0),
      I1 => \word_count_reg_n_0_[0]\,
      O => word_count(0)
    );
\word_count[10]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(10),
      O => word_count(10)
    );
\word_count[11]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(11),
      O => word_count(11)
    );
\word_count[12]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(12),
      O => word_count(12)
    );
\word_count[13]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(13),
      O => word_count(13)
    );
\word_count[14]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(14),
      O => word_count(14)
    );
\word_count[15]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(15),
      O => word_count(15)
    );
\word_count[16]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(16),
      O => word_count(16)
    );
\word_count[17]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(17),
      O => word_count(17)
    );
\word_count[18]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(18),
      O => word_count(18)
    );
\word_count[19]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(19),
      O => word_count(19)
    );
\word_count[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(1),
      O => word_count(1)
    );
\word_count[20]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(20),
      O => word_count(20)
    );
\word_count[21]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(21),
      O => word_count(21)
    );
\word_count[22]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(22),
      O => word_count(22)
    );
\word_count[23]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(23),
      O => word_count(23)
    );
\word_count[24]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(24),
      O => word_count(24)
    );
\word_count[25]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(25),
      O => word_count(25)
    );
\word_count[26]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(26),
      O => word_count(26)
    );
\word_count[27]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(27),
      O => word_count(27)
    );
\word_count[28]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(28),
      O => word_count(28)
    );
\word_count[29]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(29),
      O => word_count(29)
    );
\word_count[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(2),
      O => word_count(2)
    );
\word_count[30]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(30),
      O => word_count(30)
    );
\word_count[31]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000BBB8"
    )
        port map (
      I0 => s_axis_valid,
      I1 => \state__0\(0),
      I2 => \word_count_reg[31]_0\,
      I3 => \FSM_sequential_state_reg[0]_1\,
      I4 => \FSM_sequential_state_reg_n_0_[1]\,
      O => \word_count[31]_i_1_n_0\
    );
\word_count[31]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(31),
      O => word_count(31)
    );
\word_count[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(3),
      O => word_count(3)
    );
\word_count[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(4),
      O => word_count(4)
    );
\word_count[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(5),
      O => word_count(5)
    );
\word_count[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(6),
      O => word_count(6)
    );
\word_count[7]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(7),
      O => word_count(7)
    );
\word_count[8]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(8),
      O => word_count(8)
    );
\word_count[9]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \state__0\(0),
      I1 => in8(9),
      O => word_count(9)
    );
\word_count_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(0),
      Q => \word_count_reg_n_0_[0]\
    );
\word_count_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(10),
      Q => \word_count_reg_n_0_[10]\
    );
\word_count_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(11),
      Q => \word_count_reg_n_0_[11]\
    );
\word_count_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(12),
      Q => \word_count_reg_n_0_[12]\
    );
\word_count_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(13),
      Q => \word_count_reg_n_0_[13]\
    );
\word_count_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(14),
      Q => \word_count_reg_n_0_[14]\
    );
\word_count_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(15),
      Q => \word_count_reg_n_0_[15]\
    );
\word_count_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(16),
      Q => \word_count_reg_n_0_[16]\
    );
\word_count_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(17),
      Q => \word_count_reg_n_0_[17]\
    );
\word_count_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(18),
      Q => \word_count_reg_n_0_[18]\
    );
\word_count_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(19),
      Q => \word_count_reg_n_0_[19]\
    );
\word_count_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(1),
      Q => \word_count_reg_n_0_[1]\
    );
\word_count_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(20),
      Q => \word_count_reg_n_0_[20]\
    );
\word_count_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(21),
      Q => \word_count_reg_n_0_[21]\
    );
\word_count_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(22),
      Q => \word_count_reg_n_0_[22]\
    );
\word_count_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(23),
      Q => \word_count_reg_n_0_[23]\
    );
\word_count_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(24),
      Q => \word_count_reg_n_0_[24]\
    );
\word_count_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(25),
      Q => \word_count_reg_n_0_[25]\
    );
\word_count_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(26),
      Q => \word_count_reg_n_0_[26]\
    );
\word_count_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(27),
      Q => \^q\(0)
    );
\word_count_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(28),
      Q => \^q\(1)
    );
\word_count_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(29),
      Q => \^q\(2)
    );
\word_count_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(2),
      Q => \word_count_reg_n_0_[2]\
    );
\word_count_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(30),
      Q => \^q\(3)
    );
\word_count_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(31),
      Q => \^q\(4)
    );
\word_count_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(3),
      Q => \word_count_reg_n_0_[3]\
    );
\word_count_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(4),
      Q => \word_count_reg_n_0_[4]\
    );
\word_count_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(5),
      Q => \word_count_reg_n_0_[5]\
    );
\word_count_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(6),
      Q => \word_count_reg_n_0_[6]\
    );
\word_count_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(7),
      Q => \word_count_reg_n_0_[7]\
    );
\word_count_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(8),
      Q => \word_count_reg_n_0_[8]\
    );
\word_count_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \word_count[31]_i_1_n_0\,
      CLR => SR(0),
      D => word_count(9),
      Q => \word_count_reg_n_0_[9]\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_compute_top is
  port (
    compute_done : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 25 downto 0 );
    s00_axi_aclk : in STD_LOGIC;
    SR : in STD_LOGIC_VECTOR ( 0 to 0 );
    DI : in STD_LOGIC_VECTOR ( 5 downto 0 );
    \state1_carry__0_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \FSM_sequential_state_reg[3]_0\ : in STD_LOGIC_VECTOR ( 6 downto 0 );
    S : in STD_LOGIC_VECTOR ( 4 downto 0 );
    state1_carry_0 : in STD_LOGIC_VECTOR ( 0 to 0 );
    \state1_carry__0_1\ : in STD_LOGIC_VECTOR ( 12 downto 0 );
    \FSM_sequential_state_reg[0]_0\ : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_compute_top;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_compute_top is
  signal \FSM_sequential_state[3]_i_1_n_0\ : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 25 downto 0 );
  signal \done_i_1__0_n_0\ : STD_LOGIC;
  signal i : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \i0_carry__0_n_0\ : STD_LOGIC;
  signal \i0_carry__0_n_1\ : STD_LOGIC;
  signal \i0_carry__0_n_2\ : STD_LOGIC;
  signal \i0_carry__0_n_3\ : STD_LOGIC;
  signal \i0_carry__0_n_4\ : STD_LOGIC;
  signal \i0_carry__0_n_5\ : STD_LOGIC;
  signal \i0_carry__0_n_6\ : STD_LOGIC;
  signal \i0_carry__0_n_7\ : STD_LOGIC;
  signal \i0_carry__1_n_0\ : STD_LOGIC;
  signal \i0_carry__1_n_1\ : STD_LOGIC;
  signal \i0_carry__1_n_2\ : STD_LOGIC;
  signal \i0_carry__1_n_3\ : STD_LOGIC;
  signal \i0_carry__1_n_4\ : STD_LOGIC;
  signal \i0_carry__1_n_5\ : STD_LOGIC;
  signal \i0_carry__1_n_6\ : STD_LOGIC;
  signal \i0_carry__1_n_7\ : STD_LOGIC;
  signal \i0_carry__2_n_2\ : STD_LOGIC;
  signal \i0_carry__2_n_3\ : STD_LOGIC;
  signal \i0_carry__2_n_4\ : STD_LOGIC;
  signal \i0_carry__2_n_5\ : STD_LOGIC;
  signal \i0_carry__2_n_6\ : STD_LOGIC;
  signal \i0_carry__2_n_7\ : STD_LOGIC;
  signal i0_carry_n_0 : STD_LOGIC;
  signal i0_carry_n_1 : STD_LOGIC;
  signal i0_carry_n_2 : STD_LOGIC;
  signal i0_carry_n_3 : STD_LOGIC;
  signal i0_carry_n_4 : STD_LOGIC;
  signal i0_carry_n_5 : STD_LOGIC;
  signal i0_carry_n_6 : STD_LOGIC;
  signal i0_carry_n_7 : STD_LOGIC;
  signal \i[31]_i_1_n_0\ : STD_LOGIC;
  signal \i_reg_n_0_[0]\ : STD_LOGIC;
  signal \i_reg_n_0_[1]\ : STD_LOGIC;
  signal \i_reg_n_0_[24]\ : STD_LOGIC;
  signal \i_reg_n_0_[25]\ : STD_LOGIC;
  signal \i_reg_n_0_[2]\ : STD_LOGIC;
  signal \i_reg_n_0_[3]\ : STD_LOGIC;
  signal in7 : STD_LOGIC_VECTOR ( 31 downto 1 );
  signal state : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \state1_carry__0_i_12_n_0\ : STD_LOGIC;
  signal \state1_carry__0_i_15_n_0\ : STD_LOGIC;
  signal \state1_carry__0_i_4_n_0\ : STD_LOGIC;
  signal \state1_carry__0_i_9_n_0\ : STD_LOGIC;
  signal \state1_carry__0_n_0\ : STD_LOGIC;
  signal \state1_carry__0_n_1\ : STD_LOGIC;
  signal \state1_carry__0_n_2\ : STD_LOGIC;
  signal \state1_carry__0_n_3\ : STD_LOGIC;
  signal \state1_carry__0_n_4\ : STD_LOGIC;
  signal \state1_carry__0_n_5\ : STD_LOGIC;
  signal \state1_carry__0_n_6\ : STD_LOGIC;
  signal \state1_carry__0_n_7\ : STD_LOGIC;
  signal state1_carry_i_10_n_0 : STD_LOGIC;
  signal state1_carry_i_13_n_0 : STD_LOGIC;
  signal state1_carry_i_15_n_0 : STD_LOGIC;
  signal state1_carry_i_16_n_0 : STD_LOGIC;
  signal state1_carry_i_7_n_0 : STD_LOGIC;
  signal state1_carry_i_8_n_0 : STD_LOGIC;
  signal state1_carry_n_0 : STD_LOGIC;
  signal state1_carry_n_1 : STD_LOGIC;
  signal state1_carry_n_2 : STD_LOGIC;
  signal state1_carry_n_3 : STD_LOGIC;
  signal state1_carry_n_4 : STD_LOGIC;
  signal state1_carry_n_5 : STD_LOGIC;
  signal state1_carry_n_6 : STD_LOGIC;
  signal state1_carry_n_7 : STD_LOGIC;
  signal \state__0\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_i0_carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 6 );
  signal \NLW_i0_carry__2_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 to 7 );
  signal NLW_state1_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \NLW_state1_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[0]_i_1__1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_1__1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \FSM_sequential_state[2]_i_1\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \FSM_sequential_state[3]_i_2\ : label is "soft_lutpair23";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "IDLE:0000,WRITE_OUT:0111,DONE:1000,READ_B_W2:0110,READ_B_W1:0101,READ_A_W2:0011,READ_B:0100,READ_A_W1:0010,READ_A:0001";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "IDLE:0000,WRITE_OUT:0111,DONE:1000,READ_B_W2:0110,READ_B_W1:0101,READ_A_W2:0011,READ_B:0100,READ_A_W1:0010,READ_A:0001";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[2]\ : label is "IDLE:0000,WRITE_OUT:0111,DONE:1000,READ_B_W2:0110,READ_B_W1:0101,READ_A_W2:0011,READ_B:0100,READ_A_W1:0010,READ_A:0001";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[3]\ : label is "IDLE:0000,WRITE_OUT:0111,DONE:1000,READ_B_W2:0110,READ_B_W1:0101,READ_A_W2:0011,READ_B:0100,READ_A_W1:0010,READ_A:0001";
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of i0_carry : label is 35;
  attribute ADDER_THRESHOLD of \i0_carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \i0_carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \i0_carry__2\ : label is 35;
  attribute SOFT_HLUTNM of \i[0]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \i[10]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \i[11]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \i[12]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \i[13]_i_1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \i[14]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \i[15]_i_1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \i[16]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \i[17]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \i[18]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \i[19]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \i[1]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \i[20]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \i[21]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \i[22]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \i[23]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \i[24]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \i[25]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \i[26]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \i[27]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \i[28]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \i[29]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \i[2]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \i[30]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \i[31]_i_2\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \i[3]_i_1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \i[4]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \i[5]_i_1\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \i[6]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \i[7]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \i[8]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \i[9]_i_1\ : label is "soft_lutpair36";
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of state1_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \state1_carry__0\ : label is 11;
begin
  Q(25 downto 0) <= \^q\(25 downto 0);
\FSM_sequential_state[0]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000055D5"
    )
        port map (
      I0 => state(0),
      I1 => state(2),
      I2 => state(1),
      I3 => \state1_carry__0_n_0\,
      I4 => state(3),
      O => \state__0\(0)
    );
\FSM_sequential_state[1]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => state(0),
      I1 => state(1),
      I2 => state(3),
      O => \state__0\(1)
    );
\FSM_sequential_state[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0078"
    )
        port map (
      I0 => state(0),
      I1 => state(1),
      I2 => state(2),
      I3 => state(3),
      O => \state__0\(2)
    );
\FSM_sequential_state[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5555555E"
    )
        port map (
      I0 => state(3),
      I1 => \FSM_sequential_state_reg[0]_0\,
      I2 => state(1),
      I3 => state(0),
      I4 => state(2),
      O => \FSM_sequential_state[3]_i_1_n_0\
    );
\FSM_sequential_state[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00008000"
    )
        port map (
      I0 => state(2),
      I1 => state(0),
      I2 => \state1_carry__0_n_0\,
      I3 => state(1),
      I4 => state(3),
      O => \state__0\(3)
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state[3]_i_1_n_0\,
      CLR => SR(0),
      D => \state__0\(0),
      Q => state(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state[3]_i_1_n_0\,
      CLR => SR(0),
      D => \state__0\(1),
      Q => state(1)
    );
\FSM_sequential_state_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state[3]_i_1_n_0\,
      CLR => SR(0),
      D => \state__0\(2),
      Q => state(2)
    );
\FSM_sequential_state_reg[3]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state[3]_i_1_n_0\,
      CLR => SR(0),
      D => \state__0\(3),
      Q => state(3)
    );
\done_i_1__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0100"
    )
        port map (
      I0 => state(2),
      I1 => state(0),
      I2 => state(1),
      I3 => state(3),
      O => \done_i_1__0_n_0\
    );
done_reg: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      CLR => SR(0),
      D => \done_i_1__0_n_0\,
      Q => compute_done
    );
i0_carry: unisim.vcomponents.CARRY8
     port map (
      CI => \i_reg_n_0_[0]\,
      CI_TOP => '0',
      CO(7) => i0_carry_n_0,
      CO(6) => i0_carry_n_1,
      CO(5) => i0_carry_n_2,
      CO(4) => i0_carry_n_3,
      CO(3) => i0_carry_n_4,
      CO(2) => i0_carry_n_5,
      CO(1) => i0_carry_n_6,
      CO(0) => i0_carry_n_7,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => in7(8 downto 1),
      S(7 downto 3) => \^q\(4 downto 0),
      S(2) => \i_reg_n_0_[3]\,
      S(1) => \i_reg_n_0_[2]\,
      S(0) => \i_reg_n_0_[1]\
    );
\i0_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => i0_carry_n_0,
      CI_TOP => '0',
      CO(7) => \i0_carry__0_n_0\,
      CO(6) => \i0_carry__0_n_1\,
      CO(5) => \i0_carry__0_n_2\,
      CO(4) => \i0_carry__0_n_3\,
      CO(3) => \i0_carry__0_n_4\,
      CO(2) => \i0_carry__0_n_5\,
      CO(1) => \i0_carry__0_n_6\,
      CO(0) => \i0_carry__0_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => in7(16 downto 9),
      S(7 downto 0) => \^q\(12 downto 5)
    );
\i0_carry__1\: unisim.vcomponents.CARRY8
     port map (
      CI => \i0_carry__0_n_0\,
      CI_TOP => '0',
      CO(7) => \i0_carry__1_n_0\,
      CO(6) => \i0_carry__1_n_1\,
      CO(5) => \i0_carry__1_n_2\,
      CO(4) => \i0_carry__1_n_3\,
      CO(3) => \i0_carry__1_n_4\,
      CO(2) => \i0_carry__1_n_5\,
      CO(1) => \i0_carry__1_n_6\,
      CO(0) => \i0_carry__1_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7 downto 0) => in7(24 downto 17),
      S(7) => \i_reg_n_0_[24]\,
      S(6 downto 0) => \^q\(19 downto 13)
    );
\i0_carry__2\: unisim.vcomponents.CARRY8
     port map (
      CI => \i0_carry__1_n_0\,
      CI_TOP => '0',
      CO(7 downto 6) => \NLW_i0_carry__2_CO_UNCONNECTED\(7 downto 6),
      CO(5) => \i0_carry__2_n_2\,
      CO(4) => \i0_carry__2_n_3\,
      CO(3) => \i0_carry__2_n_4\,
      CO(2) => \i0_carry__2_n_5\,
      CO(1) => \i0_carry__2_n_6\,
      CO(0) => \i0_carry__2_n_7\,
      DI(7 downto 0) => B"00000000",
      O(7) => \NLW_i0_carry__2_O_UNCONNECTED\(7),
      O(6 downto 0) => in7(31 downto 25),
      S(7) => '0',
      S(6 downto 1) => \^q\(25 downto 20),
      S(0) => \i_reg_n_0_[25]\
    );
\i[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"4"
    )
        port map (
      I0 => \i_reg_n_0_[0]\,
      I1 => state(2),
      O => i(0)
    );
\i[10]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(10),
      I1 => state(2),
      O => i(10)
    );
\i[11]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(11),
      I1 => state(2),
      O => i(11)
    );
\i[12]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(12),
      I1 => state(2),
      O => i(12)
    );
\i[13]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(13),
      I1 => state(2),
      O => i(13)
    );
\i[14]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(14),
      I1 => state(2),
      O => i(14)
    );
\i[15]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(15),
      I1 => state(2),
      O => i(15)
    );
\i[16]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(16),
      I1 => state(2),
      O => i(16)
    );
\i[17]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(17),
      I1 => state(2),
      O => i(17)
    );
\i[18]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(18),
      I1 => state(2),
      O => i(18)
    );
\i[19]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(19),
      I1 => state(2),
      O => i(19)
    );
\i[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(1),
      I1 => state(2),
      O => i(1)
    );
\i[20]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(20),
      I1 => state(2),
      O => i(20)
    );
\i[21]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(21),
      I1 => state(2),
      O => i(21)
    );
\i[22]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(22),
      I1 => state(2),
      O => i(22)
    );
\i[23]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(23),
      I1 => state(2),
      O => i(23)
    );
\i[24]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(24),
      I1 => state(2),
      O => i(24)
    );
\i[25]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(25),
      I1 => state(2),
      O => i(25)
    );
\i[26]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(26),
      I1 => state(2),
      O => i(26)
    );
\i[27]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(27),
      I1 => state(2),
      O => i(27)
    );
\i[28]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(28),
      I1 => state(2),
      O => i(28)
    );
\i[29]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(29),
      I1 => state(2),
      O => i(29)
    );
\i[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(2),
      I1 => state(2),
      O => i(2)
    );
\i[30]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(30),
      I1 => state(2),
      O => i(30)
    );
\i[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000002C002"
    )
        port map (
      I0 => \FSM_sequential_state_reg[0]_0\,
      I1 => state(0),
      I2 => state(1),
      I3 => state(2),
      I4 => \state1_carry__0_n_0\,
      I5 => state(3),
      O => \i[31]_i_1_n_0\
    );
\i[31]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(31),
      I1 => state(2),
      O => i(31)
    );
\i[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(3),
      I1 => state(2),
      O => i(3)
    );
\i[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(4),
      I1 => state(2),
      O => i(4)
    );
\i[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(5),
      I1 => state(2),
      O => i(5)
    );
\i[6]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(6),
      I1 => state(2),
      O => i(6)
    );
\i[7]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(7),
      I1 => state(2),
      O => i(7)
    );
\i[8]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(8),
      I1 => state(2),
      O => i(8)
    );
\i[9]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => in7(9),
      I1 => state(2),
      O => i(9)
    );
\i_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(0),
      Q => \i_reg_n_0_[0]\
    );
\i_reg[10]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(10),
      Q => \^q\(6)
    );
\i_reg[11]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(11),
      Q => \^q\(7)
    );
\i_reg[12]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(12),
      Q => \^q\(8)
    );
\i_reg[13]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(13),
      Q => \^q\(9)
    );
\i_reg[14]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(14),
      Q => \^q\(10)
    );
\i_reg[15]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(15),
      Q => \^q\(11)
    );
\i_reg[16]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(16),
      Q => \^q\(12)
    );
\i_reg[17]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(17),
      Q => \^q\(13)
    );
\i_reg[18]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(18),
      Q => \^q\(14)
    );
\i_reg[19]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(19),
      Q => \^q\(15)
    );
\i_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(1),
      Q => \i_reg_n_0_[1]\
    );
\i_reg[20]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(20),
      Q => \^q\(16)
    );
\i_reg[21]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(21),
      Q => \^q\(17)
    );
\i_reg[22]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(22),
      Q => \^q\(18)
    );
\i_reg[23]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(23),
      Q => \^q\(19)
    );
\i_reg[24]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(24),
      Q => \i_reg_n_0_[24]\
    );
\i_reg[25]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(25),
      Q => \i_reg_n_0_[25]\
    );
\i_reg[26]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(26),
      Q => \^q\(20)
    );
\i_reg[27]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(27),
      Q => \^q\(21)
    );
\i_reg[28]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(28),
      Q => \^q\(22)
    );
\i_reg[29]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(29),
      Q => \^q\(23)
    );
\i_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(2),
      Q => \i_reg_n_0_[2]\
    );
\i_reg[30]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(30),
      Q => \^q\(24)
    );
\i_reg[31]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(31),
      Q => \^q\(25)
    );
\i_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(3),
      Q => \i_reg_n_0_[3]\
    );
\i_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(4),
      Q => \^q\(0)
    );
\i_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(5),
      Q => \^q\(1)
    );
\i_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(6),
      Q => \^q\(2)
    );
\i_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(7),
      Q => \^q\(3)
    );
\i_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(8),
      Q => \^q\(4)
    );
\i_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => \i[31]_i_1_n_0\,
      CLR => SR(0),
      D => i(9),
      Q => \^q\(5)
    );
state1_carry: unisim.vcomponents.CARRY8
     port map (
      CI => '1',
      CI_TOP => '0',
      CO(7) => state1_carry_n_0,
      CO(6) => state1_carry_n_1,
      CO(5) => state1_carry_n_2,
      CO(4) => state1_carry_n_3,
      CO(3) => state1_carry_n_4,
      CO(2) => state1_carry_n_5,
      CO(1) => state1_carry_n_6,
      CO(0) => state1_carry_n_7,
      DI(7 downto 2) => DI(5 downto 0),
      DI(1) => state1_carry_i_7_n_0,
      DI(0) => state1_carry_i_8_n_0,
      O(7 downto 0) => NLW_state1_carry_O_UNCONNECTED(7 downto 0),
      S(7) => \state1_carry__0_0\(3),
      S(6) => state1_carry_i_10_n_0,
      S(5 downto 4) => \state1_carry__0_0\(2 downto 1),
      S(3) => state1_carry_i_13_n_0,
      S(2) => \state1_carry__0_0\(0),
      S(1) => state1_carry_i_15_n_0,
      S(0) => state1_carry_i_16_n_0
    );
\state1_carry__0\: unisim.vcomponents.CARRY8
     port map (
      CI => state1_carry_n_0,
      CI_TOP => '0',
      CO(7) => \state1_carry__0_n_0\,
      CO(6) => \state1_carry__0_n_1\,
      CO(5) => \state1_carry__0_n_2\,
      CO(4) => \state1_carry__0_n_3\,
      CO(3) => \state1_carry__0_n_4\,
      CO(2) => \state1_carry__0_n_5\,
      CO(1) => \state1_carry__0_n_6\,
      CO(0) => \state1_carry__0_n_7\,
      DI(7 downto 5) => \FSM_sequential_state_reg[3]_0\(6 downto 4),
      DI(4) => \state1_carry__0_i_4_n_0\,
      DI(3 downto 0) => \FSM_sequential_state_reg[3]_0\(3 downto 0),
      O(7 downto 0) => \NLW_state1_carry__0_O_UNCONNECTED\(7 downto 0),
      S(7) => \state1_carry__0_i_9_n_0\,
      S(6 downto 5) => S(4 downto 3),
      S(4) => \state1_carry__0_i_12_n_0\,
      S(3 downto 2) => S(2 downto 1),
      S(1) => \state1_carry__0_i_15_n_0\,
      S(0) => S(0)
    );
\state1_carry__0_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => \i_reg_n_0_[24]\,
      I1 => \state1_carry__0_1\(10),
      I2 => \state1_carry__0_1\(9),
      I3 => \i_reg_n_0_[25]\,
      O => \state1_carry__0_i_12_n_0\
    );
\state1_carry__0_i_15\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => \^q\(14),
      I1 => \state1_carry__0_1\(8),
      I2 => \state1_carry__0_1\(7),
      I3 => \^q\(15),
      O => \state1_carry__0_i_15_n_0\
    );
\state1_carry__0_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => \state1_carry__0_1\(9),
      I1 => \i_reg_n_0_[24]\,
      I2 => \i_reg_n_0_[25]\,
      I3 => \state1_carry__0_1\(10),
      O => \state1_carry__0_i_4_n_0\
    );
\state1_carry__0_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => \^q\(24),
      I1 => \state1_carry__0_1\(12),
      I2 => \^q\(25),
      I3 => \state1_carry__0_1\(11),
      O => \state1_carry__0_i_9_n_0\
    );
state1_carry_i_10: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => \^q\(8),
      I1 => \state1_carry__0_1\(6),
      I2 => \state1_carry__0_1\(5),
      I3 => \^q\(9),
      O => state1_carry_i_10_n_0
    );
state1_carry_i_13: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8421"
    )
        port map (
      I0 => \^q\(2),
      I1 => \state1_carry__0_1\(4),
      I2 => \state1_carry__0_1\(3),
      I3 => \^q\(3),
      O => state1_carry_i_13_n_0
    );
state1_carry_i_15: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => \i_reg_n_0_[3]\,
      I1 => \state1_carry__0_1\(1),
      I2 => \i_reg_n_0_[2]\,
      I3 => \state1_carry__0_1\(2),
      O => state1_carry_i_15_n_0
    );
state1_carry_i_16: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4182"
    )
        port map (
      I0 => state1_carry_0(0),
      I1 => \state1_carry__0_1\(0),
      I2 => \i_reg_n_0_[1]\,
      I3 => \i_reg_n_0_[0]\,
      O => state1_carry_i_16_n_0
    );
state1_carry_i_7: unisim.vcomponents.LUT4
    generic map(
      INIT => X"20BA"
    )
        port map (
      I0 => \i_reg_n_0_[3]\,
      I1 => \state1_carry__0_1\(1),
      I2 => \i_reg_n_0_[2]\,
      I3 => \state1_carry__0_1\(2),
      O => state1_carry_i_7_n_0
    );
state1_carry_i_8: unisim.vcomponents.LUT4
    generic map(
      INIT => X"80F8"
    )
        port map (
      I0 => \i_reg_n_0_[0]\,
      I1 => state1_carry_0(0),
      I2 => \i_reg_n_0_[1]\,
      I3 => \state1_carry__0_1\(0),
      O => state1_carry_i_8_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top_slave_lite_v1_0_S00_AXI is
  port (
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    axi_awready_reg_0 : out STD_LOGIC;
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    axi_rvalid_reg_0 : out STD_LOGIC;
    axi_arready_reg_0 : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 1 downto 0 );
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    S : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \slv_reg6_reg[30]_0\ : out STD_LOGIC_VECTOR ( 30 downto 0 );
    \slv_reg6_reg[16]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \slv_reg6_reg[24]_0\ : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \slv_reg6_reg[31]_0\ : out STD_LOGIC_VECTOR ( 6 downto 0 );
    \word_count_reg[31]\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \i_reg[28]\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    DI : out STD_LOGIC_VECTOR ( 2 downto 0 );
    start_compute : out STD_LOGIC;
    start_read : out STD_LOGIC;
    start_write : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    \FSM_sequential_state_reg[2]\ : out STD_LOGIC;
    \slv_reg0_reg[1]_0\ : out STD_LOGIC;
    instr_ready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    stream_ready : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 2 downto 0 );
    bram_done : in STD_LOGIC;
    compute_done : in STD_LOGIC;
    O : in STD_LOGIC_VECTOR ( 5 downto 0 );
    \state2_carry__0\ : in STD_LOGIC_VECTOR ( 4 downto 0 );
    \state1_carry__0\ : in STD_LOGIC_VECTOR ( 5 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top_slave_lite_v1_0_S00_AXI;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top_slave_lite_v1_0_S00_AXI is
  signal \FSM_sequential_state[2]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state[2]_i_4_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state_read[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_state_write[1]_i_1_n_0\ : STD_LOGIC;
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \axi_araddr[4]_i_1_n_0\ : STD_LOGIC;
  signal axi_arready_i_1_n_0 : STD_LOGIC;
  signal \^axi_arready_reg_0\ : STD_LOGIC;
  signal axi_awaddr : STD_LOGIC;
  signal \axi_awaddr_reg_n_0_[2]\ : STD_LOGIC;
  signal \axi_awaddr_reg_n_0_[3]\ : STD_LOGIC;
  signal \axi_awaddr_reg_n_0_[4]\ : STD_LOGIC;
  signal \axi_awready0__0\ : STD_LOGIC;
  signal axi_awready_i_2_n_0 : STD_LOGIC;
  signal \^axi_awready_reg_0\ : STD_LOGIC;
  signal axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal \^axi_rvalid_reg_0\ : STD_LOGIC;
  signal axi_wready_i_1_n_0 : STD_LOGIC;
  signal p_1_in : STD_LOGIC_VECTOR ( 31 downto 7 );
  signal \^s00_axi_bvalid\ : STD_LOGIC;
  signal \s00_axi_rdata[0]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[0]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[10]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[11]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[12]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[13]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[14]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[15]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[16]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[17]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[18]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[19]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[1]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[20]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[21]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[22]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[23]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[24]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[25]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[26]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[27]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[28]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[29]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[2]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[30]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[31]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[3]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[4]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[5]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[6]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[7]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[8]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \s00_axi_rdata[9]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \^s00_axi_wready\ : STD_LOGIC;
  signal sel0 : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal slv_reg0 : STD_LOGIC_VECTOR ( 31 downto 2 );
  signal \slv_reg0[31]_i_2_n_0\ : STD_LOGIC;
  signal slv_reg0_bus : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal slv_reg1_reg : STD_LOGIC_VECTOR ( 0 to 0 );
  signal slv_reg2_reg : STD_LOGIC_VECTOR ( 0 to 0 );
  signal slv_reg3 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg3[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[31]_i_2_n_0\ : STD_LOGIC;
  signal \slv_reg3[7]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg4 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg4[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg4[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg4[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg4[7]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg5 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg5[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg5[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg5[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg5[31]_i_2_n_0\ : STD_LOGIC;
  signal \slv_reg5[7]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg6 : STD_LOGIC_VECTOR ( 31 to 31 );
  signal \slv_reg6[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg6[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg6[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg6[31]_i_2_n_0\ : STD_LOGIC;
  signal \slv_reg6[7]_i_1_n_0\ : STD_LOGIC;
  signal \^slv_reg6_reg[30]_0\ : STD_LOGIC_VECTOR ( 30 downto 0 );
  signal state_read : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \state_read__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal state_write : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \state_write__0\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_state[0]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \FSM_sequential_state[1]_i_1\ : label is "soft_lutpair0";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_read_reg[0]\ : label is "Idle:00,Rdata:10,Raddr:01";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_read_reg[1]\ : label is "Idle:00,Rdata:10,Raddr:01";
  attribute SOFT_HLUTNM of \FSM_sequential_state_write[0]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \FSM_sequential_state_write[1]_i_2\ : label is "soft_lutpair3";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_write_reg[0]\ : label is "Idle:00,Wdata:10,Waddr:01";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_write_reg[1]\ : label is "Idle:00,Wdata:10,Waddr:01";
  attribute SOFT_HLUTNM of axi_awready_i_2 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of axi_bvalid_i_2 : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \slv_reg0[31]_i_2\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \slv_reg6[31]_i_2\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of start_compute_i_1 : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of start_read_i_1 : label is "soft_lutpair1";
begin
  SR(0) <= \^sr\(0);
  axi_arready_reg_0 <= \^axi_arready_reg_0\;
  axi_awready_reg_0 <= \^axi_awready_reg_0\;
  axi_rvalid_reg_0 <= \^axi_rvalid_reg_0\;
  s00_axi_bvalid <= \^s00_axi_bvalid\;
  s00_axi_wready <= \^s00_axi_wready\;
  \slv_reg6_reg[30]_0\(30 downto 0) <= \^slv_reg6_reg[30]_0\(30 downto 0);
\FSM_sequential_state[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000045"
    )
        port map (
      I0 => Q(0),
      I1 => slv_reg0_bus(0),
      I2 => slv_reg0_bus(1),
      I3 => Q(1),
      I4 => Q(2),
      O => D(0)
    );
\FSM_sequential_state[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000405"
    )
        port map (
      I0 => Q(0),
      I1 => slv_reg0_bus(1),
      I2 => Q(1),
      I3 => slv_reg0_bus(0),
      I4 => Q(2),
      O => D(1)
    );
\FSM_sequential_state[2]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"404040400505050A"
    )
        port map (
      I0 => Q(2),
      I1 => compute_done,
      I2 => Q(1),
      I3 => slv_reg0_bus(0),
      I4 => slv_reg0_bus(1),
      I5 => Q(0),
      O => \FSM_sequential_state[2]_i_3_n_0\
    );
\FSM_sequential_state[2]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"455545554555455A"
    )
        port map (
      I0 => Q(2),
      I1 => compute_done,
      I2 => Q(0),
      I3 => Q(1),
      I4 => slv_reg0_bus(0),
      I5 => slv_reg0_bus(1),
      O => \FSM_sequential_state[2]_i_4_n_0\
    );
\FSM_sequential_state_read[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"07070707FF0F0F0F"
    )
        port map (
      I0 => s00_axi_arvalid,
      I1 => \^axi_arready_reg_0\,
      I2 => state_read(1),
      I3 => s00_axi_rready,
      I4 => \^axi_rvalid_reg_0\,
      I5 => state_read(0),
      O => \state_read__0\(0)
    );
\FSM_sequential_state_read[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => state_read(0),
      I1 => state_read(1),
      O => \FSM_sequential_state_read[1]_i_1_n_0\
    );
\FSM_sequential_state_read[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00800F800F800F80"
    )
        port map (
      I0 => \^axi_arready_reg_0\,
      I1 => s00_axi_arvalid,
      I2 => state_read(0),
      I3 => state_read(1),
      I4 => s00_axi_rready,
      I5 => \^axi_rvalid_reg_0\,
      O => \state_read__0\(1)
    );
\FSM_sequential_state_read_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state_read[1]_i_1_n_0\,
      D => \state_read__0\(0),
      Q => state_read(0),
      R => \^sr\(0)
    );
\FSM_sequential_state_read_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state_read[1]_i_1_n_0\,
      D => \state_read__0\(1),
      Q => state_read(1),
      R => \^sr\(0)
    );
\FSM_sequential_state_reg[2]_i_1\: unisim.vcomponents.MUXF7
     port map (
      I0 => \FSM_sequential_state[2]_i_3_n_0\,
      I1 => \FSM_sequential_state[2]_i_4_n_0\,
      O => E(0),
      S => bram_done
    );
\FSM_sequential_state_write[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0F07FF0F"
    )
        port map (
      I0 => \^axi_awready_reg_0\,
      I1 => s00_axi_awvalid,
      I2 => state_write(1),
      I3 => s00_axi_wvalid,
      I4 => state_write(0),
      O => \state_write__0\(0)
    );
\FSM_sequential_state_write[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => state_write(0),
      I1 => state_write(1),
      O => \FSM_sequential_state_write[1]_i_1_n_0\
    );
\FSM_sequential_state_write[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000F80"
    )
        port map (
      I0 => s00_axi_awvalid,
      I1 => \^axi_awready_reg_0\,
      I2 => state_write(0),
      I3 => state_write(1),
      I4 => s00_axi_wvalid,
      O => \state_write__0\(1)
    );
\FSM_sequential_state_write_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state_write[1]_i_1_n_0\,
      D => \state_write__0\(0),
      Q => state_write(0),
      R => \^sr\(0)
    );
\FSM_sequential_state_write_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \FSM_sequential_state_write[1]_i_1_n_0\,
      D => \state_write__0\(1),
      Q => state_write(1),
      R => \^sr\(0)
    );
\axi_araddr[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00008000"
    )
        port map (
      I0 => s00_axi_aresetn,
      I1 => \^axi_arready_reg_0\,
      I2 => s00_axi_arvalid,
      I3 => state_read(0),
      I4 => state_read(1),
      O => \axi_araddr[4]_i_1_n_0\
    );
\axi_araddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \axi_araddr[4]_i_1_n_0\,
      D => s00_axi_araddr(0),
      Q => sel0(0),
      R => '0'
    );
\axi_araddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \axi_araddr[4]_i_1_n_0\,
      D => s00_axi_araddr(1),
      Q => sel0(1),
      R => '0'
    );
\axi_araddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \axi_araddr[4]_i_1_n_0\,
      D => s00_axi_araddr(2),
      Q => sel0(2),
      R => '0'
    );
axi_arready_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"C4C4C4C4FFCFCFCF"
    )
        port map (
      I0 => s00_axi_arvalid,
      I1 => \^axi_arready_reg_0\,
      I2 => state_read(1),
      I3 => s00_axi_rready,
      I4 => \^axi_rvalid_reg_0\,
      I5 => state_read(0),
      O => axi_arready_i_1_n_0
    );
axi_arready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_arready_i_1_n_0,
      Q => \^axi_arready_reg_0\,
      R => \^sr\(0)
    );
\axi_awaddr[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => state_write(1),
      I1 => state_write(0),
      I2 => s00_axi_awvalid,
      I3 => \^axi_awready_reg_0\,
      O => axi_awaddr
    );
\axi_awaddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => axi_awaddr,
      D => s00_axi_awaddr(0),
      Q => \axi_awaddr_reg_n_0_[2]\,
      R => \^sr\(0)
    );
\axi_awaddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => axi_awaddr,
      D => s00_axi_awaddr(1),
      Q => \axi_awaddr_reg_n_0_[3]\,
      R => \^sr\(0)
    );
\axi_awaddr_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => axi_awaddr,
      D => s00_axi_awaddr(2),
      Q => \axi_awaddr_reg_n_0_[4]\,
      R => \^sr\(0)
    );
axi_awready_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s00_axi_aresetn,
      O => \^sr\(0)
    );
axi_awready_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CCC4FFCF"
    )
        port map (
      I0 => s00_axi_awvalid,
      I1 => \^axi_awready_reg_0\,
      I2 => state_write(1),
      I3 => s00_axi_wvalid,
      I4 => state_write(0),
      O => axi_awready_i_2_n_0
    );
axi_awready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_awready_i_2_n_0,
      Q => \^axi_awready_reg_0\,
      R => \^sr\(0)
    );
axi_bvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFF3838C3FF0000"
    )
        port map (
      I0 => \axi_awready0__0\,
      I1 => state_write(0),
      I2 => state_write(1),
      I3 => s00_axi_bready,
      I4 => \^s00_axi_bvalid\,
      I5 => s00_axi_wvalid,
      O => axi_bvalid_i_1_n_0
    );
axi_bvalid_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s00_axi_awvalid,
      I1 => \^axi_awready_reg_0\,
      O => \axi_awready0__0\
    );
axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_bvalid_i_1_n_0,
      Q => \^s00_axi_bvalid\,
      R => \^sr\(0)
    );
axi_rvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFFFFF00800080"
    )
        port map (
      I0 => \^axi_arready_reg_0\,
      I1 => s00_axi_arvalid,
      I2 => state_read(0),
      I3 => state_read(1),
      I4 => s00_axi_rready,
      I5 => \^axi_rvalid_reg_0\,
      O => axi_rvalid_i_1_n_0
    );
axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_rvalid_i_1_n_0,
      Q => \^axi_rvalid_reg_0\,
      R => \^sr\(0)
    );
axi_wready_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F1"
    )
        port map (
      I0 => state_write(1),
      I1 => state_write(0),
      I2 => \^s00_axi_wready\,
      O => axi_wready_i_1_n_0
    );
axi_wready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_wready_i_1_n_0,
      Q => \^s00_axi_wready\,
      R => \^sr\(0)
    );
instr_ready_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFAB000000AB"
    )
        port map (
      I0 => Q(2),
      I1 => slv_reg0_bus(1),
      I2 => slv_reg0_bus(0),
      I3 => Q(1),
      I4 => Q(0),
      I5 => instr_ready,
      O => \FSM_sequential_state_reg[2]\
    );
\s00_axi_rdata[0]_INST_0\: unisim.vcomponents.MUXF7
     port map (
      I0 => \s00_axi_rdata[0]_INST_0_i_1_n_0\,
      I1 => \s00_axi_rdata[0]_INST_0_i_2_n_0\,
      O => s00_axi_rdata(0),
      S => sel0(2)
    );
\s00_axi_rdata[0]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AFA0CFCFAFA0C0C0"
    )
        port map (
      I0 => slv_reg3(0),
      I1 => slv_reg2_reg(0),
      I2 => sel0(1),
      I3 => slv_reg1_reg(0),
      I4 => sel0(0),
      I5 => slv_reg0_bus(0),
      O => \s00_axi_rdata[0]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[0]_INST_0_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(0),
      I1 => sel0(1),
      I2 => slv_reg5(0),
      I3 => sel0(0),
      I4 => slv_reg4(0),
      O => \s00_axi_rdata[0]_INST_0_i_2_n_0\
    );
\s00_axi_rdata[10]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[10]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(10),
      I3 => sel0(1),
      I4 => slv_reg0(10),
      I5 => sel0(0),
      O => s00_axi_rdata(10)
    );
\s00_axi_rdata[10]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(10),
      I1 => sel0(1),
      I2 => slv_reg5(10),
      I3 => sel0(0),
      I4 => slv_reg4(10),
      O => \s00_axi_rdata[10]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[11]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[11]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(11),
      I3 => sel0(1),
      I4 => slv_reg0(11),
      I5 => sel0(0),
      O => s00_axi_rdata(11)
    );
\s00_axi_rdata[11]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(11),
      I1 => sel0(1),
      I2 => slv_reg5(11),
      I3 => sel0(0),
      I4 => slv_reg4(11),
      O => \s00_axi_rdata[11]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[12]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[12]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(12),
      I3 => sel0(1),
      I4 => slv_reg0(12),
      I5 => sel0(0),
      O => s00_axi_rdata(12)
    );
\s00_axi_rdata[12]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(12),
      I1 => sel0(1),
      I2 => slv_reg5(12),
      I3 => sel0(0),
      I4 => slv_reg4(12),
      O => \s00_axi_rdata[12]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[13]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[13]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(13),
      I3 => sel0(1),
      I4 => slv_reg0(13),
      I5 => sel0(0),
      O => s00_axi_rdata(13)
    );
\s00_axi_rdata[13]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(13),
      I1 => sel0(1),
      I2 => slv_reg5(13),
      I3 => sel0(0),
      I4 => slv_reg4(13),
      O => \s00_axi_rdata[13]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[14]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[14]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(14),
      I3 => sel0(1),
      I4 => slv_reg0(14),
      I5 => sel0(0),
      O => s00_axi_rdata(14)
    );
\s00_axi_rdata[14]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(14),
      I1 => sel0(1),
      I2 => slv_reg5(14),
      I3 => sel0(0),
      I4 => slv_reg4(14),
      O => \s00_axi_rdata[14]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[15]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[15]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(15),
      I3 => sel0(1),
      I4 => slv_reg0(15),
      I5 => sel0(0),
      O => s00_axi_rdata(15)
    );
\s00_axi_rdata[15]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(15),
      I1 => sel0(1),
      I2 => slv_reg5(15),
      I3 => sel0(0),
      I4 => slv_reg4(15),
      O => \s00_axi_rdata[15]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[16]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[16]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(16),
      I3 => sel0(1),
      I4 => slv_reg0(16),
      I5 => sel0(0),
      O => s00_axi_rdata(16)
    );
\s00_axi_rdata[16]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(16),
      I1 => sel0(1),
      I2 => slv_reg5(16),
      I3 => sel0(0),
      I4 => slv_reg4(16),
      O => \s00_axi_rdata[16]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[17]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[17]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(17),
      I3 => sel0(1),
      I4 => slv_reg0(17),
      I5 => sel0(0),
      O => s00_axi_rdata(17)
    );
\s00_axi_rdata[17]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(17),
      I1 => sel0(1),
      I2 => slv_reg5(17),
      I3 => sel0(0),
      I4 => slv_reg4(17),
      O => \s00_axi_rdata[17]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[18]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[18]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(18),
      I3 => sel0(1),
      I4 => slv_reg0(18),
      I5 => sel0(0),
      O => s00_axi_rdata(18)
    );
\s00_axi_rdata[18]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(18),
      I1 => sel0(1),
      I2 => slv_reg5(18),
      I3 => sel0(0),
      I4 => slv_reg4(18),
      O => \s00_axi_rdata[18]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[19]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[19]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(19),
      I3 => sel0(1),
      I4 => slv_reg0(19),
      I5 => sel0(0),
      O => s00_axi_rdata(19)
    );
\s00_axi_rdata[19]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(19),
      I1 => sel0(1),
      I2 => slv_reg5(19),
      I3 => sel0(0),
      I4 => slv_reg4(19),
      O => \s00_axi_rdata[19]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[1]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[1]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(1),
      I3 => sel0(1),
      I4 => slv_reg0_bus(1),
      I5 => sel0(0),
      O => s00_axi_rdata(1)
    );
\s00_axi_rdata[1]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(1),
      I1 => sel0(1),
      I2 => slv_reg5(1),
      I3 => sel0(0),
      I4 => slv_reg4(1),
      O => \s00_axi_rdata[1]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[20]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[20]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(20),
      I3 => sel0(1),
      I4 => slv_reg0(20),
      I5 => sel0(0),
      O => s00_axi_rdata(20)
    );
\s00_axi_rdata[20]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(20),
      I1 => sel0(1),
      I2 => slv_reg5(20),
      I3 => sel0(0),
      I4 => slv_reg4(20),
      O => \s00_axi_rdata[20]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[21]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[21]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(21),
      I3 => sel0(1),
      I4 => slv_reg0(21),
      I5 => sel0(0),
      O => s00_axi_rdata(21)
    );
\s00_axi_rdata[21]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(21),
      I1 => sel0(1),
      I2 => slv_reg5(21),
      I3 => sel0(0),
      I4 => slv_reg4(21),
      O => \s00_axi_rdata[21]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[22]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[22]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(22),
      I3 => sel0(1),
      I4 => slv_reg0(22),
      I5 => sel0(0),
      O => s00_axi_rdata(22)
    );
\s00_axi_rdata[22]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(22),
      I1 => sel0(1),
      I2 => slv_reg5(22),
      I3 => sel0(0),
      I4 => slv_reg4(22),
      O => \s00_axi_rdata[22]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[23]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[23]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(23),
      I3 => sel0(1),
      I4 => slv_reg0(23),
      I5 => sel0(0),
      O => s00_axi_rdata(23)
    );
\s00_axi_rdata[23]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(23),
      I1 => sel0(1),
      I2 => slv_reg5(23),
      I3 => sel0(0),
      I4 => slv_reg4(23),
      O => \s00_axi_rdata[23]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[24]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[24]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(24),
      I3 => sel0(1),
      I4 => slv_reg0(24),
      I5 => sel0(0),
      O => s00_axi_rdata(24)
    );
\s00_axi_rdata[24]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(24),
      I1 => sel0(1),
      I2 => slv_reg5(24),
      I3 => sel0(0),
      I4 => slv_reg4(24),
      O => \s00_axi_rdata[24]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[25]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[25]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(25),
      I3 => sel0(1),
      I4 => slv_reg0(25),
      I5 => sel0(0),
      O => s00_axi_rdata(25)
    );
\s00_axi_rdata[25]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(25),
      I1 => sel0(1),
      I2 => slv_reg5(25),
      I3 => sel0(0),
      I4 => slv_reg4(25),
      O => \s00_axi_rdata[25]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[26]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[26]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(26),
      I3 => sel0(1),
      I4 => slv_reg0(26),
      I5 => sel0(0),
      O => s00_axi_rdata(26)
    );
\s00_axi_rdata[26]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(26),
      I1 => sel0(1),
      I2 => slv_reg5(26),
      I3 => sel0(0),
      I4 => slv_reg4(26),
      O => \s00_axi_rdata[26]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[27]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[27]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(27),
      I3 => sel0(1),
      I4 => slv_reg0(27),
      I5 => sel0(0),
      O => s00_axi_rdata(27)
    );
\s00_axi_rdata[27]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(27),
      I1 => sel0(1),
      I2 => slv_reg5(27),
      I3 => sel0(0),
      I4 => slv_reg4(27),
      O => \s00_axi_rdata[27]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[28]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[28]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(28),
      I3 => sel0(1),
      I4 => slv_reg0(28),
      I5 => sel0(0),
      O => s00_axi_rdata(28)
    );
\s00_axi_rdata[28]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(28),
      I1 => sel0(1),
      I2 => slv_reg5(28),
      I3 => sel0(0),
      I4 => slv_reg4(28),
      O => \s00_axi_rdata[28]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[29]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[29]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(29),
      I3 => sel0(1),
      I4 => slv_reg0(29),
      I5 => sel0(0),
      O => s00_axi_rdata(29)
    );
\s00_axi_rdata[29]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(29),
      I1 => sel0(1),
      I2 => slv_reg5(29),
      I3 => sel0(0),
      I4 => slv_reg4(29),
      O => \s00_axi_rdata[29]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[2]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[2]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(2),
      I3 => sel0(1),
      I4 => slv_reg0(2),
      I5 => sel0(0),
      O => s00_axi_rdata(2)
    );
\s00_axi_rdata[2]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(2),
      I1 => sel0(1),
      I2 => slv_reg5(2),
      I3 => sel0(0),
      I4 => slv_reg4(2),
      O => \s00_axi_rdata[2]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[30]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[30]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(30),
      I3 => sel0(1),
      I4 => slv_reg0(30),
      I5 => sel0(0),
      O => s00_axi_rdata(30)
    );
\s00_axi_rdata[30]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(30),
      I1 => sel0(1),
      I2 => slv_reg5(30),
      I3 => sel0(0),
      I4 => slv_reg4(30),
      O => \s00_axi_rdata[30]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[31]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[31]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(31),
      I3 => sel0(1),
      I4 => slv_reg0(31),
      I5 => sel0(0),
      O => s00_axi_rdata(31)
    );
\s00_axi_rdata[31]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => slv_reg6(31),
      I1 => sel0(1),
      I2 => slv_reg5(31),
      I3 => sel0(0),
      I4 => slv_reg4(31),
      O => \s00_axi_rdata[31]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[3]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[3]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(3),
      I3 => sel0(1),
      I4 => slv_reg0(3),
      I5 => sel0(0),
      O => s00_axi_rdata(3)
    );
\s00_axi_rdata[3]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(3),
      I1 => sel0(1),
      I2 => slv_reg5(3),
      I3 => sel0(0),
      I4 => slv_reg4(3),
      O => \s00_axi_rdata[3]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[4]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[4]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(4),
      I3 => sel0(1),
      I4 => slv_reg0(4),
      I5 => sel0(0),
      O => s00_axi_rdata(4)
    );
\s00_axi_rdata[4]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(4),
      I1 => sel0(1),
      I2 => slv_reg5(4),
      I3 => sel0(0),
      I4 => slv_reg4(4),
      O => \s00_axi_rdata[4]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[5]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[5]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(5),
      I3 => sel0(1),
      I4 => slv_reg0(5),
      I5 => sel0(0),
      O => s00_axi_rdata(5)
    );
\s00_axi_rdata[5]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(5),
      I1 => sel0(1),
      I2 => slv_reg5(5),
      I3 => sel0(0),
      I4 => slv_reg4(5),
      O => \s00_axi_rdata[5]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[6]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[6]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(6),
      I3 => sel0(1),
      I4 => slv_reg0(6),
      I5 => sel0(0),
      O => s00_axi_rdata(6)
    );
\s00_axi_rdata[6]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(6),
      I1 => sel0(1),
      I2 => slv_reg5(6),
      I3 => sel0(0),
      I4 => slv_reg4(6),
      O => \s00_axi_rdata[6]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[7]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[7]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(7),
      I3 => sel0(1),
      I4 => slv_reg0(7),
      I5 => sel0(0),
      O => s00_axi_rdata(7)
    );
\s00_axi_rdata[7]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(7),
      I1 => sel0(1),
      I2 => slv_reg5(7),
      I3 => sel0(0),
      I4 => slv_reg4(7),
      O => \s00_axi_rdata[7]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[8]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[8]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(8),
      I3 => sel0(1),
      I4 => slv_reg0(8),
      I5 => sel0(0),
      O => s00_axi_rdata(8)
    );
\s00_axi_rdata[8]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(8),
      I1 => sel0(1),
      I2 => slv_reg5(8),
      I3 => sel0(0),
      I4 => slv_reg4(8),
      O => \s00_axi_rdata[8]_INST_0_i_1_n_0\
    );
\s00_axi_rdata[9]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B888B88888BB8888"
    )
        port map (
      I0 => \s00_axi_rdata[9]_INST_0_i_1_n_0\,
      I1 => sel0(2),
      I2 => slv_reg3(9),
      I3 => sel0(1),
      I4 => slv_reg0(9),
      I5 => sel0(0),
      O => s00_axi_rdata(9)
    );
\s00_axi_rdata[9]_INST_0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30BB3088"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(9),
      I1 => sel0(1),
      I2 => slv_reg5(9),
      I3 => sel0(0),
      I4 => slv_reg4(9),
      O => \s00_axi_rdata[9]_INST_0_i_1_n_0\
    );
\slv_reg0[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0002220200000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg0[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      I5 => s00_axi_wstrb(1),
      O => p_1_in(15)
    );
\slv_reg0[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0002220200000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg0[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      I5 => s00_axi_wstrb(2),
      O => p_1_in(23)
    );
\slv_reg0[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0002220200000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg0[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      I5 => s00_axi_wstrb(3),
      O => p_1_in(31)
    );
\slv_reg0[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFACCFA"
    )
        port map (
      I0 => \axi_awaddr_reg_n_0_[3]\,
      I1 => s00_axi_awaddr(1),
      I2 => \axi_awaddr_reg_n_0_[2]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(0),
      O => \slv_reg0[31]_i_2_n_0\
    );
\slv_reg0[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0002220200000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg0[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      I5 => s00_axi_wstrb(0),
      O => p_1_in(7)
    );
\slv_reg0_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(7),
      D => s00_axi_wdata(0),
      Q => slv_reg0_bus(0),
      R => \^sr\(0)
    );
\slv_reg0_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(15),
      D => s00_axi_wdata(10),
      Q => slv_reg0(10),
      R => \^sr\(0)
    );
\slv_reg0_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(15),
      D => s00_axi_wdata(11),
      Q => slv_reg0(11),
      R => \^sr\(0)
    );
\slv_reg0_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(15),
      D => s00_axi_wdata(12),
      Q => slv_reg0(12),
      R => \^sr\(0)
    );
\slv_reg0_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(15),
      D => s00_axi_wdata(13),
      Q => slv_reg0(13),
      R => \^sr\(0)
    );
\slv_reg0_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(15),
      D => s00_axi_wdata(14),
      Q => slv_reg0(14),
      R => \^sr\(0)
    );
\slv_reg0_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(15),
      D => s00_axi_wdata(15),
      Q => slv_reg0(15),
      R => \^sr\(0)
    );
\slv_reg0_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(23),
      D => s00_axi_wdata(16),
      Q => slv_reg0(16),
      R => \^sr\(0)
    );
\slv_reg0_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(23),
      D => s00_axi_wdata(17),
      Q => slv_reg0(17),
      R => \^sr\(0)
    );
\slv_reg0_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(23),
      D => s00_axi_wdata(18),
      Q => slv_reg0(18),
      R => \^sr\(0)
    );
\slv_reg0_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(23),
      D => s00_axi_wdata(19),
      Q => slv_reg0(19),
      R => \^sr\(0)
    );
\slv_reg0_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(7),
      D => s00_axi_wdata(1),
      Q => slv_reg0_bus(1),
      R => \^sr\(0)
    );
\slv_reg0_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(23),
      D => s00_axi_wdata(20),
      Q => slv_reg0(20),
      R => \^sr\(0)
    );
\slv_reg0_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(23),
      D => s00_axi_wdata(21),
      Q => slv_reg0(21),
      R => \^sr\(0)
    );
\slv_reg0_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(23),
      D => s00_axi_wdata(22),
      Q => slv_reg0(22),
      R => \^sr\(0)
    );
\slv_reg0_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(23),
      D => s00_axi_wdata(23),
      Q => slv_reg0(23),
      R => \^sr\(0)
    );
\slv_reg0_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(31),
      D => s00_axi_wdata(24),
      Q => slv_reg0(24),
      R => \^sr\(0)
    );
\slv_reg0_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(31),
      D => s00_axi_wdata(25),
      Q => slv_reg0(25),
      R => \^sr\(0)
    );
\slv_reg0_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(31),
      D => s00_axi_wdata(26),
      Q => slv_reg0(26),
      R => \^sr\(0)
    );
\slv_reg0_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(31),
      D => s00_axi_wdata(27),
      Q => slv_reg0(27),
      R => \^sr\(0)
    );
\slv_reg0_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(31),
      D => s00_axi_wdata(28),
      Q => slv_reg0(28),
      R => \^sr\(0)
    );
\slv_reg0_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(31),
      D => s00_axi_wdata(29),
      Q => slv_reg0(29),
      R => \^sr\(0)
    );
\slv_reg0_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(7),
      D => s00_axi_wdata(2),
      Q => slv_reg0(2),
      R => \^sr\(0)
    );
\slv_reg0_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(31),
      D => s00_axi_wdata(30),
      Q => slv_reg0(30),
      R => \^sr\(0)
    );
\slv_reg0_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(31),
      D => s00_axi_wdata(31),
      Q => slv_reg0(31),
      R => \^sr\(0)
    );
\slv_reg0_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(7),
      D => s00_axi_wdata(3),
      Q => slv_reg0(3),
      R => \^sr\(0)
    );
\slv_reg0_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(7),
      D => s00_axi_wdata(4),
      Q => slv_reg0(4),
      R => \^sr\(0)
    );
\slv_reg0_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(7),
      D => s00_axi_wdata(5),
      Q => slv_reg0(5),
      R => \^sr\(0)
    );
\slv_reg0_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(7),
      D => s00_axi_wdata(6),
      Q => slv_reg0(6),
      R => \^sr\(0)
    );
\slv_reg0_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(7),
      D => s00_axi_wdata(7),
      Q => slv_reg0(7),
      R => \^sr\(0)
    );
\slv_reg0_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(15),
      D => s00_axi_wdata(8),
      Q => slv_reg0(8),
      R => \^sr\(0)
    );
\slv_reg0_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => p_1_in(15),
      D => s00_axi_wdata(9),
      Q => slv_reg0(9),
      R => \^sr\(0)
    );
\slv_reg1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => instr_ready,
      Q => slv_reg1_reg(0),
      R => \^sr\(0)
    );
\slv_reg2_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => stream_ready,
      Q => slv_reg2_reg(0),
      R => \^sr\(0)
    );
\slv_reg3[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2220002000000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg3[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[2]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(0),
      I5 => s00_axi_wstrb(1),
      O => \slv_reg3[15]_i_1_n_0\
    );
\slv_reg3[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2220002000000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg3[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[2]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(0),
      I5 => s00_axi_wstrb(2),
      O => \slv_reg3[23]_i_1_n_0\
    );
\slv_reg3[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2220002000000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg3[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[2]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(0),
      I5 => s00_axi_wstrb(3),
      O => \slv_reg3[31]_i_1_n_0\
    );
\slv_reg3[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CCAFFFAF"
    )
        port map (
      I0 => \axi_awaddr_reg_n_0_[4]\,
      I1 => s00_axi_awaddr(2),
      I2 => \axi_awaddr_reg_n_0_[3]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(1),
      O => \slv_reg3[31]_i_2_n_0\
    );
\slv_reg3[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2220002000000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg3[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[2]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(0),
      I5 => s00_axi_wstrb(0),
      O => \slv_reg3[7]_i_1_n_0\
    );
\slv_reg3_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg3(0),
      R => \^sr\(0)
    );
\slv_reg3_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg3(10),
      R => \^sr\(0)
    );
\slv_reg3_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg3(11),
      R => \^sr\(0)
    );
\slv_reg3_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg3(12),
      R => \^sr\(0)
    );
\slv_reg3_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg3(13),
      R => \^sr\(0)
    );
\slv_reg3_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg3(14),
      R => \^sr\(0)
    );
\slv_reg3_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg3(15),
      R => \^sr\(0)
    );
\slv_reg3_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg3(16),
      R => \^sr\(0)
    );
\slv_reg3_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg3(17),
      R => \^sr\(0)
    );
\slv_reg3_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg3(18),
      R => \^sr\(0)
    );
\slv_reg3_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg3(19),
      R => \^sr\(0)
    );
\slv_reg3_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg3(1),
      R => \^sr\(0)
    );
\slv_reg3_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg3(20),
      R => \^sr\(0)
    );
\slv_reg3_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg3(21),
      R => \^sr\(0)
    );
\slv_reg3_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg3(22),
      R => \^sr\(0)
    );
\slv_reg3_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg3(23),
      R => \^sr\(0)
    );
\slv_reg3_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg3(24),
      R => \^sr\(0)
    );
\slv_reg3_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg3(25),
      R => \^sr\(0)
    );
\slv_reg3_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg3(26),
      R => \^sr\(0)
    );
\slv_reg3_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg3(27),
      R => \^sr\(0)
    );
\slv_reg3_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg3(28),
      R => \^sr\(0)
    );
\slv_reg3_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg3(29),
      R => \^sr\(0)
    );
\slv_reg3_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg3(2),
      R => \^sr\(0)
    );
\slv_reg3_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg3(30),
      R => \^sr\(0)
    );
\slv_reg3_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg3(31),
      R => \^sr\(0)
    );
\slv_reg3_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg3(3),
      R => \^sr\(0)
    );
\slv_reg3_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg3(4),
      R => \^sr\(0)
    );
\slv_reg3_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg3(5),
      R => \^sr\(0)
    );
\slv_reg3_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg3(6),
      R => \^sr\(0)
    );
\slv_reg3_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg3(7),
      R => \^sr\(0)
    );
\slv_reg3_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg3(8),
      R => \^sr\(0)
    );
\slv_reg3_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg3(9),
      R => \^sr\(0)
    );
\slv_reg4[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2220002000000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg0[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      I5 => s00_axi_wstrb(1),
      O => \slv_reg4[15]_i_1_n_0\
    );
\slv_reg4[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2220002000000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg0[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      I5 => s00_axi_wstrb(2),
      O => \slv_reg4[23]_i_1_n_0\
    );
\slv_reg4[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2220002000000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg0[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      I5 => s00_axi_wstrb(3),
      O => \slv_reg4[31]_i_1_n_0\
    );
\slv_reg4[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2220002000000000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg0[31]_i_2_n_0\,
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      I5 => s00_axi_wstrb(0),
      O => \slv_reg4[7]_i_1_n_0\
    );
\slv_reg4_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg4(0),
      R => \^sr\(0)
    );
\slv_reg4_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg4(10),
      R => \^sr\(0)
    );
\slv_reg4_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg4(11),
      R => \^sr\(0)
    );
\slv_reg4_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg4(12),
      R => \^sr\(0)
    );
\slv_reg4_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg4(13),
      R => \^sr\(0)
    );
\slv_reg4_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg4(14),
      R => \^sr\(0)
    );
\slv_reg4_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg4(15),
      R => \^sr\(0)
    );
\slv_reg4_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg4(16),
      R => \^sr\(0)
    );
\slv_reg4_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg4(17),
      R => \^sr\(0)
    );
\slv_reg4_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg4(18),
      R => \^sr\(0)
    );
\slv_reg4_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg4(19),
      R => \^sr\(0)
    );
\slv_reg4_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg4(1),
      R => \^sr\(0)
    );
\slv_reg4_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg4(20),
      R => \^sr\(0)
    );
\slv_reg4_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg4(21),
      R => \^sr\(0)
    );
\slv_reg4_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg4(22),
      R => \^sr\(0)
    );
\slv_reg4_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg4(23),
      R => \^sr\(0)
    );
\slv_reg4_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg4(24),
      R => \^sr\(0)
    );
\slv_reg4_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg4(25),
      R => \^sr\(0)
    );
\slv_reg4_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg4(26),
      R => \^sr\(0)
    );
\slv_reg4_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg4(27),
      R => \^sr\(0)
    );
\slv_reg4_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg4(28),
      R => \^sr\(0)
    );
\slv_reg4_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg4(29),
      R => \^sr\(0)
    );
\slv_reg4_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg4(2),
      R => \^sr\(0)
    );
\slv_reg4_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg4(30),
      R => \^sr\(0)
    );
\slv_reg4_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg4(31),
      R => \^sr\(0)
    );
\slv_reg4_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg4(3),
      R => \^sr\(0)
    );
\slv_reg4_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg4(4),
      R => \^sr\(0)
    );
\slv_reg4_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg4(5),
      R => \^sr\(0)
    );
\slv_reg4_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg4(6),
      R => \^sr\(0)
    );
\slv_reg4_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg4(7),
      R => \^sr\(0)
    );
\slv_reg4_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg4(8),
      R => \^sr\(0)
    );
\slv_reg4_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg4[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg4(9),
      R => \^sr\(0)
    );
\slv_reg5[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A20000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \axi_awaddr_reg_n_0_[3]\,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_awaddr(1),
      I4 => s00_axi_wstrb(1),
      I5 => \slv_reg5[31]_i_2_n_0\,
      O => \slv_reg5[15]_i_1_n_0\
    );
\slv_reg5[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A20000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \axi_awaddr_reg_n_0_[3]\,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_awaddr(1),
      I4 => s00_axi_wstrb(2),
      I5 => \slv_reg5[31]_i_2_n_0\,
      O => \slv_reg5[23]_i_1_n_0\
    );
\slv_reg5[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A20000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \axi_awaddr_reg_n_0_[3]\,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_awaddr(1),
      I4 => s00_axi_wstrb(3),
      I5 => \slv_reg5[31]_i_2_n_0\,
      O => \slv_reg5[31]_i_1_n_0\
    );
\slv_reg5[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"335FFF5F"
    )
        port map (
      I0 => \axi_awaddr_reg_n_0_[2]\,
      I1 => s00_axi_awaddr(0),
      I2 => \axi_awaddr_reg_n_0_[4]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(2),
      O => \slv_reg5[31]_i_2_n_0\
    );
\slv_reg5[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000002A20000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \axi_awaddr_reg_n_0_[3]\,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_awaddr(1),
      I4 => s00_axi_wstrb(0),
      I5 => \slv_reg5[31]_i_2_n_0\,
      O => \slv_reg5[7]_i_1_n_0\
    );
\slv_reg5_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg5(0),
      R => \^sr\(0)
    );
\slv_reg5_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg5(10),
      R => \^sr\(0)
    );
\slv_reg5_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg5(11),
      R => \^sr\(0)
    );
\slv_reg5_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg5(12),
      R => \^sr\(0)
    );
\slv_reg5_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg5(13),
      R => \^sr\(0)
    );
\slv_reg5_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg5(14),
      R => \^sr\(0)
    );
\slv_reg5_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg5(15),
      R => \^sr\(0)
    );
\slv_reg5_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg5(16),
      R => \^sr\(0)
    );
\slv_reg5_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg5(17),
      R => \^sr\(0)
    );
\slv_reg5_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg5(18),
      R => \^sr\(0)
    );
\slv_reg5_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg5(19),
      R => \^sr\(0)
    );
\slv_reg5_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg5(1),
      R => \^sr\(0)
    );
\slv_reg5_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg5(20),
      R => \^sr\(0)
    );
\slv_reg5_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg5(21),
      R => \^sr\(0)
    );
\slv_reg5_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg5(22),
      R => \^sr\(0)
    );
\slv_reg5_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg5(23),
      R => \^sr\(0)
    );
\slv_reg5_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg5(24),
      R => \^sr\(0)
    );
\slv_reg5_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg5(25),
      R => \^sr\(0)
    );
\slv_reg5_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg5(26),
      R => \^sr\(0)
    );
\slv_reg5_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg5(27),
      R => \^sr\(0)
    );
\slv_reg5_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg5(28),
      R => \^sr\(0)
    );
\slv_reg5_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg5(29),
      R => \^sr\(0)
    );
\slv_reg5_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg5(2),
      R => \^sr\(0)
    );
\slv_reg5_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg5(30),
      R => \^sr\(0)
    );
\slv_reg5_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg5(31),
      R => \^sr\(0)
    );
\slv_reg5_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg5(3),
      R => \^sr\(0)
    );
\slv_reg5_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg5(4),
      R => \^sr\(0)
    );
\slv_reg5_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg5(5),
      R => \^sr\(0)
    );
\slv_reg5_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg5(6),
      R => \^sr\(0)
    );
\slv_reg5_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg5(7),
      R => \^sr\(0)
    );
\slv_reg5_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg5(8),
      R => \^sr\(0)
    );
\slv_reg5_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg5[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg5(9),
      R => \^sr\(0)
    );
\slv_reg6[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2020200000002000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg6[31]_i_2_n_0\,
      I2 => s00_axi_wstrb(1),
      I3 => \axi_awaddr_reg_n_0_[4]\,
      I4 => s00_axi_awvalid,
      I5 => s00_axi_awaddr(2),
      O => \slv_reg6[15]_i_1_n_0\
    );
\slv_reg6[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2020200000002000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg6[31]_i_2_n_0\,
      I2 => s00_axi_wstrb(2),
      I3 => \axi_awaddr_reg_n_0_[4]\,
      I4 => s00_axi_awvalid,
      I5 => s00_axi_awaddr(2),
      O => \slv_reg6[23]_i_1_n_0\
    );
\slv_reg6[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2020200000002000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg6[31]_i_2_n_0\,
      I2 => s00_axi_wstrb(3),
      I3 => \axi_awaddr_reg_n_0_[4]\,
      I4 => s00_axi_awvalid,
      I5 => s00_axi_awaddr(2),
      O => \slv_reg6[31]_i_1_n_0\
    );
\slv_reg6[31]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CCAFFFAF"
    )
        port map (
      I0 => \axi_awaddr_reg_n_0_[2]\,
      I1 => s00_axi_awaddr(0),
      I2 => \axi_awaddr_reg_n_0_[3]\,
      I3 => s00_axi_awvalid,
      I4 => s00_axi_awaddr(1),
      O => \slv_reg6[31]_i_2_n_0\
    );
\slv_reg6[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2020200000002000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \slv_reg6[31]_i_2_n_0\,
      I2 => s00_axi_wstrb(0),
      I3 => \axi_awaddr_reg_n_0_[4]\,
      I4 => s00_axi_awvalid,
      I5 => s00_axi_awaddr(2),
      O => \slv_reg6[7]_i_1_n_0\
    );
\slv_reg6_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => \^slv_reg6_reg[30]_0\(0),
      R => \^sr\(0)
    );
\slv_reg6_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => \^slv_reg6_reg[30]_0\(10),
      R => \^sr\(0)
    );
\slv_reg6_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => \^slv_reg6_reg[30]_0\(11),
      R => \^sr\(0)
    );
\slv_reg6_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => \^slv_reg6_reg[30]_0\(12),
      R => \^sr\(0)
    );
\slv_reg6_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => \^slv_reg6_reg[30]_0\(13),
      R => \^sr\(0)
    );
\slv_reg6_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => \^slv_reg6_reg[30]_0\(14),
      R => \^sr\(0)
    );
\slv_reg6_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => \^slv_reg6_reg[30]_0\(15),
      R => \^sr\(0)
    );
\slv_reg6_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => \^slv_reg6_reg[30]_0\(16),
      R => \^sr\(0)
    );
\slv_reg6_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => \^slv_reg6_reg[30]_0\(17),
      R => \^sr\(0)
    );
\slv_reg6_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => \^slv_reg6_reg[30]_0\(18),
      R => \^sr\(0)
    );
\slv_reg6_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => \^slv_reg6_reg[30]_0\(19),
      R => \^sr\(0)
    );
\slv_reg6_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => \^slv_reg6_reg[30]_0\(1),
      R => \^sr\(0)
    );
\slv_reg6_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => \^slv_reg6_reg[30]_0\(20),
      R => \^sr\(0)
    );
\slv_reg6_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => \^slv_reg6_reg[30]_0\(21),
      R => \^sr\(0)
    );
\slv_reg6_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => \^slv_reg6_reg[30]_0\(22),
      R => \^sr\(0)
    );
\slv_reg6_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => \^slv_reg6_reg[30]_0\(23),
      R => \^sr\(0)
    );
\slv_reg6_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => \^slv_reg6_reg[30]_0\(24),
      R => \^sr\(0)
    );
\slv_reg6_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => \^slv_reg6_reg[30]_0\(25),
      R => \^sr\(0)
    );
\slv_reg6_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => \^slv_reg6_reg[30]_0\(26),
      R => \^sr\(0)
    );
\slv_reg6_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => \^slv_reg6_reg[30]_0\(27),
      R => \^sr\(0)
    );
\slv_reg6_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => \^slv_reg6_reg[30]_0\(28),
      R => \^sr\(0)
    );
\slv_reg6_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => \^slv_reg6_reg[30]_0\(29),
      R => \^sr\(0)
    );
\slv_reg6_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => \^slv_reg6_reg[30]_0\(2),
      R => \^sr\(0)
    );
\slv_reg6_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => \^slv_reg6_reg[30]_0\(30),
      R => \^sr\(0)
    );
\slv_reg6_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg6(31),
      R => \^sr\(0)
    );
\slv_reg6_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => \^slv_reg6_reg[30]_0\(3),
      R => \^sr\(0)
    );
\slv_reg6_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => \^slv_reg6_reg[30]_0\(4),
      R => \^sr\(0)
    );
\slv_reg6_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => \^slv_reg6_reg[30]_0\(5),
      R => \^sr\(0)
    );
\slv_reg6_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => \^slv_reg6_reg[30]_0\(6),
      R => \^sr\(0)
    );
\slv_reg6_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => \^slv_reg6_reg[30]_0\(7),
      R => \^sr\(0)
    );
\slv_reg6_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => \^slv_reg6_reg[30]_0\(8),
      R => \^sr\(0)
    );
\slv_reg6_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg6[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => \^slv_reg6_reg[30]_0\(9),
      R => \^sr\(0)
    );
start_compute_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00001000"
    )
        port map (
      I0 => Q(0),
      I1 => Q(1),
      I2 => slv_reg0_bus(0),
      I3 => slv_reg0_bus(1),
      I4 => Q(2),
      O => start_compute
    );
start_read_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000100"
    )
        port map (
      I0 => Q(0),
      I1 => slv_reg0_bus(0),
      I2 => Q(1),
      I3 => slv_reg0_bus(1),
      I4 => Q(2),
      O => start_read
    );
start_write_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000010"
    )
        port map (
      I0 => Q(0),
      I1 => Q(1),
      I2 => slv_reg0_bus(0),
      I3 => slv_reg0_bus(1),
      I4 => Q(2),
      O => start_write
    );
\state1_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => O(4),
      I1 => \state1_carry__0\(4),
      I2 => \state1_carry__0\(5),
      I3 => O(5),
      O => DI(2)
    );
\state1_carry__0_i_10\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => O(3),
      I1 => O(2),
      I2 => \state1_carry__0\(2),
      I3 => \state1_carry__0\(3),
      O => \i_reg[28]\(1)
    );
\state1_carry__0_i_11\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => O(0),
      I1 => O(1),
      I2 => \state1_carry__0\(1),
      I3 => \state1_carry__0\(0),
      O => \i_reg[28]\(0)
    );
\state1_carry__0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7510"
    )
        port map (
      I0 => O(3),
      I1 => O(2),
      I2 => \state1_carry__0\(2),
      I3 => \state1_carry__0\(3),
      O => DI(1)
    );
\state1_carry__0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"40F4"
    )
        port map (
      I0 => O(0),
      I1 => \state1_carry__0\(0),
      I2 => \state1_carry__0\(1),
      I3 => O(1),
      O => DI(0)
    );
\state2_carry__0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8241"
    )
        port map (
      I0 => O(4),
      I1 => \state2_carry__0\(4),
      I2 => O(5),
      I3 => \state2_carry__0\(3),
      O => \word_count_reg[31]\(1)
    );
\state2_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8008200240041001"
    )
        port map (
      I0 => O(3),
      I1 => O(2),
      I2 => O(1),
      I3 => \state2_carry__0\(0),
      I4 => \state2_carry__0\(1),
      I5 => \state2_carry__0\(2),
      O => \word_count_reg[31]\(0)
    );
\state3_carry__0_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(16),
      O => \slv_reg6_reg[16]_0\(7)
    );
\state3_carry__0_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(15),
      O => \slv_reg6_reg[16]_0\(6)
    );
\state3_carry__0_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(14),
      O => \slv_reg6_reg[16]_0\(5)
    );
\state3_carry__0_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(13),
      O => \slv_reg6_reg[16]_0\(4)
    );
\state3_carry__0_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(12),
      O => \slv_reg6_reg[16]_0\(3)
    );
\state3_carry__0_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(11),
      O => \slv_reg6_reg[16]_0\(2)
    );
\state3_carry__0_i_7\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(10),
      O => \slv_reg6_reg[16]_0\(1)
    );
\state3_carry__0_i_8\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(9),
      O => \slv_reg6_reg[16]_0\(0)
    );
\state3_carry__1_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(24),
      O => \slv_reg6_reg[24]_0\(7)
    );
\state3_carry__1_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(23),
      O => \slv_reg6_reg[24]_0\(6)
    );
\state3_carry__1_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(22),
      O => \slv_reg6_reg[24]_0\(5)
    );
\state3_carry__1_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(21),
      O => \slv_reg6_reg[24]_0\(4)
    );
\state3_carry__1_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(20),
      O => \slv_reg6_reg[24]_0\(3)
    );
\state3_carry__1_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(19),
      O => \slv_reg6_reg[24]_0\(2)
    );
\state3_carry__1_i_7\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(18),
      O => \slv_reg6_reg[24]_0\(1)
    );
\state3_carry__1_i_8\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(17),
      O => \slv_reg6_reg[24]_0\(0)
    );
\state3_carry__2_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => slv_reg6(31),
      O => \slv_reg6_reg[31]_0\(6)
    );
\state3_carry__2_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(30),
      O => \slv_reg6_reg[31]_0\(5)
    );
\state3_carry__2_i_3\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(29),
      O => \slv_reg6_reg[31]_0\(4)
    );
\state3_carry__2_i_4\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(28),
      O => \slv_reg6_reg[31]_0\(3)
    );
\state3_carry__2_i_5\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(27),
      O => \slv_reg6_reg[31]_0\(2)
    );
\state3_carry__2_i_6\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(26),
      O => \slv_reg6_reg[31]_0\(1)
    );
\state3_carry__2_i_7\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(25),
      O => \slv_reg6_reg[31]_0\(0)
    );
state3_carry_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(8),
      O => S(7)
    );
state3_carry_i_2: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(7),
      O => S(6)
    );
state3_carry_i_3: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(6),
      O => S(5)
    );
state3_carry_i_4: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(5),
      O => S(4)
    );
state3_carry_i_5: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(4),
      O => S(3)
    );
state3_carry_i_6: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(3),
      O => S(2)
    );
state3_carry_i_7: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(2),
      O => S(1)
    );
state3_carry_i_8: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^slv_reg6_reg[30]_0\(1),
      O => S(0)
    );
stream_ready_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFF700000FF6"
    )
        port map (
      I0 => slv_reg0_bus(1),
      I1 => slv_reg0_bus(0),
      I2 => Q(1),
      I3 => Q(0),
      I4 => Q(2),
      I5 => stream_ready,
      O => \slv_reg0_reg[1]_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top is
  port (
    axi_awready_reg : out STD_LOGIC;
    axi_arready_reg : out STD_LOGIC;
    axi_rvalid_reg : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s_axis_valid : in STD_LOGIC;
    s_axis_last : in STD_LOGIC;
    s00_axi_bready : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top is
  signal bram_done : STD_LOGIC;
  signal compute_done : STD_LOGIC;
  signal instr_ready : STD_LOGIC;
  signal slv_reg6 : STD_LOGIC_VECTOR ( 30 downto 0 );
  signal start_compute : STD_LOGIC;
  signal start_compute_reg_n_0 : STD_LOGIC;
  signal start_read : STD_LOGIC;
  signal start_read_reg_n_0 : STD_LOGIC;
  signal start_write : STD_LOGIC;
  signal start_write_reg_n_0 : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal state2 : STD_LOGIC_VECTOR ( 31 downto 1 );
  signal \state__0\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal stream_ready : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_10 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_11 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_113 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_114 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_12 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_13 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_14 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_15 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_16 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_48 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_49 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_50 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_51 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_52 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_53 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_54 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_55 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_56 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_57 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_58 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_59 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_60 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_61 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_62 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_63 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_64 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_65 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_66 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_67 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_68 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_69 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_70 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_71 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_72 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_73 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_74 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_75 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_76 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_77 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8 : STD_LOGIC;
  signal tpu_top_slave_lite_v1_0_S00_AXI_inst_n_9 : STD_LOGIC;
  signal u_bram_top_n_18 : STD_LOGIC;
  signal u_bram_top_n_19 : STD_LOGIC;
  signal u_bram_top_n_20 : STD_LOGIC;
  signal u_bram_top_n_21 : STD_LOGIC;
  signal u_bram_top_n_22 : STD_LOGIC;
  signal u_bram_top_n_23 : STD_LOGIC;
  signal u_bram_top_n_24 : STD_LOGIC;
  signal u_bram_top_n_25 : STD_LOGIC;
  signal u_bram_top_n_26 : STD_LOGIC;
  signal u_bram_top_n_27 : STD_LOGIC;
  signal u_bram_top_n_28 : STD_LOGIC;
  signal u_bram_top_n_29 : STD_LOGIC;
  signal u_bram_top_n_30 : STD_LOGIC;
  signal u_bram_top_n_31 : STD_LOGIC;
  signal u_bram_top_n_32 : STD_LOGIC;
  signal u_bram_top_n_33 : STD_LOGIC;
  signal u_bram_top_n_34 : STD_LOGIC;
  signal u_bram_top_n_35 : STD_LOGIC;
  signal u_bram_top_n_36 : STD_LOGIC;
  signal u_bram_top_n_37 : STD_LOGIC;
  signal u_bram_top_n_38 : STD_LOGIC;
  signal u_bram_top_n_39 : STD_LOGIC;
  signal u_compute_top_n_1 : STD_LOGIC;
  signal u_compute_top_n_10 : STD_LOGIC;
  signal u_compute_top_n_11 : STD_LOGIC;
  signal u_compute_top_n_12 : STD_LOGIC;
  signal u_compute_top_n_13 : STD_LOGIC;
  signal u_compute_top_n_14 : STD_LOGIC;
  signal u_compute_top_n_15 : STD_LOGIC;
  signal u_compute_top_n_16 : STD_LOGIC;
  signal u_compute_top_n_17 : STD_LOGIC;
  signal u_compute_top_n_18 : STD_LOGIC;
  signal u_compute_top_n_19 : STD_LOGIC;
  signal u_compute_top_n_2 : STD_LOGIC;
  signal u_compute_top_n_20 : STD_LOGIC;
  signal u_compute_top_n_21 : STD_LOGIC;
  signal u_compute_top_n_22 : STD_LOGIC;
  signal u_compute_top_n_23 : STD_LOGIC;
  signal u_compute_top_n_24 : STD_LOGIC;
  signal u_compute_top_n_25 : STD_LOGIC;
  signal u_compute_top_n_26 : STD_LOGIC;
  signal u_compute_top_n_3 : STD_LOGIC;
  signal u_compute_top_n_4 : STD_LOGIC;
  signal u_compute_top_n_5 : STD_LOGIC;
  signal u_compute_top_n_6 : STD_LOGIC;
  signal u_compute_top_n_7 : STD_LOGIC;
  signal u_compute_top_n_8 : STD_LOGIC;
  signal u_compute_top_n_9 : STD_LOGIC;
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "IDLE:000,WAIT_DONE:100,EXEC_COMPUTE:011,EXEC_READ:010,EXEC_WRITE:001";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "IDLE:000,WAIT_DONE:100,EXEC_COMPUTE:011,EXEC_READ:010,EXEC_WRITE:001";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[2]\ : label is "IDLE:000,WAIT_DONE:100,EXEC_COMPUTE:011,EXEC_READ:010,EXEC_WRITE:001";
begin
\FSM_sequential_state[2]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0E"
    )
        port map (
      I0 => state(1),
      I1 => state(0),
      I2 => state(2),
      O => \state__0\(2)
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8,
      CLR => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      D => \state__0\(0),
      Q => state(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8,
      CLR => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      D => \state__0\(1),
      Q => state(1)
    );
\FSM_sequential_state_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => s00_axi_aclk,
      CE => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8,
      CLR => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      D => \state__0\(2),
      Q => state(2)
    );
instr_ready_reg: unisim.vcomponents.FDPE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_113,
      PRE => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      Q => instr_ready
    );
start_compute_reg: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      CLR => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      D => start_compute,
      Q => start_compute_reg_n_0
    );
start_read_reg: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      CLR => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      D => start_read,
      Q => start_read_reg_n_0
    );
start_write_reg: unisim.vcomponents.FDCE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      CLR => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      D => start_write,
      Q => start_write_reg_n_0
    );
stream_ready_reg: unisim.vcomponents.FDPE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_114,
      PRE => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      Q => stream_ready
    );
tpu_top_slave_lite_v1_0_S00_AXI_inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top_slave_lite_v1_0_S00_AXI
     port map (
      D(1 downto 0) => \state__0\(1 downto 0),
      DI(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_75,
      DI(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_76,
      DI(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_77,
      E(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_8,
      \FSM_sequential_state_reg[2]\ => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_113,
      O(5 downto 0) => state2(31 downto 26),
      Q(2 downto 0) => state(2 downto 0),
      S(7) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_9,
      S(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_10,
      S(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_11,
      S(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_12,
      S(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_13,
      S(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_14,
      S(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_15,
      S(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_16,
      SR(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      axi_arready_reg_0 => axi_arready_reg,
      axi_awready_reg_0 => axi_awready_reg,
      axi_rvalid_reg_0 => axi_rvalid_reg,
      bram_done => bram_done,
      compute_done => compute_done,
      \i_reg[28]\(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_73,
      \i_reg[28]\(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_74,
      instr_ready => instr_ready,
      s00_axi_aclk => s00_axi_aclk,
      s00_axi_araddr(2 downto 0) => s00_axi_araddr(2 downto 0),
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_awaddr(2 downto 0) => s00_axi_awaddr(2 downto 0),
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_rdata(31 downto 0) => s00_axi_rdata(31 downto 0),
      s00_axi_rready => s00_axi_rready,
      s00_axi_wdata(31 downto 0) => s00_axi_wdata(31 downto 0),
      s00_axi_wready => s00_axi_wready,
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid,
      \slv_reg0_reg[1]_0\ => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_114,
      \slv_reg6_reg[16]_0\(7) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_48,
      \slv_reg6_reg[16]_0\(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_49,
      \slv_reg6_reg[16]_0\(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_50,
      \slv_reg6_reg[16]_0\(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_51,
      \slv_reg6_reg[16]_0\(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_52,
      \slv_reg6_reg[16]_0\(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_53,
      \slv_reg6_reg[16]_0\(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_54,
      \slv_reg6_reg[16]_0\(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_55,
      \slv_reg6_reg[24]_0\(7) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_56,
      \slv_reg6_reg[24]_0\(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_57,
      \slv_reg6_reg[24]_0\(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_58,
      \slv_reg6_reg[24]_0\(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_59,
      \slv_reg6_reg[24]_0\(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_60,
      \slv_reg6_reg[24]_0\(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_61,
      \slv_reg6_reg[24]_0\(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_62,
      \slv_reg6_reg[24]_0\(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_63,
      \slv_reg6_reg[30]_0\(30 downto 0) => slv_reg6(30 downto 0),
      \slv_reg6_reg[31]_0\(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_64,
      \slv_reg6_reg[31]_0\(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_65,
      \slv_reg6_reg[31]_0\(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_66,
      \slv_reg6_reg[31]_0\(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_67,
      \slv_reg6_reg[31]_0\(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_68,
      \slv_reg6_reg[31]_0\(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_69,
      \slv_reg6_reg[31]_0\(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_70,
      start_compute => start_compute,
      start_read => start_read,
      start_write => start_write,
      \state1_carry__0\(5) => u_compute_top_n_1,
      \state1_carry__0\(4) => u_compute_top_n_2,
      \state1_carry__0\(3) => u_compute_top_n_3,
      \state1_carry__0\(2) => u_compute_top_n_4,
      \state1_carry__0\(1) => u_compute_top_n_5,
      \state1_carry__0\(0) => u_compute_top_n_6,
      \state2_carry__0\(4) => u_bram_top_n_18,
      \state2_carry__0\(3) => u_bram_top_n_19,
      \state2_carry__0\(2) => u_bram_top_n_20,
      \state2_carry__0\(1) => u_bram_top_n_21,
      \state2_carry__0\(0) => u_bram_top_n_22,
      stream_ready => stream_ready,
      \word_count_reg[31]\(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_71,
      \word_count_reg[31]\(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_72
    );
u_bram_top: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bram_top
     port map (
      DI(5) => u_bram_top_n_30,
      DI(4) => u_bram_top_n_31,
      DI(3) => u_bram_top_n_32,
      DI(2) => u_bram_top_n_33,
      DI(1) => u_bram_top_n_34,
      DI(0) => u_bram_top_n_35,
      \FSM_sequential_state_reg[0]_0\(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_71,
      \FSM_sequential_state_reg[0]_0\(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_72,
      \FSM_sequential_state_reg[0]_1\ => start_write_reg_n_0,
      Q(4) => u_bram_top_n_18,
      Q(3) => u_bram_top_n_19,
      Q(2) => u_bram_top_n_20,
      Q(1) => u_bram_top_n_21,
      Q(0) => u_bram_top_n_22,
      S(7) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_9,
      S(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_10,
      S(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_11,
      S(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_12,
      S(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_13,
      S(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_14,
      S(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_15,
      S(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_16,
      SR(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      bram_done => bram_done,
      \i_reg[15]\(3) => u_bram_top_n_23,
      \i_reg[15]\(2) => u_bram_top_n_24,
      \i_reg[15]\(1) => u_bram_top_n_25,
      \i_reg[15]\(0) => u_bram_top_n_26,
      \i_reg[22]\(2) => u_bram_top_n_27,
      \i_reg[22]\(1) => u_bram_top_n_28,
      \i_reg[22]\(0) => u_bram_top_n_29,
      \i_reg[22]_0\(3) => u_bram_top_n_36,
      \i_reg[22]_0\(2) => u_bram_top_n_37,
      \i_reg[22]_0\(1) => u_bram_top_n_38,
      \i_reg[22]_0\(0) => u_bram_top_n_39,
      s00_axi_aclk => s00_axi_aclk,
      s_axis_last => s_axis_last,
      s_axis_valid => s_axis_valid,
      \slv_reg6_reg[30]\(16 downto 9) => state2(31 downto 24),
      \slv_reg6_reg[30]\(8 downto 7) => state2(19 downto 18),
      \slv_reg6_reg[30]\(6 downto 5) => state2(13 downto 12),
      \slv_reg6_reg[30]\(4 downto 3) => state2(7 downto 6),
      \slv_reg6_reg[30]\(2 downto 0) => state2(3 downto 1),
      \state1_carry__0\(19) => u_compute_top_n_7,
      \state1_carry__0\(18) => u_compute_top_n_8,
      \state1_carry__0\(17) => u_compute_top_n_9,
      \state1_carry__0\(16) => u_compute_top_n_10,
      \state1_carry__0\(15) => u_compute_top_n_11,
      \state1_carry__0\(14) => u_compute_top_n_12,
      \state1_carry__0\(13) => u_compute_top_n_13,
      \state1_carry__0\(12) => u_compute_top_n_14,
      \state1_carry__0\(11) => u_compute_top_n_15,
      \state1_carry__0\(10) => u_compute_top_n_16,
      \state1_carry__0\(9) => u_compute_top_n_17,
      \state1_carry__0\(8) => u_compute_top_n_18,
      \state1_carry__0\(7) => u_compute_top_n_19,
      \state1_carry__0\(6) => u_compute_top_n_20,
      \state1_carry__0\(5) => u_compute_top_n_21,
      \state1_carry__0\(4) => u_compute_top_n_22,
      \state1_carry__0\(3) => u_compute_top_n_23,
      \state1_carry__0\(2) => u_compute_top_n_24,
      \state1_carry__0\(1) => u_compute_top_n_25,
      \state1_carry__0\(0) => u_compute_top_n_26,
      \state1_carry__0_i_12\(30 downto 0) => slv_reg6(30 downto 0),
      \state1_carry__0_i_12_0\(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_64,
      \state1_carry__0_i_12_0\(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_65,
      \state1_carry__0_i_12_0\(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_66,
      \state1_carry__0_i_12_0\(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_67,
      \state1_carry__0_i_12_0\(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_68,
      \state1_carry__0_i_12_0\(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_69,
      \state1_carry__0_i_12_0\(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_70,
      state2_carry_i_3_0(7) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_56,
      state2_carry_i_3_0(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_57,
      state2_carry_i_3_0(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_58,
      state2_carry_i_3_0(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_59,
      state2_carry_i_3_0(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_60,
      state2_carry_i_3_0(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_61,
      state2_carry_i_3_0(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_62,
      state2_carry_i_3_0(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_63,
      state2_carry_i_5_0(7) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_48,
      state2_carry_i_5_0(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_49,
      state2_carry_i_5_0(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_50,
      state2_carry_i_5_0(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_51,
      state2_carry_i_5_0(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_52,
      state2_carry_i_5_0(2) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_53,
      state2_carry_i_5_0(1) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_54,
      state2_carry_i_5_0(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_55,
      \word_count_reg[31]_0\ => start_read_reg_n_0
    );
u_compute_top: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_compute_top
     port map (
      DI(5) => u_bram_top_n_30,
      DI(4) => u_bram_top_n_31,
      DI(3) => u_bram_top_n_32,
      DI(2) => u_bram_top_n_33,
      DI(1) => u_bram_top_n_34,
      DI(0) => u_bram_top_n_35,
      \FSM_sequential_state_reg[0]_0\ => start_compute_reg_n_0,
      \FSM_sequential_state_reg[3]_0\(6) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_75,
      \FSM_sequential_state_reg[3]_0\(5) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_76,
      \FSM_sequential_state_reg[3]_0\(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_77,
      \FSM_sequential_state_reg[3]_0\(3) => u_bram_top_n_36,
      \FSM_sequential_state_reg[3]_0\(2) => u_bram_top_n_37,
      \FSM_sequential_state_reg[3]_0\(1) => u_bram_top_n_38,
      \FSM_sequential_state_reg[3]_0\(0) => u_bram_top_n_39,
      Q(25) => u_compute_top_n_1,
      Q(24) => u_compute_top_n_2,
      Q(23) => u_compute_top_n_3,
      Q(22) => u_compute_top_n_4,
      Q(21) => u_compute_top_n_5,
      Q(20) => u_compute_top_n_6,
      Q(19) => u_compute_top_n_7,
      Q(18) => u_compute_top_n_8,
      Q(17) => u_compute_top_n_9,
      Q(16) => u_compute_top_n_10,
      Q(15) => u_compute_top_n_11,
      Q(14) => u_compute_top_n_12,
      Q(13) => u_compute_top_n_13,
      Q(12) => u_compute_top_n_14,
      Q(11) => u_compute_top_n_15,
      Q(10) => u_compute_top_n_16,
      Q(9) => u_compute_top_n_17,
      Q(8) => u_compute_top_n_18,
      Q(7) => u_compute_top_n_19,
      Q(6) => u_compute_top_n_20,
      Q(5) => u_compute_top_n_21,
      Q(4) => u_compute_top_n_22,
      Q(3) => u_compute_top_n_23,
      Q(2) => u_compute_top_n_24,
      Q(1) => u_compute_top_n_25,
      Q(0) => u_compute_top_n_26,
      S(4) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_73,
      S(3) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_74,
      S(2) => u_bram_top_n_27,
      S(1) => u_bram_top_n_28,
      S(0) => u_bram_top_n_29,
      SR(0) => tpu_top_slave_lite_v1_0_S00_AXI_inst_n_0,
      compute_done => compute_done,
      s00_axi_aclk => s00_axi_aclk,
      state1_carry_0(0) => slv_reg6(0),
      \state1_carry__0_0\(3) => u_bram_top_n_23,
      \state1_carry__0_0\(2) => u_bram_top_n_24,
      \state1_carry__0_0\(1) => u_bram_top_n_25,
      \state1_carry__0_0\(0) => u_bram_top_n_26,
      \state1_carry__0_1\(12 downto 11) => state2(31 downto 30),
      \state1_carry__0_1\(10 downto 9) => state2(25 downto 24),
      \state1_carry__0_1\(8 downto 7) => state2(19 downto 18),
      \state1_carry__0_1\(6 downto 5) => state2(13 downto 12),
      \state1_carry__0_1\(4 downto 3) => state2(7 downto 6),
      \state1_carry__0_1\(2 downto 0) => state2(3 downto 1)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    s_axis_valid : in STD_LOGIC;
    s_axis_data : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_last : in STD_LOGIC;
    s_axis_ready : out STD_LOGIC;
    m_axis_valid : out STD_LOGIC;
    m_axis_data : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_last : out STD_LOGIC;
    m_axis_ready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 4 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "design_1_tpu_top_0_0,tpu_top,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "tpu_top,Vivado 2025.1";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of m_axis_last : signal is "xilinx.com:interface:axis:1.0 m_axis TLAST";
  attribute X_INTERFACE_INFO of m_axis_ready : signal is "xilinx.com:interface:axis:1.0 m_axis TREADY";
  attribute X_INTERFACE_INFO of m_axis_valid : signal is "xilinx.com:interface:axis:1.0 m_axis TVALID";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of m_axis_valid : signal is "master";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of m_axis_valid : signal is "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 99999001, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_aclk : signal is "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK";
  attribute X_INTERFACE_MODE of s00_axi_aclk : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s00_axi_aclk : signal is "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI:m_axis:s_axis, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 99999001, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 S00_AXI_RST RST";
  attribute X_INTERFACE_MODE of s00_axi_aresetn : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s00_axi_aresetn : signal is "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY";
  attribute X_INTERFACE_INFO of s00_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID";
  attribute X_INTERFACE_INFO of s00_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY";
  attribute X_INTERFACE_INFO of s00_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID";
  attribute X_INTERFACE_INFO of s00_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BREADY";
  attribute X_INTERFACE_INFO of s00_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BVALID";
  attribute X_INTERFACE_INFO of s00_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RREADY";
  attribute X_INTERFACE_INFO of s00_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RVALID";
  attribute X_INTERFACE_INFO of s00_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WREADY";
  attribute X_INTERFACE_INFO of s00_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WVALID";
  attribute X_INTERFACE_INFO of s_axis_last : signal is "xilinx.com:interface:axis:1.0 s_axis TLAST";
  attribute X_INTERFACE_INFO of s_axis_ready : signal is "xilinx.com:interface:axis:1.0 s_axis TREADY";
  attribute X_INTERFACE_INFO of s_axis_valid : signal is "xilinx.com:interface:axis:1.0 s_axis TVALID";
  attribute X_INTERFACE_MODE of s_axis_valid : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s_axis_valid : signal is "XIL_INTERFACENAME s_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 99999001, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, LAYERED_METADATA undef, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of m_axis_data : signal is "xilinx.com:interface:axis:1.0 m_axis TDATA";
  attribute X_INTERFACE_INFO of s00_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR";
  attribute X_INTERFACE_INFO of s00_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT";
  attribute X_INTERFACE_INFO of s00_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR";
  attribute X_INTERFACE_MODE of s00_axi_awaddr : signal is "slave";
  attribute X_INTERFACE_PARAMETER of s00_axi_awaddr : signal is "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 7, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 99999001, ID_WIDTH 0, ADDR_WIDTH 5, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 8, NUM_WRITE_OUTSTANDING 8, MAX_BURST_LENGTH 1, PHASE 0.0, CLK_DOMAIN design_1_zynq_ultra_ps_e_0_0_pl_clk0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT";
  attribute X_INTERFACE_INFO of s00_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BRESP";
  attribute X_INTERFACE_INFO of s00_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RDATA";
  attribute X_INTERFACE_INFO of s00_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RRESP";
  attribute X_INTERFACE_INFO of s00_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WDATA";
  attribute X_INTERFACE_INFO of s00_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB";
  attribute X_INTERFACE_INFO of s_axis_data : signal is "xilinx.com:interface:axis:1.0 s_axis TDATA";
begin
  m_axis_data(31) <= \<const0>\;
  m_axis_data(30) <= \<const0>\;
  m_axis_data(29) <= \<const0>\;
  m_axis_data(28) <= \<const0>\;
  m_axis_data(27) <= \<const0>\;
  m_axis_data(26) <= \<const0>\;
  m_axis_data(25) <= \<const0>\;
  m_axis_data(24) <= \<const0>\;
  m_axis_data(23) <= \<const0>\;
  m_axis_data(22) <= \<const0>\;
  m_axis_data(21) <= \<const0>\;
  m_axis_data(20) <= \<const0>\;
  m_axis_data(19) <= \<const0>\;
  m_axis_data(18) <= \<const0>\;
  m_axis_data(17) <= \<const0>\;
  m_axis_data(16) <= \<const0>\;
  m_axis_data(15) <= \<const0>\;
  m_axis_data(14) <= \<const0>\;
  m_axis_data(13) <= \<const0>\;
  m_axis_data(12) <= \<const0>\;
  m_axis_data(11) <= \<const0>\;
  m_axis_data(10) <= \<const0>\;
  m_axis_data(9) <= \<const0>\;
  m_axis_data(8) <= \<const0>\;
  m_axis_data(7) <= \<const0>\;
  m_axis_data(6) <= \<const0>\;
  m_axis_data(5) <= \<const0>\;
  m_axis_data(4) <= \<const0>\;
  m_axis_data(3) <= \<const0>\;
  m_axis_data(2) <= \<const0>\;
  m_axis_data(1) <= \<const0>\;
  m_axis_data(0) <= \<const0>\;
  m_axis_last <= \<const0>\;
  m_axis_valid <= \<const0>\;
  s00_axi_bresp(1) <= \<const0>\;
  s00_axi_bresp(0) <= \<const0>\;
  s00_axi_rresp(1) <= \<const0>\;
  s00_axi_rresp(0) <= \<const0>\;
  s_axis_ready <= \<const1>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_tpu_top
     port map (
      axi_arready_reg => s00_axi_arready,
      axi_awready_reg => s00_axi_awready,
      axi_rvalid_reg => s00_axi_rvalid,
      s00_axi_aclk => s00_axi_aclk,
      s00_axi_araddr(2 downto 0) => s00_axi_araddr(4 downto 2),
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_awaddr(2 downto 0) => s00_axi_awaddr(4 downto 2),
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_rdata(31 downto 0) => s00_axi_rdata(31 downto 0),
      s00_axi_rready => s00_axi_rready,
      s00_axi_wdata(31 downto 0) => s00_axi_wdata(31 downto 0),
      s00_axi_wready => s00_axi_wready,
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid,
      s_axis_last => s_axis_last,
      s_axis_valid => s_axis_valid
    );
end STRUCTURE;
