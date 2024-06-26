library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity MSA_jingle is
  port (clk_i            : in  std_logic;
        rst_i            : in  std_logic;
        start_jingle_i   : in  std_logic;
        timing_start_o   : out std_logic;
        timing_ready_i   : in  std_logic;
        jingle_address_o : out std_logic_vector(7 downto 0);
        note_enable_o    : out std_logic);
end MSA_jingle;

architecture Behavioral of MSA_jingle is
    -- A completer
    type state is (jingle_on, waiting, delay, standby);
    signal current_state : state    := standby;
    signal jingle_timing_start      : std_logic;
    signal jingle_addr              : std_logic_vector(7 downto 0);
    signal note_enable              : std_logic;
    
begin
--  A remplacer
--  timing_start_o <= '0';
--  jingle_address_o <= X"00";
--  note_enable_o <= '0';
    timing_start_o <= jingle_timing_start;
    jingle_address_o <= jingle_addr;
    note_enable_o <= note_enable;
    
    process(clk_i, rst_i)
    begin
        if(rst_i = '1') then 
        jingle_timing_start <= '0';
        jingle_addr         <= X"00";
        note_enable         <= '0';
        
        elsif rising_edge(clk_i) then
            case current_state is 
                when standby =>
                    if start_jingle_i = '1' then
                        current_state <= jingle_on;
                        note_enable <= '0';
                    end if;
                
                when waiting =>
                    if timing_ready_i = '1' then
                       if jingle_addr = X"02" then 
                           jingle_addr <= X"00";
                           current_state <= standby;
                           note_enable <= '0';              
                        else
                            jingle_addr <= std_logic_vector(to_unsigned(to_integer(unsigned( jingle_addr )) + 1,8));
                            note_enable <= '1';
                            current_state <= jingle_on;
                        end if;
                    end if;
                
                when jingle_on =>
--                if jingle_addr = X"03" then 
--                       jingle_addr <= X"00";
--                       current_state <= standby;
--                       note_enable <= '0';
--                else
                        jingle_timing_start <= '1';
                        note_enable <= '0'; -- enable off pour un cycle
                        current_state <= delay;
--                end if;
                 
                    
                when delay =>
                    jingle_timing_start <= '0';
                    note_enable <= '1'; -- enable on apres un cycle off
                    
                        --jingle_addr <= std_logic_vector(to_unsigned(to_integer(unsigned( jingle_addr )) + 1,8));
                        --note_enable <= '0';
                    current_state <= waiting;
            end case;
        end if;
    end process;
end Behavioral;
