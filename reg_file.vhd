library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity regfile is
port( din	: in std_logic_vector(31 downto 0);
      reset	: in std_logic;
      clk	: in std_logic;
      write	: in std_logic;
      read_a	: in std_logic_vector(4 downto 0);
      read_b	: in std_logic_vector(4 downto 0);
      write_address : in std_logic_vector(4 downto 0);
      out_a	: out std_logic_vector(31 downto 0);
      out_b	: out std_logic_vector(31 downto 0));
end regfile;

architecture reg_arch of regfile is

-- declare internal signals
type Registers is array(0 to 31) of std_logic_vector(31 downto 0);
signal R: Registers;

begin
	out_a <= R(conv_integer(read_a));
	out_b <= R(conv_integer(read_b));

	process(din, reset, clk, write, write_address)
	begin
		if (reset = '1') then
			for i in R'range loop
				R(i) <= (others=> '0');
			end loop;

		elsif( rising_edge(clk) ) then
			if ( write = '1' ) then
				R(conv_integer(write_address)) <= din;
			end if;
		end if;
	end process;
end reg_arch;
