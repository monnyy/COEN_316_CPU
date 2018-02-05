library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity pc_comp is
port( in_addr: in std_logic_vector(31 downto 0);
      	reset	: in std_logic;
      	clk	: in std_logic;
      	out_q	: out std_logic_vector(31 downto 0));
end pc_comp;

architecture pc_comp_arch of pc_comp is

begin
	process(in_addr, reset, clk)
	begin
		if (reset = '1') then
			out_q <= X"00000000";

		elsif( rising_edge(clk) ) then
			out_q <= in_addr;
		end if;
	end process;
end pc_comp_arch;
