--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:00:28 04/12/2016
-- Design Name:   
-- Module Name:   D:/UNI/Masterarbeit/Programming/HDL/Stage2/testbench_new_output_stage2.vhd
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
 
ENTITY testbench_new_output_stage2 IS
END testbench_new_output_stage2;
 
ARCHITECTURE behavior OF testbench_new_output_stage2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Stage2
    PORT(
         OSC_FPGA : IN  std_logic;
         SPIM1_SCLK : INOUT  std_logic;
         SPIM2_SCLK : INOUT  std_logic;
         SPIM3_SCLK : INOUT  std_logic;
         SPIM4_SCLK : INOUT  std_logic;
         SPIM5_SCLK : INOUT  std_logic;
         SPIM6_SCLK : INOUT  std_logic;
         SPIM1_MISO : IN  std_logic;
         SPIM2_MISO : IN  std_logic;
         SPIM3_MISO : IN  std_logic;
         SPIM4_MISO : IN  std_logic;
         SPIM5_MISO : IN  std_logic;
         SPIM6_MISO : IN  std_logic;
         SPIM1_MOSI : OUT  std_logic;
         SPIM2_MOSI : OUT  std_logic;
         SPIM3_MOSI : OUT  std_logic;
         SPIM4_MOSI : OUT  std_logic;
         SPIM5_MOSI : OUT  std_logic;
         SPIM6_MOSI : OUT  std_logic;
         SPIM1_CS : INOUT  std_logic_vector(1 downto 0);
         SPIM2_CS : INOUT  std_logic_vector(1 downto 0);
         SPIM3_CS : INOUT  std_logic_vector(1 downto 0);
         SPIM4_CS : INOUT  std_logic_vector(1 downto 0);
         SPIM5_CS : INOUT  std_logic_vector(1 downto 0);
         SPIM6_CS : INOUT  std_logic_vector(1 downto 0);
         pmod2 : OUT  std_logic;
         SYS_SPI_SCK : IN  std_logic;
         RP_SPI_CE0N : IN  std_logic;
         SYS_SPI_MOSI : IN  std_logic;
         SYS_SPI_MISO : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal OSC_FPGA : std_logic := '0';
   signal SPIM1_MISO : std_logic := '0';
   signal SPIM2_MISO : std_logic := '0';
   signal SPIM3_MISO : std_logic := '0';
   signal SPIM4_MISO : std_logic := '0';
   signal SPIM5_MISO : std_logic := '0';
   signal SPIM6_MISO : std_logic := '0';
   signal SYS_SPI_SCK : std_logic := '0';
   signal RP_SPI_CE0N : std_logic := '0';
   signal SYS_SPI_MOSI : std_logic := '0';

	--BiDirs
   signal SPIM1_SCLK : std_logic;
   signal SPIM2_SCLK : std_logic;
   signal SPIM3_SCLK : std_logic;
   signal SPIM4_SCLK : std_logic;
   signal SPIM5_SCLK : std_logic;
   signal SPIM6_SCLK : std_logic;
   signal SPIM1_CS : std_logic_vector(1 downto 0);
   signal SPIM2_CS : std_logic_vector(1 downto 0);
   signal SPIM3_CS : std_logic_vector(1 downto 0);
   signal SPIM4_CS : std_logic_vector(1 downto 0);
   signal SPIM5_CS : std_logic_vector(1 downto 0);
   signal SPIM6_CS : std_logic_vector(1 downto 0);

 	--Outputs
   signal SPIM1_MOSI : std_logic;
   signal SPIM2_MOSI : std_logic;
   signal SPIM3_MOSI : std_logic;
   signal SPIM4_MOSI : std_logic;
   signal SPIM5_MOSI : std_logic;
   signal SPIM6_MOSI : std_logic;
   signal pmod2 : std_logic;
   signal SYS_SPI_MISO : std_logic;

   -- Clock period definitions
   constant SPIM1_SCLK_period : time := 40 ns;
   constant SPIM2_SCLK_period : time := 10 ns;
   constant SPIM3_SCLK_period : time := 10 ns;
   constant SPIM4_SCLK_period : time := 10 ns;
   constant SPIM5_SCLK_period : time := 10 ns;
   constant SPIM6_SCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Stage2 PORT MAP (
          OSC_FPGA => OSC_FPGA,
          SPIM1_SCLK => SPIM1_SCLK,
          SPIM2_SCLK => SPIM2_SCLK,
          SPIM3_SCLK => SPIM3_SCLK,
          SPIM4_SCLK => SPIM4_SCLK,
          SPIM5_SCLK => SPIM5_SCLK,
          SPIM6_SCLK => SPIM6_SCLK,
          SPIM1_MISO => SPIM1_MISO,
          SPIM2_MISO => SPIM2_MISO,
          SPIM3_MISO => SPIM3_MISO,
          SPIM4_MISO => SPIM4_MISO,
          SPIM5_MISO => SPIM5_MISO,
          SPIM6_MISO => SPIM6_MISO,
          SPIM1_MOSI => SPIM1_MOSI,
          SPIM2_MOSI => SPIM2_MOSI,
          SPIM3_MOSI => SPIM3_MOSI,
          SPIM4_MOSI => SPIM4_MOSI,
          SPIM5_MOSI => SPIM5_MOSI,
          SPIM6_MOSI => SPIM6_MOSI,
          SPIM1_CS => SPIM1_CS,
          SPIM2_CS => SPIM2_CS,
          SPIM3_CS => SPIM3_CS,
          SPIM4_CS => SPIM4_CS,
          SPIM5_CS => SPIM5_CS,
          SPIM6_CS => SPIM6_CS,
          pmod2 => pmod2,
          SYS_SPI_SCK => SYS_SPI_SCK,
          RP_SPI_CE0N => RP_SPI_CE0N,
          SYS_SPI_MOSI => SYS_SPI_MOSI,
          SYS_SPI_MISO => SYS_SPI_MISO
        );

   -- Clock process definitions
	  SDRAM_CLK_process :process
   begin

		OSC_FPGA <= '0';
		wait for SPIM1_SCLK_period/2;
		
		OSC_FPGA <= '1';
		wait for SPIM1_SCLK_period/2;
		
   end process;

   -- Clock process definitions
   SPIM1_SCLK_process :process
   begin
				SYS_SPI_SCK <= '0';
		wait for SPIM1_SCLK_period/5;
		SYS_SPI_SCK <= '1';
		wait for SPIM1_SCLK_period/5;
   end process;

--   SPIM1_SCLK_process :process
--   begin
--		SPIM1_SCLK <= '0';
--		wait for SPIM1_SCLK_period/2;
--		SPIM1_SCLK <= '1';
--		wait for SPIM1_SCLK_period/2;
--   end process;
-- 
--   SPIM2_SCLK_process :process
--   begin
--		SPIM2_SCLK <= '0';
--		wait for SPIM2_SCLK_period/2;
--		SPIM2_SCLK <= '1';
--		wait for SPIM2_SCLK_period/2;
--   end process;
-- 
--   SPIM3_SCLK_process :process
--   begin
--		SPIM3_SCLK <= '0';
--		wait for SPIM3_SCLK_period/2;
--		SPIM3_SCLK <= '1';
--		wait for SPIM3_SCLK_period/2;
--   end process;
-- 
--   SPIM4_SCLK_process :process
--   begin
--		SPIM4_SCLK <= '0';
--		wait for SPIM4_SCLK_period/2;
--		SPIM4_SCLK <= '1';
--		wait for SPIM4_SCLK_period/2;
--   end process;
-- 
--   SPIM5_SCLK_process :process
--   begin
--		SPIM5_SCLK <= '0';
--		wait for SPIM5_SCLK_period/2;
--		SPIM5_SCLK <= '1';
--		wait for SPIM5_SCLK_period/2;
--   end process;
-- 
--   SPIM6_SCLK_process :process
--   begin
--		SPIM6_SCLK <= '0';
--		wait for SPIM6_SCLK_period/2;
--		SPIM6_SCLK <= '1';
--		wait for SPIM6_SCLK_period/2;
--   end process;
-- 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		
		RP_SPI_CE0N <= '0';
      wait for 7586 ns;	
		RP_SPI_CE0N <= '1';

      wait for SPIM1_SCLK_period*10;

      -- insert stimulus here 

      --wait;
   end process;
	
	 stim_proc2: process
   begin		
      -- hold reset state for 100 ns.
		
		
      
		spim1_miso <= '1';
      wait for SPIM2_SCLK_period;
		spim1_miso <= '0';
		wait for SPIM2_SCLK_period;
		spim1_miso <= '1';		
	  wait for SPIM2_SCLK_period;
		spim1_miso <= '0';

    
   end process;

END;
