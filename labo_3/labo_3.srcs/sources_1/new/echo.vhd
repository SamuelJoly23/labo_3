library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity echo is
port(
    clk_i               : in  std_logic;
    rst_i               : in  std_logic;
    btnr_i              : in  std_logic;
    echo_sample_in      : in std_logic_vector(23 downto 0);    -- sample out provenant de controleur_CODEC
    echo_sample_out     : out std_logic_vector(23 downto 0)    -- sample in 
    );
end echo;

architecture Behavioral of echo is

component fifo_generator_0
  PORT (
    clk :   IN STD_LOGIC;
    srst :  IN STD_LOGIC;
    din :   IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout :  OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    full :  OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
end component;

-- signal list 
signal srst     : std_logic;
signal din      : STD_LOGIC_VECTOR(23 DOWNTO 0);
signal wr_en    : STD_LOGIC;
signal rd_en    : STD_LOGIC;
signal dout     : STD_LOGIC_VECTOR(23 DOWNTO 0);
signal full     : STD_LOGIC;
signal empty    : STD_LOGIC;


begin
inst_fifo_generator_0 : fifo_generator_0
  PORT MAP (
    clk => clk_i,
    srst => srst,
    din => din,
    wr_en => wr_en,
    rd_en => rd_en,
    dout => dout,
    full => full,
    empty => empty
  );
    process (clk_i, rst_i)
    begin
        if rst_i = '1' then
        
        elsif rising_edge(clk_i) then
        
        
        end if;
    end process;
end Behavioral;
