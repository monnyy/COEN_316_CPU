library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;

entity next_address is
port(	
	rt,rs	    	: in std_logic_vector(31 downto 0);  -- two register input
	pc		: in std_logic_vector(31 downto 0);
	target_address	: in std_logic_vector(25 downto 0);
	branch_type	: in std_logic_vector(1 downto 0);
	pc_sel	    	: in std_logic_vector(1 downto 0);
	next_pc	    	: out std_logic_vector(31 downto 0));
end next_address;

architecture pc_arch of next_address is

-- declare internal signal
signal pc_host: std_logic_vector(31 downto 0);

begin
	process(rt, rs, pc, pc_sel, branch_type, target_address, pc_host)
	begin
		case pc_sel is
			when "00" => next_pc <= pc_host;
			when "01" => next_pc <= "000000" & target_address(25 downto 0);
			when "10" => next_pc <= rs;
			when others =>
		end case;

		case branch_type is
			when "00" => pc_host <= pc + X"00000001";
			when "01" => 
				     if (rs = rt) then
					 pc_host <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0));
				     else
					 pc_host <= pc + X"00000001";
				     end if;
			when "10" => 
				     if (rs /= rt) then
					 pc_host <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0));
				     else
					 pc_host <= pc + X"00000001";
				     end if;
			when "11" =>
				     if (rs < 0) then
					 pc_host <= pc + X"00000001" + ((31 downto 16 => target_address(15)) & target_address(15 downto 0));
				     else
					 pc_host <= pc + X"00000001";
				     end if;
			when others =>
		end case;
	end process;
end pc_arch;
