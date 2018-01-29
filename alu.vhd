library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity alu is
port(	
	x,y	    : in std_logic_vector(31 downto 0);  -- two input operands
	add_sub     : in std_logic;			 -- 0 = add, 1 = sub
	logic_func  : in std_logic_vector(1 downto 0);   -- 00 = AND, 01 = OR, 10 = XOR, 11 = NOR
	func	    : in std_logic_vector(1 downto 0);   -- 00 = lui, 01 = setless, 10 = arith, 11 = logic

	output	    : out std_logic_vector(31 downto 0);
	ovrflw    : out std_logic;
	zro	    : out std_logic);
end alu;

architecture alu_arch of alu is

-- declare internal signal
signal ans, logic_unit: std_logic_vector(31 downto 0);
signal over_check : std_logic_vector(2 downto 0);

begin

	process(x, y, func, logic_func, add_sub, ans, logic_unit, over_check)
	begin	

		over_check <= x(x'high) & y(y'high) & ans(ans'high);

		case add_sub is
			when '0' => ans <= x + y;
				    if ((over_check = "001") OR (over_check = "110")) then
					ovrflw <= '1';
				    else
					ovrflw <= '0';
				    end if;
			when '1' => ans <= x - y;
				    if ((over_check = "100") OR (over_check = "011")) then
					ovrflw <= '1';
				    else
					ovrflw <= '0';
				    end if;
			when others =>
		end case;


		if  (ans = (ans'range => '0')) then
			zro <= '1';
		else
			zro <= '0';
		end if;


		case logic_func is
			when "00" => logic_unit <= x and y;
			when "01" => logic_unit <= x or y;
			when "10" => logic_unit <= x xor y;
			when "11" => logic_unit <= x nor y;
			when others =>
		end case;


		case func is
			when "00" => output <= y;
			when "01" => output <= "0000000000000000000000000000000" & ans(31);
			when "10" => output <= ans;
			when "11" => output <= logic_unit;
			when others =>
		end case;
	end process;
end alu_arch;
