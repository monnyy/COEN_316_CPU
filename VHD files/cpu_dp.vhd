library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity cpu is
    port ( reset_al	: in std_logic;
	   clk_al		: in std_logic;

	   -- output ports from register file
	   rs_out, rt_out	: out std_logic_vector(3 downto 0):= (others => '0');
	   pc_out		: out std_logic_vector(3 downto 0):= (others => '0');

	   -- will not be constrained in Xilinx since not enough LEDs
	   overflow, zero	: out std_logic); 
end cpu;

architecture structural of cpu is

--  declare a PC component
component pc_comp
port( in_addr: in std_logic_vector(31 downto 0) := (others => '0');
      reset	: in std_logic;
      clk	: in std_logic;
      out_q	: out std_logic_vector(31 downto 0) := (others => '0'));
end component;

-- declare Instruction Memory component
component i_cache
port( input_addr: in std_logic_vector(4 downto 0);
      	instr	: out std_logic_vector(31 downto 0));
end component;

--  declare a Next Address component
component next_address
port(	
	rt,rs	    	: in std_logic_vector(31 downto 0);  -- two register input
	pc		: in std_logic_vector(31 downto 0);
	target_address	: in std_logic_vector(25 downto 0);
	branch_type	: in std_logic_vector(1 downto 0);
	pc_sel	    	: in std_logic_vector(1 downto 0);
	next_pc	    	: out std_logic_vector(31 downto 0));
end component;

--  declare a Register File component
component regfile
port( din	: in std_logic_vector(31 downto 0);
      reset	: in std_logic;
      clk	: in std_logic;
      write	: in std_logic;
      read_a	: in std_logic_vector(4 downto 0);
      read_b	: in std_logic_vector(4 downto 0);
      write_address : in std_logic_vector(4 downto 0);
      out_a	: out std_logic_vector(31 downto 0);
      out_b	: out std_logic_vector(31 downto 0));
end component;

-- declare Sign Extend component
component sign_ext
port( 	in16	: in std_logic_vector(15 downto 0);
	func_se	: in std_logic_vector(1 downto 0);
      	out32	: out std_logic_vector(31 downto 0));
end component;

--  declare an ALU component
component alu
port(	
	x,y	    : in std_logic_vector(31 downto 0);  -- two input operands
	add_sub     : in std_logic;			 -- 0 = add, 1 = sub
	logic_func  : in std_logic_vector(1 downto 0);   -- 00 = AND, 01 = OR, 10 = XOR, 11 = NOR
	func	    : in std_logic_vector(1 downto 0);   -- 00 = lui, 01 = setless, 10 = arith, 11 = logic

	output	    : out std_logic_vector(31 downto 0);
	ovrflw    : out std_logic;
	zro	    : out std_logic);
end component;

-- declare Data Memory component
component d_cache
port(	input	 : in std_logic_vector(31 downto 0);
	reset	 : in std_logic;
      	clk	 : in std_logic;
	addr	 : in std_logic_vector(4 downto 0);
      data_write : in std_logic;
      	output	 : out std_logic_vector(31 downto 0));
end component;


-- declare configuration specification
for PC : pc_comp use entity WORK.pc_comp(pc_comp_arch);
for I_C : i_cache use entity WORK.i_cache(ic_arch);
for NextAddress : next_address use entity WORK.next_address(pc_arch);
for R_F : regfile use entity WORK.regfile(reg_arch);
for SignExtend : sign_ext use entity WORK.sign_ext(se_arch);
for A : alu use entity WORK.alu(alu_arch);
for D_C : d_cache use entity WORK.d_cache(dc_arch);

-- declare internal signals used to "hook up" components
signal pc_o, next_pc_o, ic_o, dc_o, a_o, b_o, alu_o, se_o, alu_i, reg_i : std_logic_vector(31 downto 0) := X"00000000";
signal reg_addr_i : std_logic_vector(4 downto 0) := (others => '0');
signal pc_choice, branch_t, alu_f, alu_lf : std_logic_vector(1 downto 0) := "00";
signal alu_adsb, dc_write, reg_write, reg_dst, alu_src, reg_in_src : std_logic := '0';

-- opcode, func and control signal holder respectively for control unit implementation
signal mick , keith : std_logic_vector(5 downto 0) := (others => '0');
signal ctrl_sig : std_logic_vector(13 downto 0);

begin
-- control unit implementation
	process(ic_o, clk_al, reset_al, mick, keith, ctrl_sig)
	begin
		mick	 <= ic_o(31 downto 26);
		keith	 <= ic_o(5 downto 0);
		case mick is
			when "000000" =>
				   if (keith = "100000") then ctrl_sig <= "11100000100000"; -- add
				elsif (keith = "100010") then ctrl_sig <= "11101000100000"; -- sub
				elsif (keith = "101010") then ctrl_sig <= "11100000010000"; -- slt
				elsif (keith = "100100") then ctrl_sig <= "11101000110000"; -- and
				elsif (keith = "100101") then ctrl_sig <= "11100001110000"; -- or
				elsif (keith = "100110") then ctrl_sig <= "11100010110000"; -- xor
				elsif (keith = "100111") then ctrl_sig <= "11100011110000"; -- nor
				elsif (keith = "001000") then ctrl_sig <= "00000000000010"; -- jr
				else end if;
			when "000001" => ctrl_sig <= "00000000001100"; -- bltz
			when "000010" => ctrl_sig <= "00000000000001"; -- j
			when "000100" => ctrl_sig <= "00000000000100"; -- beq
			when "000101" => ctrl_sig <= "00000000001000"; -- bne
			when "001000" => ctrl_sig <= "10110000100000"; -- addi
			when "001010" => ctrl_sig <= "10110000010000"; -- slti
			when "001100" => ctrl_sig <= "10110000110000"; -- andi
			when "001101" => ctrl_sig <= "10110001110000"; -- ori
			when "001110" => ctrl_sig <= "10110010110000"; -- xori
			when "001111" => ctrl_sig <= "10110000000000"; -- lui
			when "100011" => ctrl_sig <= "10010010100000"; -- lw
			when "101011" => ctrl_sig <= "00010100100000"; -- sw
			when others =>
		end case;

		reg_write <= ctrl_sig(13);
		reg_dst	 <= ctrl_sig(12);
		reg_in_src <= ctrl_sig(11);
		alu_src <= ctrl_sig(10);
		alu_adsb <= ctrl_sig(9);
		dc_write <= ctrl_sig(8);
		alu_lf <= ctrl_sig(7 downto 6);
		alu_f <= ctrl_sig(5 downto 4);
		branch_t <= ctrl_sig(3 downto 2);
		pc_choice <= ctrl_sig(1 downto 0);
	end process; 

-- component instantiation
PC: pc_comp port map(in_addr => next_pc_o, reset => reset_al, clk => clk_al, out_q => pc_o);

I_C: i_cache port map(input_addr => pc_o(4 downto 0), instr => ic_o);

NextAddress: next_address port map(rt => b_o, rs => a_o, pc => pc_o, target_address => ic_o(25 downto 0), 
				   branch_type => branch_t, pc_sel => pc_choice, next_pc => next_pc_o);

R_F: regfile port map(din => reg_i, reset => reset_al, clk => clk_al, write => reg_write, 
		      read_a => ic_o(25 downto 21), read_b => ic_o(20 downto 16),
		      write_address => reg_addr_i, out_a => a_o, out_b => b_o);

SignExtend: sign_ext port map(in16 => ic_o(15 downto 0), func_se => alu_f, out32 => se_o);

A: alu port map(x => a_o, y => alu_i, add_sub => alu_adsb, logic_func => alu_lf, 
		func => alu_f, output => alu_o, ovrflw => overflow, zro => zero);

D_C: d_cache port map(input => b_o, reset => reset_al, clk => clk_al, 
		      addr => alu_o(4 downto 0), data_write => dc_write, output => dc_o);

-- implementation of the connections between mutiplexers
reg_addr_i <= ic_o(20 downto 16) WHEN (reg_dst = '0') ELSE
	      ic_o(15 downto 11) WHEN (reg_dst = '1');

alu_i <= se_o WHEN (alu_src = '1') ELSE
	 b_o WHEN (alu_src = '0');

reg_i <= alu_o WHEN (reg_in_src = '1') ELSE
	 dc_o WHEN (reg_in_src = '0');

rs_out	<= not(a_o(3 downto 0));
rt_out	<= not(b_o(3 downto 0));
pc_out	<= not(pc_o(3 downto 0));

end structural;
