--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:46:05 04/01/2016
-- Design Name:   
-- Module Name:   D:/UNI/Masterarbeit/Programming/HDL/Stage2/testbench_timesim.vhd
-- Project Name:  Stage2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Stage2
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
 
ENTITY testbench_timesim IS
END testbench_timesim;
 
ARCHITECTURE behavior OF testbench_timesim IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Stage2
    PORT(
         OSC_FPGA : IN  std_logic;
         PB : IN  std_logic_vector(1 downto 0);
         SW : IN  std_logic_vector(1 downto 0);
         LED : OUT  std_logic_vector(1 downto 0);
         PMOD3 : INOUT  std_logic_vector(7 downto 0);
         PMOD4 : INOUT  std_logic_vector(7 downto 0);
         PMOD2 : INOUT  std_logic_vector(7 downto 0);
         PMOD1 : INOUT  std_logic_vector(7 downto 0);
         SDRAM_CLK : OUT  std_logic;
         SDRAM_CKE : OUT  std_logic;
         SDRAM_CS : OUT  std_logic;
         SDRAM_nRAS : OUT  std_logic;
         SDRAM_nCAS : OUT  std_logic;
         SDRAM_nWE : OUT  std_logic;
         SDRAM_DQM : OUT  std_logic_vector(1 downto 0);
         SDRAM_ADDR : OUT  std_logic_vector(12 downto 0);
         SDRAM_BA : OUT  std_logic_vector(1 downto 0);
         SDRAM_DQ : INOUT  std_logic_vector(15 downto 0);
         SYS_SPI_SCK : IN  std_logic;
         RP_SPI_CE0N : IN  std_logic;
         SYS_SPI_MOSI : IN  std_logic;
         SYS_SPI_MISO : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal OSC_FPGA : std_logic := '0';
   signal PB : std_logic_vector(1 downto 0) := (others => '0');
   signal SW : std_logic_vector(1 downto 0) := (others => '0');
   signal SYS_SPI_SCK : std_logic := '0';
   signal RP_SPI_CE0N : std_logic := '0';
   signal SYS_SPI_MOSI : std_logic := '0';

	--BiDirs
   signal PMOD3 : std_logic_vector(7 downto 0);
   signal PMOD4 : std_logic_vector(7 downto 0);
   signal PMOD2 : std_logic_vector(7 downto 0);
   signal PMOD1 : std_logic_vector(7 downto 0);
   signal SDRAM_DQ : std_logic_vector(15 downto 0);

 	--Outputs
   signal LED : std_logic_vector(1 downto 0);
   signal SDRAM_CLK : std_logic;
   signal SDRAM_CKE : std_logic;
   signal SDRAM_CS : std_logic;
   signal SDRAM_nRAS : std_logic;
   signal SDRAM_nCAS : std_logic;
   signal SDRAM_nWE : std_logic;
   signal SDRAM_DQM : std_logic_vector(1 downto 0);
   signal SDRAM_ADDR : std_logic_vector(12 downto 0);
   signal SDRAM_BA : std_logic_vector(1 downto 0);
   signal SYS_SPI_MISO : std_logic;

   -- Clock period definitions
   constant SDRAM_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Stage2 PORT MAP (
          OSC_FPGA => OSC_FPGA,
          PB => PB,
          SW => SW,
          LED => LED,
          PMOD3 => PMOD3,
          PMOD4 => PMOD4,
          PMOD2 => PMOD2,
          PMOD1 => PMOD1,
          SDRAM_CLK => SDRAM_CLK,
          SDRAM_CKE => SDRAM_CKE,
          SDRAM_CS => SDRAM_CS,
          SDRAM_nRAS => SDRAM_nRAS,
          SDRAM_nCAS => SDRAM_nCAS,
          SDRAM_nWE => SDRAM_nWE,
          SDRAM_DQM => SDRAM_DQM,
          SDRAM_ADDR => SDRAM_ADDR,
          SDRAM_BA => SDRAM_BA,
          SDRAM_DQ => SDRAM_DQ,
          SYS_SPI_SCK => SYS_SPI_SCK,
          RP_SPI_CE0N => RP_SPI_CE0N,
          SYS_SPI_MOSI => SYS_SPI_MOSI,
          SYS_SPI_MISO => SYS_SPI_MISO
        );

   -- Clock process definitions
   SDRAM_CLK_process :process
   begin
		OSC_FPGA <= '0';
		wait for SDRAM_CLK_period/2;
		OSC_FPGA <= '1';
		wait for SDRAM_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for SDRAM_CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
