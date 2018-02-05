library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity sign_ext is
port( 	in16	: in std_logic_vector(15 downto 0);
	func_se	: in std_logic_vector(1 downto 0);
      	out32	: out std_logic_vector(31 downto 0));
end sign_ext;

architecture se_arch of sign_ext is

begin
	process(in16, func_se)
	begin
		case func_se is
			when "00" => out32 <= in16(15 downto 0) & X"0000"; -- lui
			when "01" | "10" => out32 <= (31 downto 16 => in16(15)) & in16(15 downto 0); -- slti, arith
			-- when "10" => out32 <= (31 downto 16 => in16(15)) & in16(15 downto 0);
			when "11" => out32 <= X"0000" & in16(15 downto 0); -- logical
			when others =>
		end case;
	end process;
end se_arch;
