library ieee;
use ieee.std_logic_1164.all;

entity top_tb is
end top_tb;

architecture arch_top_tb of top_tb is

  -- Component Declaration for the Unit Under Test (UUT)
  component top
    port (clk_i             : in    std_logic;
          rst_n_i           : in    std_logic;
          codec_scl_io      : inout std_logic;
          codec_sda_io      : inout std_logic;
          codec_mclk_o      : out   std_logic;
          codec_adc_sdata_i : in    std_logic;
          codec_bclk_i      : in    std_logic;
          codec_dac_sdata_o : out   std_logic;
          codec_lrclk_i     : in    std_logic;
          btnd_i            : in    std_logic;
          btnu_i            : in    std_logic;
          oled_dc_n_o       : out   std_logic;
          oled_res_n_o      : out   std_logic;
          oled_sclk_o       : out   std_logic;
          oled_sdo_o        : out   std_logic;
          oled_vbat_n_o     : out   std_logic;
          oled_vdd_n_o      : out   std_logic);
  end component;
  
  component generateur_sample
    port (clk_i               : in  std_logic;
          rst_i               : in  std_logic;
          note_start_addr_i   : in  std_logic_vector(11 downto 0);
          note_sample_count_i : in  std_logic_vector(7 downto 0);
          enable_i            : in  std_logic;
          ROM_qsin_addr_o     : out std_logic_vector(11 downto 0);
          ROM_qsin_sample_i   : in  std_logic_vector(7 downto 0);
          sample_ready_i      : in  std_logic;
          sample_out          : out std_logic_vector(23 downto 0));
  end component;
  
  -- signaux module top
  signal rst_n_i                                                             : std_logic := '1';
  signal clk_100mhz_i                                                        : std_logic := '0';
  signal oled_dc_n, oled_res_n, oled_sclk, oled_sdo, oled_vbat_n, oled_vdd_n : std_logic;
  signal codec_scl, codec_sda, codec_mclk, codec_dac_sdata                   : std_logic;
  signal codec_bclk, codec_lrclk, codec_adc_sdata                            : std_logic := '0';
  signal btnd, btnu                                                          : std_logic := '0';
  
  -- signaux module generateur_sample
  signal rst_sys                                  : std_logic;
  signal clk_50mhz                                : std_logic;
  signal ROM_qsin_addr                            : std_logic_vector(11 downto 0)   := (others => '0');
  signal ROM_qsin_sample                          : std_logic_vector(7 downto 0)  := (others => '0');
  signal note_start_address                       : std_logic_vector(11 downto 0) := "000000000000";--   := X"00";
  signal note_sample_count                        : std_logic_vector(7 downto 0) := "01010100"; --    := X"54";
  signal sine_sample                              : std_logic_vector(23 downto 0)  := (others => '0');
  signal note_enable                              : std_logic := '1';
  signal codec_ready                              : std_logic := '0';
  
-- Clock period definitions
  constant CLK_100MHZ_PERIOD : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : top
    port map (
      rst_n_i           => rst_n_i,
      clk_i             => clk_100mhz_i,
      codec_scl_io      => codec_scl,
      codec_sda_io      => codec_sda,
      codec_mclk_o      => codec_mclk,
      codec_adc_sdata_i => codec_adc_sdata,
      codec_bclk_i      => codec_bclk,
      codec_dac_sdata_o => codec_dac_sdata,
      codec_lrclk_i     => codec_lrclk,
      btnu_i            => btnu,
      btnd_i            => btnd,
      oled_dc_n_o       => oled_dc_n,
      oled_res_n_o      => oled_res_n,
      oled_sclk_o       => oled_sclk,
      oled_sdo_o        => oled_sdo,
      oled_vbat_n_o     => oled_vbat_n,
      oled_vdd_n_o      => oled_vdd_n
      );
  uut1 : generateur_sample
    port map (
      clk_i               => clk_50mhz,
      rst_i               => rst_sys,
      note_start_addr_i   => note_start_address,
      note_sample_count_i => note_sample_count,
      enable_i            => note_enable,
      ROM_qsin_addr_o     => ROM_qsin_addr,
      ROM_qsin_sample_i   => ROM_qsin_sample,
      sample_ready_i      => codec_ready,
      sample_out          => sine_sample
      );
      
  -- Clock definition
  clk_100mhz_i <= not clk_100mhz_i after CLK_100MHZ_PERIOD/2;
  codec_bclk   <= not codec_bclk   after 50 ns;  -- Not to scale for sim, actual bclk will be slower
  codec_lrclk  <= not codec_lrclk  after 3200 ns;
  
-------------------------------------------------------------------
--  -- Stimulus process
--  stim_proc : process
--  begin
--    -- fourni avec le squelett    
----    rst_n_i <= '0';
----    wait for 100 ns;
----    rst_n_i <= '1';
--    -- A completer
--    --ROM_qsin_addr <= X"00";
--    --note_sample_count <= X"54";
--    note_start_address <= "000000000000";
--    note_sample_count <= "01010100";

--    rst_n_i <= '1';
--    wait for 100 ns;
--    rst_n_i <= '0';
--    while rst_n_i = '0' loop
--        wait for 200 ns;
--        codec_ready <= not(codec_ready);
--    end loop;
--    wait;                               -- wait forever
--  end process;
-------------------------------------------------------------------

process(clk_50mhz)
begin
    
    
    
end arch_top_tb;
