

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector is
	  Port ( clk               : in  STD_LOGIC;
				 signal_in   : in  STD_LOGIC;
				 output         : out  STD_LOGIC);
end edge_detector;

architecture Behavioral of edge_detector is
         signal signal_d:STD_LOGIC;
    begin
        process(clk)
			begin
        if clk= '1' and clk'event then
               signal_d<=signal_in;
        end if;
	end process;
    output<= (not signal_in) and signal_d ; 
end Behavioral;