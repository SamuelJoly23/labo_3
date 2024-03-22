library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity generateur_sample_tb is
end generateur_sample_tb;

architecture Behavioral of generateur_sample_tb is
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
    
    component ROM_qsin
        port (
          clk_i    : in  std_logic;
          addr_i   : in  std_logic_vector(11 downto 0);
          sample_o : out std_logic_vector(7 downto 0));
    end component;
    
    -- signaux module generateur_sample et ROM_qsin
    signal rst_sys                                  : std_logic                     := '1';
    signal clk_50mhz                                : std_logic                     := '1';
    signal ROM_qsin_addr                            : std_logic_vector(11 downto 0) := (others => '0');
    signal ROM_qsin_sample                          : std_logic_vector(7 downto 0)  := (others => '0');
    signal note_start_address                       : std_logic_vector(11 downto 0) := "000001010100";--   := X"54";
    signal note_sample_count                        : std_logic_vector(7 downto 0)  := "01001111"; --    := X"4f";
    signal sine_sample                              : std_logic_vector(23 downto 0) := (others => '0');
    signal note_enable                              : std_logic                     := '1';
    signal codec_ready                              : std_logic                     := '0';
    
    -- Clock period definitions
    constant CLK_50MHZ_PERIOD : time := 20 ns;
begin
    uut : generateur_sample
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

    uut1 : ROM_qsin
        port map(
            clk_i    => clk_50mhz,
            addr_i   => ROM_qsin_addr,
            sample_o => ROM_qsin_sample
            );
    -- Clock definition
    clk_50mhz <= not clk_50mhz after CLK_50MHZ_PERIOD/2;
    -- Sample_ready definition
    --codec_ready <= not codec_ready after 10*CLK_50MHZ_PERIOD;
    -- Statut du restart
    --rst_sys <= '1', '0' after 5*CLK_50MHZ_PERIOD;
stim_proc : process
  begin
    rst_sys <= '1';
    wait for 100 ns;
    rst_sys <= '0';
--    while rst_sys = '0' loop 
--        codec_ready <= not clk_50mhz after 10*CLK_50MHZ_PERIOD;
--    end loop;
    while true loop
        codec_ready <= '0';  -- Set control signal to '0'
        wait for 10*CLK_50MHZ_PERIOD;  -- Wait for 10 cycles
        codec_ready <= '1';  -- Set control signal to '1'
        wait for CLK_50MHZ_PERIOD;  -- Wait for 1 cycle
    end loop;
    wait;   
end process;
end Behavioral;
