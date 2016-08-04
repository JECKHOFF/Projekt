----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:36:57 03/16/2016 
-- Design Name: 
-- Module Name:    Stage2 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

--package atr_pack is

--	attribute IOB: string;
-- attribute IOB of iob_command: signal is "true";
 
-- end package atr_pack;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work ;
use work.logi_wishbone_pack.all ;
use work.logi_wishbone_peripherals_pack.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;
use IEEE.NUMERIC_STD.ALL;



entity Stage2 is

	-- GENERIC (
		-- Values_to_store  : INTEGER := 100000  
	-- );

    Port ( OSC_FPGA : in std_logic;

		--onboard
		--PB : in std_logic_vector(1 downto 0);
		--SW : in std_logic_vector(1 downto 0);

		LED : out std_logic_vector(1 downto 0);	
		
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
end Stage2;

architecture Behavioral of Stage2 is


	component clock_gen
		port
		(-- Clock in ports
			CLK_IN1           : in     std_logic;
			-- Clock out ports
			CLK_OUT1          : out    std_logic;
			-- Status and control signals
			LOCKED            : out    std_logic
		);
	end component;
	
	component edge_detector is
          Port ( clk               : in  STD_LOGIC;
                     signal_in   : in  STD_LOGIC;
                     output         : out  STD_LOGIC);
    end component;
	
component spi_slave is
    Generic (   
        N : positive := 16;                                             -- 32bit serial word length is default
        CPOL : std_logic:= '0';                                        -- SPI mode selection (mode 0 default)
        CPHA : std_logic := '0';                                        -- CPOL = clock polarity, CPHA = clock phase.
        PREFETCH : positive :=3);                                      -- prefetch lookahead cycles
    Port (  
        clk_i : in std_logic ;                                    -- internal interface clock (clocks di/do registers)
        spi_ssel_i : in std_logic ;                               -- spi bus slave select line
        spi_sck_i : in std_logic;                                -- spi bus sck clock (clocks the shift register core)
        spi_mosi_i : in std_logic ;                               -- spi bus mosi input
        spi_miso_o : out std_logic;                              -- spi bus spi_miso_o output
        di_req_o : out std_logic;                                       -- preload lookahead data request line
        di_i : in  std_logic_vector (N-1 downto 0);  -- parallel load data in (clocked in on rising edge of clk_i)
        wren_i : in std_logic;                                   -- user data write enable
        wr_ack_o : out std_logic;                                       -- write acknowledge
        do_valid_o : out std_logic;                                     -- do_o data valid strobe, valid during one clk_i rising edge.
        do_o : out  std_logic_vector (N-1 downto 0)                    -- parallel output (clocked out on falling clk_i)
    );                      
end component;
	

	component spi_master IS  GENERIC(
			 slaves  : INTEGER := 4;  --number of spi slaves
			 d_width : INTEGER := 8); --data bus width
		  PORT(
			 clock   : IN     STD_LOGIC;                             --system clock
			 reset_n : IN     STD_LOGIC;                             --asynchronous reset
			 enable  : IN     STD_LOGIC;                             --initiate transaction
			 cpol    : IN     STD_LOGIC;                             --spi clock polarity
			 cpha    : IN     STD_LOGIC;                             --spi clock phase
			 cont    : IN     STD_LOGIC;                             --continuous mode command
			 clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
			 addr    : IN     INTEGER;                               --address of slave
			 tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
			 miso    : IN     STD_LOGIC;                             --master in, slave out
			 sclk    : INOUT STD_LOGIC;                             --spi clock
			 ss_n    : INOUT STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
			 mosi    : OUT    STD_LOGIC;                             --master out, slave in
			 busy    : OUT    STD_LOGIC;                             --busy / data ready signal
			 rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
	END component;
	
	signal sys_reset, sys_resetn,sys_clk, clock_locked : std_logic ;
	signal clk_100Mhz : std_logic ;
	
    signal       data_out          :  STD_LOGIC_VECTOR(31 downto 0); -- word read from SDRAM
    signal       data_out_ready    :  STD_LOGIC;                     -- is new data ready?	
	
	signal		enable_spi_reciever :STD_LOGIC := '0';
	signal		SPIM_all_reset :STD_LOGIC := '0';
	signal		SPIM_all_enable :STD_LOGIC := '0';
	signal		SPIM_all_addr 	:integer := 0;
	signal		SPIM_all_cpha	:STD_LOGIC := '0';
	signal		SPIM_all_cpol	:STD_LOGIC := '0';
	signal		SPIM_all_clk_div : INTEGER := 0;
	signal		SPIM_all_cont : STD_LOGIC := '0';
	signal		SPIM_all_tx_data : STD_LOGIC_VECTOR(7 downto 0);
	
	-- signal 		write_ready_slv1 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv2 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv3 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv4 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv5 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv6 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv7 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv8 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv9 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv10 : STD_LOGIC := '0'; 
	-- signal 		write_ready_slv11: STD_LOGIC := '0'; 
	-- signal 		write_ready_slv12 : STD_LOGIC := '0'; 
	
	signal 		write_done_slv1 : STD_LOGIC := '0'; 
	signal 		write_done_slv2 : STD_LOGIC := '0'; 
	signal 		write_done_slv3 : STD_LOGIC := '0'; 
	signal 		write_done_slv4 : STD_LOGIC := '0'; 
	signal 		write_done_slv5 : STD_LOGIC := '0'; 
	signal 		write_done_slv6 : STD_LOGIC := '0'; 
	signal 		write_done_slv7 : STD_LOGIC := '0'; 
	signal 		write_done_slv8 : STD_LOGIC := '0'; 
	signal 		write_done_slv9 : STD_LOGIC := '0'; 
	signal 		write_done_slv10 : STD_LOGIC := '0'; 
	signal 		write_done_slv11 : STD_LOGIC := '0'; 
	signal 		write_done_slv12 : STD_LOGIC := '0'; 
	
	signal		SPIM1_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM2_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM3_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM4_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM5_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM6_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM7_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM8_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM9_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM10_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM11_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM12_data_in 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	
	signal		SPIM1_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM2_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM3_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM4_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM5_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM6_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM7_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM8_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM9_data_out 		:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM10_data_out 	:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM11_data_out 	:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	signal		SPIM12_data_out 	:STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
	
	signal		bank1_vaild_data 	:STD_LOGIC := '0';
	signal		bank2_vaild_data 	:STD_LOGIC := '0';
	signal		bank1_vaild_output 	:STD_LOGIC := '0';
	signal		bank2_vaild_output 	:STD_LOGIC := '0';
	signal		bank1_data_written 	:STD_LOGIC := '0';
	signal		bank2_data_written 	:STD_LOGIC := '0';
	signal		write_disable 	:STD_LOGIC := '0';
	signal		valid_data_for_SDRAM 	:STD_LOGIC := '0';
	signal		Byte_to_recvice 	:STD_LOGIC := '0';
	signal 		SLAVE_sel		: STD_LOGIC:= '0';
	signal		data_recieved	:STD_LOGIC := '0';
	signal		reset_counter	:STD_LOGIC := '0';
	signal		counter			:integer	:= 0;
	
	signal		SDRAM_read			:STD_LOGIC	:= '0';
	signal		SDRAM_write			:STD_LOGIC	:= '0';
	
	signal SPIS_di_req_o_buf :  std_logic:= '0';                                       -- preload lookahead data request line
	signal SPIS_di_req_o :  std_logic:= '0';                                       -- preload lookahead data request line
    signal SPIS_di_i :   std_logic_vector (7 downto 0) := (others => '0');  -- parallel load data in (clocked in on rising edge of clk_i)
    signal SPIS_wren_i :  std_logic := '0';                                   -- user data write enable
    signal SPIS_wr_ack_o :  std_logic:= '0';                                       -- write acknowledge
    signal SPIS_do_valid_o :  std_logic:= '0';                                     -- do_o data valid strobe, valid during one clk_i rising edge.
    signal SPIS_do_o :   std_logic_vector (7 downto 0);     

    signal SPIS_start_transfer:  std_logic:= '0';                                  
	
	--signal		SPIM_1_enable  : STD_LOGIC := '0';                            --initiate transaction
	--signal		SPIM_1_cpol    : STD_LOGIC := '0';                             --spi clock polarity
	signal		SPIM_1_cpha    : STD_LOGIC := '0';                             --spi clock phase
	signal		SPIM_1_cont    : STD_LOGIC := '0';                             --continuous mode command
	---signal		SPIM_1_clk_div : INTEGER := 1;                               --system clock cycles per 1/2 period of sclk
	signal		SPIM_1_addr    : INTEGER := 0;                               --address of slave
	--signal		SPIM_1_tx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);  --data to transmit
	signal		SPIM_1_busy    : STD_LOGIC := '0';                             --busy / data ready signal
	signal		SPIM_1_rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0); --data received
	 
	--signal		SPIM_2_enable  : STD_LOGIC := '0';                            --initiate transaction
	--signal		SPIM_2_cpol    : STD_LOGIC := '0';                             --spi clock polarity
	signal		SPIM_2_cpha    : STD_LOGIC := '0';                             --spi clock phase
	signal		SPIM_2_cont    : STD_LOGIC := '0';                             --continuous mode command
	--signal		SPIM_2_clk_div : INTEGER := 1;                               --system clock cycles per 1/2 period of sclk
	signal		SPIM_2_addr    : INTEGER:= 0;                               --address of slave
	--signal		SPIM_2_tx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);  --data to transmit
	signal		SPIM_2_busy    : STD_LOGIC:= '0';                             --busy / data ready signal
	signal		SPIM_2_rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0); --data received
	
	--signal		SPIM_3_enable  : STD_LOGIC := '0';                            --initiate transaction
	--signal		SPIM_3_cpol    : STD_LOGIC := '0';                             --spi clock polarity
	signal		SPIM_3_cpha    : STD_LOGIC := '0';                             --spi clock phase
	signal		SPIM_3_cont    : STD_LOGIC := '0';                             --continuous mode command
	--signal		SPIM_3_clk_div : INTEGER := 1;                               --system clock cycles per 1/2 period of sclk
	signal		SPIM_3_addr    : INTEGER:= 0;                               --address of slave
	--signal		SPIM_3_tx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);  --data to transmit
	signal		SPIM_3_busy    : STD_LOGIC := '0';                             --busy / data ready signal
	signal		SPIM_3_rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0); --data received	
	
	--signal		SPIM_4_enable  : STD_LOGIC := '0';                            --initiate transaction
	--signal		SPIM_4_cpol    : STD_LOGIC := '0';                             --spi clock polarity
	signal		SPIM_4_cpha    : STD_LOGIC := '0';                             --spi clock phase
	signal		SPIM_4_cont    : STD_LOGIC := '0';                             --continuous mode command
	--signal		SPIM_4_clk_div : INTEGER := 1;                               --system clock cycles per 1/2 period of sclk
	signal		SPIM_4_addr    : INTEGER:= 0;                               --address of slave
	--signal		SPIM_4_tx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);  --data to transmit
	signal		SPIM_4_busy    : STD_LOGIC := '0';                             --busy / data ready signal
	signal		SPIM_4_rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0); --data received
	
	--signal		SPIM_5_enable  : STD_LOGIC := '0';                            --initiate transaction
	--signal		SPIM_5_cpol    : STD_LOGIC := '0';                             --spi clock polarity
	signal		SPIM_5_cpha    : STD_LOGIC := '0';                             --spi clock phase
	signal		SPIM_5_cont    : STD_LOGIC := '0';                             --continuous mode command
	--signal		SPIM_5_clk_div : INTEGER := 1;                               --system clock cycles per 1/2 period of sclk
	signal		SPIM_5_addr    : INTEGER:= 0;                               --address of slave
	--signal		SPIM_5_tx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);  --data to transmit
	signal		SPIM_5_busy    : STD_LOGIC := '0';                             --busy / data ready signal
	signal		SPIM_5_rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0); --data received
	
	--signal		SPIM_6_enable  : STD_LOGIC := '0';                            --initiate transaction
	--signal		SPIM_6_cpol    : STD_LOGIC := '0';                             --spi clock polarity
	signal		SPIM_6_cpha    : STD_LOGIC := '0';                             --spi clock phase
	signal		SPIM_6_cont    : STD_LOGIC := '0';                             --continuous mode command
	--signal		SPIM_6_clk_div : INTEGER := 1;                               --system clock cycles per 1/2 period of sclk
	signal		SPIM_6_addr    : INTEGER:= 0;                               --address of slave
	--signal		SPIM_6_tx_data : STD_LOGIC_VECTOR(7 DOWNTO 0);  --data to transmit
	signal		SPIM_6_busy    : STD_LOGIC := '0';                             --busy / data ready signal
	signal		SPIM_6_rx_data : STD_LOGIC_VECTOR(7 DOWNTO 0); --data received
	

begin

		--sys_reset <=  PB(0);
	
		
	pll0 : clock_gen
		  port map
			(-- Clock in ports
			 CLK_IN1 => OSC_FPGA,
			  --Clock out ports
			 CLK_OUT1 =>  clk_100Mhz,
			  --Status and control signals
			 LOCKED => clock_locked);
		
		--sys_sdram_clk <=  clk_100Mhz;
		sys_clk <=   clk_100Mhz;
	
	clk_det: edge_detector 
	  Port map ( clk         => sys_clk,
				 signal_in   => RP_SPI_CE0N,
				 output   => SPIS_start_transfer
    );
	
	req_det: edge_detector 
	  Port map ( clk         => sys_clk,
				 signal_in   => SPIS_di_req_o,
				 output   => SPIS_di_req_o_buf
    );
	
	SPI_SLAVE_to_RPI : spi_slave
	    Generic map(   
        N 			=> 8,                                            -- 32bit serial word length is default
        CPOL 		=> '0',                                        -- SPI mode selection (mode 0 default)
        CPHA 		=> '1',                                        -- CPOL = clock polarity, CPHA = clock phase.
        PREFETCH 	=> 2)                                      -- prefetch lookahead cycles
		Port map(  
        clk_i  		=> sys_clk,                                  -- internal interface clock (clocks di/do registers)
        spi_ssel_i  => RP_SPI_CE0N,								-- spi bus slave select line
        spi_sck_i   => SYS_SPI_SCK,                              -- spi bus sck clock (clocks the shift register core)
        spi_mosi_i  => SYS_SPI_MOSI,                           -- spi bus mosi input
        spi_miso_o  => SYS_SPI_MISO,							-- spi bus spi_miso_o output
        di_req_o    =>  SPIS_di_req_o,                                -- preload lookahead data request line
        di_i		=> SPIS_di_i,								-- parallel load data in (clocked in on rising edge of clk_i)
        wren_i      => SPIS_wren_i,                              -- user data write enable
        wr_ack_o    => SPIS_wr_ack_o,                                  -- write acknowledge
        do_valid_o  => SPIS_do_valid_o,                                  -- do_o data valid strobe, valid during one clk_i rising edge.
        do_o        => SPIS_do_o          							-- parallel output (clocked out on falling clk_i)

    );     

	SPIM1 : spi_master 
		  GENERIC map(
			 slaves  => 2,  --number of spi slaves
			 d_width => 8	--data bus width
			 ) 
		  PORT map(
			 clock   	=> sys_clk,                             --system clock
			 reset_n 	=> SPIM_all_reset,                            --asynchronous reset
			 enable 	=> SPIM_all_enable,                            --initiate transaction
			 cpol    	=> SPIM_all_cpol,                             --spi clock polarity
			 cpha    	=> SPIM_all_cpha,                             --spi clock phase
			 cont    	=> SPIM_all_cont,                             --continuous mode command
			 clk_div 	=> SPIM_all_clk_div,                               --system clock cycles per 1/2 period of sclk
			 addr    	=> SPIM_all_addr,                               --address of slave
			 tx_data 	=> SPIM_all_tx_data,  --data to transmit
			 miso    	=> SPIM1_MISO,                             --master in, slave out
			 sclk    	=> SPIM1_SCLK,                             --spi clock
			 ss_n    	=> SPIM1_CS(1 downto 0),   --slave select
			 mosi    	=> SPIM1_MOSI,                             --master out, slave in
			 busy    	=> SPIM_1_busy,                            --busy / data ready signal
			 rx_data 	=> SPIM_1_rx_data --data received
		);
	SPIM2 : spi_master 
		  GENERIC map(
			 slaves  => 2,  --number of spi slaves
			 d_width => 8	--data bus width
			 ) 
		  PORT map(
			 clock   	=> sys_clk,                             --system clock
			 reset_n 	=> SPIM_all_reset,                            --asynchronous reset
			 enable 	=> SPIM_all_enable,                            --initiate transaction
			 cpol    	=> SPIM_all_cpol,                             --spi clock polarity
			 cpha    	=> SPIM_all_cpha,                             --spi clock phase
			 cont    	=> SPIM_all_cont,                             --continuous mode command
			 clk_div 	=> SPIM_all_clk_div,                               --system clock cycles per 1/2 period of sclk
			 addr    	=> SPIM_all_addr,                               --address of slave
			 tx_data 	=> SPIM_all_tx_data,  --data to transmit
			 miso    	=> SPIM2_MISO,                             --master in, slave out
			 sclk    	=> SPIM2_SCLK,                             --spi clock
			 ss_n    	=> SPIM2_CS(1 downto 0),   --slave select
			 mosi    	=> SPIM2_MOSI,                              --master out, slave in
			 busy    	=> SPIM_2_busy,                            --busy / data ready signal
			 rx_data 	=> SPIM_2_rx_data --data received
		);
	SPIM3 : spi_master 
		  GENERIC map(
			 slaves  => 2,  --number of spi slaves
			 d_width => 8	--data bus width
			 ) 
		  PORT map(
			 clock   	=> sys_clk,                             --system clock
			 reset_n 	=> SPIM_all_reset,                            --asynchronous reset
			 enable 	=> SPIM_all_enable,                            --initiate transaction
			 cpol    	=> SPIM_all_cpol,                             --spi clock polarity
			 cpha    	=> SPIM_all_cpha,                             --spi clock phase
			 cont    	=> SPIM_all_cont,                             --continuous mode command
			 clk_div 	=> SPIM_all_clk_div,                               --system clock cycles per 1/2 period of sclk
			 addr    	=> SPIM_all_addr,                               --address of slave
			 tx_data 	=> SPIM_all_tx_data,  --data to transmit
			 miso    	=> SPIM3_MISO,                             --master in, slave out
			 sclk    	=> SPIM3_SCLK,                             --spi clock
			 ss_n    	=> SPIM3_CS(1 downto 0),   --slave select
			 mosi    	=> SPIM3_MOSI,                             --master out, slave in
			 busy    	=> SPIM_3_busy,                            --busy / data ready signal
			 rx_data 	=> SPIM_3_rx_data --data received
		);
	SPIM4 : 	spi_master  
		  GENERIC map( 
			 slaves  => 2,  --number of spi slaves
			 d_width => 8	--data bus width
			 ) 
		  PORT map(
			 clock   	=> sys_clk,                             --system clock
			 reset_n 	=> SPIM_all_reset,                            --asynchronous reset
			 enable 	=> SPIM_all_enable,                            --initiate transaction
			 cpol    	=> SPIM_all_cpol,                             --spi clock polarity
			 cpha    	=> SPIM_all_cpha,                             --spi clock phase
			 cont    	=> SPIM_all_cont,                             --continuous mode command
			 clk_div 	=> SPIM_all_clk_div,                               --system clock cycles per 1/2 period of sclk
			 addr    	=> SPIM_all_addr,                               --address of slave
			 tx_data 	=> SPIM_all_tx_data,  --data to transmit
			 miso    	=> SPIM4_MISO,                             --master in, slave out
			 sclk    	=> SPIM4_SCLK,                             --spi clock
			 ss_n    	=> SPIM4_CS(1 downto 0),   --slave select
			 mosi    	=> SPIM4_MOSI,                             --master out, slave in
			 busy    	=> SPIM_4_busy,                            --busy / data ready signal
			 rx_data 	=> SPIM_4_rx_data --data received
		);
	SPIM5 : spi_master 
		  GENERIC map(
			 slaves  => 2,  --number of spi slaves
			 d_width => 8	--data bus width
			 ) 
		  PORT map(
			 clock   	=> sys_clk,                             --system clock
			 reset_n 	=> SPIM_all_reset,                            --asynchronous reset
			 enable 	=> SPIM_all_enable,                            --initiate transaction
			 cpol    	=> SPIM_all_cpol,                             --spi clock polarity
			 cpha    	=> SPIM_all_cpha,                             --spi clock phase
			 cont    	=> SPIM_all_cont,                             --continuous mode command
			 clk_div 	=> SPIM_all_clk_div,                               --system clock cycles per 1/2 period of sclk
			 addr    	=> SPIM_all_addr,                               --address of slave
			 tx_data 	=> SPIM_all_tx_data,  --data to transmit
			 miso    	=> SPIM5_MISO,                             --master in, slave out
			 sclk    	=> SPIM5_SCLK,                             --spi clock
			 ss_n    	=> SPIM5_CS(1 downto 0),   --slave select
			 mosi    	=> SPIM5_MOSI,                             --master out, slave in
			 busy    	=> SPIM_5_busy,                            --busy / data ready signal
			 rx_data 	=> SPIM_5_rx_data --data received
		);
	SPIM6 : spi_master 
		  GENERIC map(
			 slaves  => 2,  --number of spi slaves
			 d_width => 8	--data bus width
			 ) 
		  PORT map(
			 clock   	=> sys_clk,                             --system clock
			 reset_n 	=> SPIM_all_reset,                            --asynchronous reset
			 enable 	=> SPIM_all_enable,                            --initiate transaction
			 cpol    	=> SPIM_all_cpol,                             --spi clock polarity
			 cpha    	=> SPIM_all_cpha,                             --spi clock phase
			 cont    	=> SPIM_all_cont,                             --continuous mode command
			 clk_div 	=> SPIM_all_clk_div,                               --system clock cycles per 1/2 period of sclk
			 addr    	=> SPIM_all_addr,                               --address of slave
			 tx_data 	=> SPIM_all_tx_data,  --data to transmit
			 miso    	=> SPIM6_MISO,                             --master in, slave out
			 sclk    	=> SPIM6_SCLK,                             --spi clock
			 ss_n    	=> SPIM6_CS(1 downto 0),   --slave select
			 mosi    	=> SPIM6_MOSI,                             --master out, slave in
			 busy    	=> SPIM_6_busy,                            --busy / data ready signal
			 rx_data 	=> SPIM_6_rx_data --data received
		);
		
	start_when_ready : process(SPIS_do_valid_o,SPIS_di_req_o,sys_clk,sys_reset) is
	begin			
		
		if (sys_clk='1' and sys_clk'event) then 
			if SPIS_start_transfer = '1' then	
			enable_spi_reciever <= '1';
			LED(0)<='1';			
			end if;
		end if;
				
			
	end process start_when_ready;

	control_spi_master : process(sys_clk, sys_reset) is
	
		begin 
					
		if (sys_clk='1' and sys_clk'event) then --='1' and sys_clk'event) then
			if enable_spi_reciever = '1' then
				
			
				--SPIM_all_reset <= '1';
				SPIM_all_cpol <= '0';
				SPIM_all_cpha <= '0';
				SPIM_all_clk_div <= 25;
				SPIM_all_enable	<= '1';
				

					
				if  SPIM_1_busy = '0' then --switch der Adresssen
					
					SPIM_all_cont <= '0';

					
					if data_recieved = '1' then
						data_recieved <= '0';
						if( SLAVE_sel = '0')then
							
							SPIM_all_cont <= '1';
							SPIM_all_addr	<= 0;
							SLAVE_sel <='1';

	
						elsif( SLAVE_sel = '1')then
							
							SPIM_all_addr	<= 1;
							SPIM_all_cont 	<= '1';
							SLAVE_sel <='0';						

						end if;					
					
					elsif (data_recieved  = '0') then					
						data_recieved <= '1';
							
					end if;	
					
				end if;	
				
			else 
			SPIM_all_enable <= '0';
			SPIM_all_reset <= '1';
			data_recieved <= '0';
			SLAVE_sel <= '0';		
			
			end if;	

	end if;
		
		-- if sys_reset= '0' then
			-- SPIM_all_enable <= '0';
		-- else 	
			-- SPIM_all_enable <= '1';
		-- end if;		

	end process control_spi_master;
	
	prepare_store_data : process (SPIM_1_busy, sys_clk, sys_reset) is
	
	begin

	
	  if (sys_clk='1' and sys_clk'event) then
		--if enable_spi_reciever = '1' then	

			if ( SPIM_1_busy = '0') then
			
				if ((SLAVE_sel = '0') and (data_recieved = '0')) then
				
					SPIM1_data_in(7 downto 0) <= SPIM_1_rx_data;
					
					SPIM3_data_in(7 downto 0) <= SPIM_2_rx_data;
									
					SPIM5_data_in(7 downto 0) <= SPIM_3_rx_data;
					
					SPIM7_data_in(7 downto 0) <= SPIM_4_rx_data;
									
					SPIM9_data_in(7 downto 0) <= SPIM_5_rx_data;
										
					SPIM11_data_in(7 downto 0) <= SPIM_6_rx_data;

					bank1_vaild_data <='0';		
					
								
				elsif ((SLAVE_sel = '0') and (data_recieved = '1')) then
				
					SPIM1_data_in(15 downto 8) <= SPIM_1_rx_data;	
					
					SPIM3_data_in(15 downto 8) <= SPIM_2_rx_data;
					
					SPIM5_data_in(15 downto 8) <= SPIM_3_rx_data;
					
					SPIM7_data_in(15 downto 8) <= SPIM_4_rx_data;
				
					SPIM9_data_in(15 downto 8) <= SPIM_5_rx_data;
					
					SPIM11_data_in(15 downto 8) <= SPIM_6_rx_data;

					
					bank1_vaild_data <='1';
					

				elsif ((SLAVE_sel = '1') and (data_recieved = '0')) then
				
					SPIM2_data_in(7 downto 0) <= SPIM_1_rx_data;
										
					SPIM4_data_in(7 downto 0) <= SPIM_2_rx_data;
										
					SPIM6_data_in(7 downto 0) <= SPIM_3_rx_data;
										
					SPIM8_data_in(7 downto 0) <= SPIM_4_rx_data;
									
					SPIM10_data_in(7 downto 0) <= SPIM_5_rx_data;
										
					SPIM12_data_in(7 downto 0) <= SPIM_6_rx_data;					
					
					bank2_vaild_data <='0';		


				elsif ((SLAVE_sel = '1') and (data_recieved = '1')) then
				
					SPIM2_data_in(15 downto 8) <= SPIM_1_rx_data;
					
					SPIM4_data_in(15 downto 8) <= SPIM_2_rx_data;
					
					SPIM6_data_in(15 downto 8) <= SPIM_3_rx_data;
					
					SPIM8_data_in(15 downto 8) <= SPIM_4_rx_data;
					
					SPIM10_data_in(15 downto 8) <= SPIM_5_rx_data;
					
					SPIM12_data_in(15 downto 8) <= SPIM_6_rx_data;

					
					bank2_vaild_data <='1';		
					
				end if;
			end if;	
			
	   --end if;
	   end if;
	
	end process;
	

	Buffer_data: process (sys_clk,bank1_vaild_data,bank2_vaild_data) is
	
	begin
		if(rising_edge(sys_clk)) then
			
			if bank1_vaild_data  = '1' then
			
			SPIM1_data_out <= SPIM1_data_in;
			SPIM3_data_out <= SPIM3_data_in;
			SPIM5_data_out <= SPIM5_data_in;
			SPIM7_data_out <= SPIM7_data_in;
			SPIM9_data_out <= SPIM9_data_in;

			end if;
			
			
			
			if bank2_vaild_data = '1' then
			
			SPIM2_data_out <= SPIM2_data_in;
			SPIM4_data_out <= SPIM4_data_in;
			SPIM6_data_out <= SPIM6_data_in;
			SPIM8_data_out <= SPIM8_data_in;
			SPIM10_data_out <= SPIM10_data_in;

			end if;

		end if;
	end process;
	

	
	write_to_RPI : process(SPIS_start_transfer,sys_clk,sys_reset) is
		begin
		

		
		if (rising_edge(sys_clk)) then
		
		
			
			

			if SPIS_di_req_o_buf = '1' and RP_SPI_CE0N = '0' then
			
			LED(1)<='1';	

					if counter = 1 then
						SPIS_wren_i <= '1';
						bank1_data_written <= '0';
						SPIS_di_i <= SPIM1_data_out(15 downto 8);
			
						counter <= counter +1;
					elsif counter = 2 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM1_data_out(7 downto 0); 
						counter <= counter +1;
					elsif counter =3 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM2_data_out(15 downto 8);
						counter <= counter +1;
					elsif counter =4 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM2_data_out(7 downto 0);
						
						counter <= counter +1;
					elsif counter =5 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM3_data_out(15 downto 8);
						
						counter <= counter +1;
					elsif counter =6 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM3_data_out(7 downto 0);
						
						counter <= counter +1;
					elsif counter =7 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM4_data_out(15 downto 8);
						 
						counter <= counter +1;
					elsif counter =8 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM4_data_out(7 downto 0);
						 
						counter <= counter +1;
					elsif counter =9 then
						SPIS_wren_i <= '1';	
						SPIS_di_i <= SPIM5_data_out(15 downto 8);
						 
						counter <= counter +1;
					elsif counter =10 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM5_data_out(7 downto 0);
						 
						counter <= counter +1;
					elsif counter =11 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM6_data_out(15 downto 8);
						 
						counter <= counter +1;
					elsif counter =12 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM6_data_out(7 downto 0);
						 
						counter <= counter +1;
					elsif counter =13 then
						bank2_data_written <= '0';
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM7_data_out(15 downto 8);
						 
						counter <= counter +1;
					elsif counter =14 then
						SPIS_wren_i <= '1';
						SPIS_di_i <= SPIM7_data_out(7 downto 0);
						 
						counter <= counter +1;
					-- elsif counter =15 then
						-- SPIS_wren_i <= '1';
						-- SPIS_di_i <= SPIM8_data_out(15 downto 8);
						 
						-- counter <= counter +1;
					-- elsif counter =16 then
						-- SPIS_wren_i <= '1';
						-- SPIS_di_i <= SPIM8_data_out(7 downto 0);
						 
						-- counter <= counter +1;
					-- elsif counter =17 then
						-- SPIS_wren_i <= '1';
						-- SPIS_di_i <= SPIM9_data_out(15 downto 8);
						 
						-- counter <= counter +1;
					-- elsif counter =18 then
						-- SPIS_wren_i <= '1';
						-- SPIS_di_i <= SPIM9_data_out(7 downto 0);
						 
						-- counter <= counter +1;
					-- elsif counter =19 then
						-- SPIS_wren_i <= '1';
						-- SPIS_di_i <= SPIM10_data_out(15 downto 8);
						 
						-- counter <= counter +1;
					-- elsif counter =20 then
						-- SPIS_wren_i <= '1';
						-- SPIS_di_i <= SPIM10_data_out(7 downto 0);
						 
						-- counter <= counter +1;
						-- bank2_data_written  <='1';
						-- pmod2 <= '1';
					end if;				
				--end if;

				if counter = 15 then
					counter <= 1;
					SPIS_wren_i <= '0';
					LED(1)<='0';
					
				end if;
				-- if counter = 0 then
					-- counter <= 1;
				-- end if;
	
			end if;

		end if;
				
		
			if SPIS_start_transfer = '1'  then				
				counter <= 1;
				SPIS_wren_i <= '0';
			end if;



	end process write_to_RPI;
	
	
end Behavioral;

