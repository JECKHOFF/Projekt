--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:12:04 03/24/2016
-- Design Name:   
-- Module Name:   D:/UNI/Masterarbeit/Programming/HDL/Stage2/Testbench_stage2.vhd
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
 
ENTITY Testbench_stage2 IS
END Testbench_stage2;
 
ARCHITECTURE behavior OF Testbench_stage2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Stage2
    PORT(
         OSC_FPGA : IN  std_logic;        
--			PB : IN  std_logic_vector(1 downto 0);
--         SW : IN  std_logic_vector(1 downto 0);
--         LED : OUT  std_logic_vector(1 downto 0);
--
  		SPIM1_SCLK: inout STD_LOGIC;
		SPIM2_SCLK: inout STD_LOGIC;
		SPIM3_SCLK: inout STD_LOGIC;
		SPIM4_SCLK: inout STD_LOGIC;
		SPIM5_SCLK: inout STD_LOGIC;
		SPIM6_SCLK: inout STD_LOGIC;
		
		SPIM1_MISO: in STD_LOGIC;
		SPIM2_MISO: in STD_LOGIC;
		SPIM3_MISO: in STD_LOGIC;
		SPIM4_MISO: in STD_LOGIC;
		SPIM5_MISO: in STD_LOGIC;
		SPIM6_MISO: in STD_LOGIC;
		
		SPIM1_MOSI:  out STD_LOGIC;
		SPIM2_MOSI:  out STD_LOGIC;
		SPIM3_MOSI:  out STD_LOGIC;
		SPIM4_MOSI:  out STD_LOGIC;
		SPIM5_MOSI:  out STD_LOGIC;
		SPIM6_MOSI:  out STD_LOGIC;
		
		
		SPIM1_CS: inout std_logic_vector(1 downto 0);
		SPIM2_CS: inout std_logic_vector(1 downto 0);
		SPIM3_CS: inout std_logic_vector(1 downto 0);
		SPIM4_CS: inout std_logic_vector(1 downto 0);
		SPIM5_CS: inout std_logic_vector(1 downto 0);
		SPIM6_CS: inout std_logic_vector(1 downto 0);
		
		pmod2: out std_logic;
		
			
			SYS_SPI_SCK, RP_SPI_CE0N, SYS_SPI_MOSI : in std_logic ;
			SYS_SPI_MISO : out std_logic

        );
    END COMPONENT;
    

   --Inputs
   signal OSC_FPGA : std_logic := '0';
--   signal PB : std_logic_vector(1 downto 0) := (others => '0');
--   signal SW : std_logic_vector(1 downto 0) := (others => '0');
   signal SYS_SPI_SCK : std_logic := '0';
   signal RP_SPI_CE0N : std_logic := '0';
   signal SYS_SPI_MOSI : std_logic := '0';

	--BiDirs
   signal PMOD3 : std_logic_vector(7 downto 0);
   signal PMOD4 : std_logic_vector(7 downto 0);
   signal PMOD2 : std_logic_vector(7 downto 0):= (others => '0');
   signal PMOD1 : std_logic_vector(7 downto 0):= (others => '0');
  
 	--Outputs
   --signal LED : std_logic_vector(1 downto 0);

   signal SYS_SPI_MISO : std_logic;

   -- Clock period definitions
   constant SDRAM_CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Stage2 PORT MAP (
          OSC_FPGA => OSC_FPGA,
--          PB => PB,
--          SW => SW,
--          LED => LED,
          PMOD3 => PMOD3,
          PMOD4 => PMOD4,
          PMOD2 => PMOD2,
          PMOD1 => PMOD1,

          SYS_SPI_SCK => SYS_SPI_SCK,
          RP_SPI_CE0N => RP_SPI_CE0N,
          SYS_SPI_MOSI => SYS_SPI_MOSI,
          SYS_SPI_MISO => SYS_SPI_MISO
        );

   -- Clock process definitions
  SDRAM_CLK_process :process
   begin
		SYS_SPI_SCK <= '0';
		wait for SDRAM_CLK_period;
		SYS_SPI_SCK <= '1';
		wait for SDRAM_CLK_period;
   end process;
	
	
  CLK_process :process
   begin
		OSC_FPGA <= '0';
		--SYS_SPI_SCK <= '0';
		wait for SDRAM_CLK_period/2;
		OSC_FPGA <= '1';
		--SYS_SPI_SCK <= '1';
	wait for SDRAM_CLK_period/2;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
		--pmod1(1) <= '0';
      -- hold reset state for 100 ns.
				
	--PB(0) <= '1';
--		wait for SDRAM_CLK_period;	
--PB(0) <= '1';
--      wait for 100 ns;	

--      wait for SDRAM_CLK_period*10;
   RP_SPI_CE0N <= '0';
   SYS_SPI_MOSI <= '0';	
		pmod1(6) <= '0';
		pmod1(1) <= '0';
		wait for SDRAM_CLK_period;	
		pmod1(1) <= '1';
		pmod1(6) <= '1';
		SYS_SPI_MOSI <= '1';	
		--SPIM_1_busy<= '0';
	--	sys_spi_miso <= '1';
		wait for SDRAM_CLK_period;
--		pmod1(6) <= '0';
--		pmod1(1) <= '0';
--		wait for SDRAM_CLK_period;	
--		pmod1(1) <= '1';
--		pmod1(6) <= '1';
--		sys_spi_miso <= '1';
--		wait for SDRAM_CLK_period;
--		pmod1(2) <= '0';
--		pmod1(1) <= '0';
--		wait for SDRAM_CLK_period;	
--
--		pmod1(2) <= '1';
--		pmod1(1) <= '1';
--		wait for SDRAM_CLK_period;
--		pmod1(2) <= '0';
--		pmod1(1) <= '0';
--		wait for SDRAM_CLK_period;
--		pmod1(2) <= '1';
--		pmod1(1) <= '1';
--		wait for SDRAM_CLK_period;
--		pmod1(2) <= '0';
--		pmod1(1) <= '0';
--		wait for SDRAM_CLK_period;	
--		pmod1(2) <= '1';
--		pmod1(1) <= '1';
--		wait for SDRAM_CLK_period;
--		pmod1(2) <= '0';
--		pmod1(1) <= '0';
--		wait for SDRAM_CLK_period;				


      -- insert stimulus here 
--wait;
   end process;
	
			pmod1(6) <= '0';
		pmod1(1) <= '0';
	--	wait for 10 ns;	
		pmod1(1) <= '1';
		pmod1(6) <= '1';
	--	sys_spi_miso <= '1';
	--	wait for 10 ns;

END;
