library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity alu_ctrl is
port(
	alu_op	 : in  std_logic_vector(1 downto 0);
	instr_in : in  std_logic_vector(31 downto 0);
	alu_instr: out std_logic_vector(3 downto 0)
);
end entity alu_ctrl;

architecture behaviour of alu_ctrl is
	signal funct3 : std_logic_vector(2 downto 0);
	signal funct7 : std_logic_vector(6 downto 0);
begin
	funct3 <= instr_in(14 downto 12);
	funct7 <= instr_in(31 downto 25);

	control: process(alu_op, instr_in)
	begin
		case alu_op is
		--R-Type
			when "10" =>
				--ADD
				if funct3 = "000" and funct7 = "0000000" then
					alu_instr <= "0010";
				--SUB
				elsif funct3 = "000" and funct7 = "0100000" then
					alu_instr <= "0110";
				--SLT
				elsif funct3 = "010" and funct7 = "0000000" then
					alu_instr <= "0111";
				--OR
				elsif funct3 = "110" and funct7 = "0000000" then
					alu_instr <= "0001";
				--AND
				elsif funct3 = "111" and funct7 = "0000000" then
					alu_instr <= "0010";
				--others to AND
				else
					alu_instr <= "0100";
				end if;
		--B-Type
			when "01" =>
				alu_instr <= "0110";
		--S-Type
			when "00" =>
				alu_instr <= "0010";
		--Avoid Latch
			when others =>
				alu_instr <= "1111";
		end case;
	end process control;
end architecture behaviour;