--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:53:10 03/16/2016
-- Design Name:   
-- Module Name:   D:/UNI/Masterarbeit/Programming/HDL/Stage2/Testbench_spi_wapper.vhd
-- Project Name:  Stage2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spi_wishbone_wrapper
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Testbench_spi_wapper IS
END Testbench_spi_wapper;
 
ARCHITECTURE behavior OF Testbench_spi_wapper IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_wishbone_wrapper
    PORT(
         mosi : IN  std_logic;
         ss : IN  std_logic;
         sck : IN  std_logic;
         miso : OUT  std_logic;
         gls_reset : IN  std_logic;
         gls_clk : IN  std_logic;
         wbm_address : OUT  std_logic_vector(15 downto 0);
         wbm_readdata : IN  std_logic_vector(15 downto 0);
         wbm_writedata : OUT  std_logic_vector(15 downto 0);
         wbm_strobe : OUT  std_logic;
         wbm_write : OUT  std_logic;
         wbm_ack : IN  std_logic;
         wbm_cycle : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal mosi : std_logic := '0';
   signal ss : std_logic := '0';
   signal sck : std_logic := '0';
   signal gls_reset : std_logic := '0';
   signal gls_clk : std_logic := '0';
   signal wbm_readdata : std_logic_vector(15 downto 0) := (others => '0');
   signal wbm_ack : std_logic := '0';

 	--Outputs
   signal miso : std_logic;
   signal wbm_address : std_logic_vector(15 downto 0);
   signal wbm_writedata : std_logic_vector(15 downto 0);
   signal wbm_strobe : std_logic;
   signal wbm_write : std_logic;
   signal wbm_cycle : std_logic;

   -- Clock period definitions
   constant gls_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_wishbone_wrapper PORT MAP (
          mosi => mosi,
          ss => ss,
          sck => sck,
          miso => miso,
          gls_reset => gls_reset,
          gls_clk => gls_clk,
          wbm_address => wbm_address,
          wbm_readdata => wbm_readdata,
          wbm_writedata => wbm_writedata,
          wbm_strobe => wbm_strobe,
          wbm_write => wbm_write,
          wbm_ack => wbm_ack,
          wbm_cycle => wbm_cycle
        );

   -- Clock process definitions
   gls_clk_process :process
   begin
		sck <= '0';
		wait for gls_clk_period/2*2;
		sck <= '1';
		wait for gls_clk_period/2*2;
   end process;
   
   s_clk_process :process
   begin
		gls_clk <= '0';
		wait for gls_clk_period/2;
		gls_clk <= '1';
		wait for gls_clk_period/2;
   end process;
 
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		ss <= '1';
		wait for 50 ns;
			ss<= '0';
      wait for gls_clk_period*11;
	  mosi <= '1';
	  wait for 10ns;
	  	  mosi <= '0';
	  wait for 10ns;
	  	  mosi <= '1';
	  wait for 10ns;
	  	  	  mosi <= '0';
	  wait for 10ns;
	  	  mosi <= '1';
	  wait for 10ns;
	  	  mosi <= '0';
	  wait for 10ns;
	  	  mosi <= '1';
	  wait for 10ns;
	  	  	  mosi <= '0';
	  wait for 10ns;


      -- insert stimulus here 

      --wait;
   end process;

END;
