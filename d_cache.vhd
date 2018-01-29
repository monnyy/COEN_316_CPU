library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity d_cache is
port(	input	 : in std_logic_vector(31 downto 0);
	reset	 : in std_logic;
      	clk	 : in std_logic;
	addr	 : in std_logic_vector(4 downto 0);
      data_write : in std_logic;
      	output	 : out std_logic_vector(31 downto 0));
end d_cache;

architecture dc_arch of d_cache is

-- declare internal signals
type Locations is array(0 to 31) of std_logic_vector(31 downto 0);
signal L: Locations;

begin
	output <= L(conv_integer(addr));

	process(input, reset, clk, data_write, addr)
	begin
		if (reset = '1') then
			for i in L'range loop
				L(i) <= (others => '0');
			end loop;

		elsif( rising_edge(clk) ) then
			if ( data_write = '1' ) then
				L(conv_integer(addr)) <= input;
			end if;
		end if;
	end process;
end dc_arch;
