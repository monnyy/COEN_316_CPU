library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity i_cache is
port( input_addr: in std_logic_vector(4 downto 0);
      	instr	: out std_logic_vector(31 downto 0));
end i_cache;

architecture ic_arch of i_cache is

begin
	process(input_addr)
	begin
		case input_addr is
                                                                         --  op  rd, rs, rt
										                                 --  op rs rt imm
										                                 --  op target address
			when "00000" => instr <= "00100000000000110000000000000000"; -- addi r3, r0, 0
			when "00001" => instr <= "00000000001000010000100000100010"; -- sub r1, r1, r1
			when "00010" => instr <= "00100000000000100000000000000101"; -- addi r2, r0, 5
			when "00011" => instr <= "00000000001000100000100000100000"; -- add r1, r1, r2
			when "00100" => instr <= "00100000010000101111111111111111"; -- addi r2, r2, -1
			when "00101" => instr <= "00010000010000110000000000000001"; -- beq r2, r3 (+1) THERE
			when "00110" => instr <= "00001000000000000000000000000011"; -- jump 3 (LOOP)
			when "00111" => instr <= "10101100000000010000000000000000"; -- sw r1, 0(r0)  
			when "01000" => instr <= "10001100000001000000000000000000"; -- lw r4, 0(r0)
			when "01001" => instr <= "00110000100001000000000000001010"; -- andi r4, r4, 0x000A
			when "01010" => instr <= "00110100100001010000000000000001"; -- ori r5, r4, 0x0001
			when "01011" => instr <= "00111000100001100000000000001011"; -- xori r6, r4, 0xB
			when "01100" => instr <= "00101000100001110000000000000000"; -- slti r7, r4, 0x0000
			when "01101" => instr <= "00111101000000001100010010000001"; -- lui r8, r4, 0x0000 // back to this
			when "01110" => instr <= "00000000110001110011100000100100"; -- and r7, r6, r7
			when "01111" => instr <= "00000000101001100100000000100101"; -- or r8, r5, r6
			when "10000" => instr <= "00000000100001110100000000100110"; -- xor r4, r7, r8
			when "10001" => instr <= "00000100101000000000000000010101"; -- bltz r5, 0x0015
			when "10010" => instr <= "00000000100001010011100000101010"; -- slt r7, r4, r5
			when "10011" => instr <= "00010100111001110000000000010100"; -- bne r4, r7, 0x0014
			when "10100" => instr <= "00000000001010000000100000100111"; -- nor r1, r1, r8
			when "10101" => instr <= "00000000100000000000000000001000"; -- jr r4
			when others  => instr <= "00000000000000000000000000000000"; -- dont care
		end case;
	end process;
end ic_arch;
