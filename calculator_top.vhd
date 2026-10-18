library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calculator_top is
    Port (
        clk  : in  STD_LOGIC;
        sw   : in  STD_LOGIC_VECTOR (15 downto 0);
        btnU : in  STD_LOGIC;
        btnD : in  STD_LOGIC;
        btnC : in  STD_LOGIC;
        led  : out STD_LOGIC_VECTOR (3 downto 0);
        seg  : out STD_LOGIC_VECTOR (6 downto 0);
        an   : out STD_LOGIC_VECTOR (3 downto 0);
        dp   : out STD_LOGIC
    );
end calculator_top;

architecture Behavioral of calculator_top is

    signal u_db, d_db, c_db : STD_LOGIC;
    signal u_p,  d_p,  c_p  : STD_LOGIC;

    signal reg_a, reg_b : STD_LOGIC_VECTOR(7 downto 0);
    signal op_sel       : STD_LOGIC_VECTOR(1 downto 0);
    signal alu_res      : STD_LOGIC_VECTOR(15 downto 0);
    signal disp_val     : STD_LOGIC_VECTOR(15 downto 0);

begin

    -- 1. Debouncer
    db_u : entity work.debounce port map (clk => clk, btn_in => btnU, btn_out => u_db);
    db_d : entity work.debounce port map (clk => clk, btn_in => btnD, btn_out => d_db);
    db_c : entity work.debounce port map (clk => clk, btn_in => btnC, btn_out => c_db);

    -- 2. Edge Detector
    ed_u : entity work.edge_detect port map (clk => clk, sig_in => u_db, pulse => u_p);
    ed_d : entity work.edge_detect port map (clk => clk, sig_in => d_db, pulse => d_p);
    ed_c : entity work.edge_detect port map (clk => clk, sig_in => c_db, pulse => c_p);

    -- 3. ALU 8-bit
    alu_inst : entity work.alu8
        port map (
            a      => reg_a,
            b      => reg_b,
            opcode => op_sel,
            result => alu_res
        );

    -- 4. FSM Controller
    fsm_inst : entity work.calculator_fsm
        port map (
            clk         => clk,
            rst         => '0',
            btnU_p      => u_p,
            btnD_p      => d_p,
            btnC_p      => c_p,
            sw_in       => sw(7 downto 0),
            op_in       => sw(15 downto 14),
            alu_result  => alu_res,
            reg_a_out   => reg_a,
            reg_b_out   => reg_b,
            op_out      => op_sel,
            display_val => disp_val,
            state_led   => led
        );

    -- 5. Seven Segment Driver
    seg_inst : entity work.seven_seg_driver
        port map (
            clk     => clk,
            data_in => disp_val,
            seg     => seg,
            an      => an,
            dp      => dp
        );

end Behavioral;