library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity generateur_sample is
  port (clk_i               : in  std_logic;
        rst_i               : in  std_logic;
        note_start_addr_i   : in  std_logic_vector(11 downto 0);
        note_sample_count_i : in  std_logic_vector(7 downto 0);
        enable_i            : in  std_logic;
        ROM_qsin_addr_o     : out std_logic_vector(11 downto 0);
        ROM_qsin_sample_i   : in  std_logic_vector(7 downto 0);
        sample_ready_i      : in  std_logic;
        sample_out          : out std_logic_vector(23 downto 0));
end generateur_sample;

architecture Behavioral of generateur_sample is
    -- A completer
    -- Déclaration des types et signaux internes
    type state is (increment_pos, decrement_pos, increment_neg, decrement_neg, stop);
    signal current_state    : state := stop;
    signal ROM_qsin_addr    : std_logic_vector(11 downto 0) := (others => '0');
    signal sample_output    : std_logic_vector(23 downto 0) := (others => '0');
    signal sample_cnt       : integer := 0;
    signal addr_cnt         : integer := 0;
begin
    ROM_qsin_addr_o <= ROM_qsin_addr; 
    sample_out      <= sample_output;
    process (clk_i, rst_i)
    begin
-- A remplacer
--  ROM_qsin_addr_o <= X"000";
--  sample_out      <= X"000000";
        if rst_i = '1' then
            ROM_qsin_addr   <= (others => '0');
            sample_output   <= (others => '0');
            current_state   <= stop; 
            sample_cnt      <= 0;
        elsif rising_edge(clk_i) then
            case current_state is
                when increment_pos =>
                    if enable_i = '0' then
                        current_state <= stop;
                    elsif sample_ready_i = '1' and enable_i = '1' then 
                        addr_cnt <= to_integer(signed(note_start_addr_i)) + sample_cnt; -- Adress of the generated sample
                        ROM_qsin_addr <= std_logic_vector(to_unsigned(addr_cnt,12));    -- Assignation of the adress
                        sample_cnt <= sample_cnt + 1;
                        sample_output <= ROM_qsin_sample_i & "0000000000000000";
                        if note_sample_count_i = std_logic_vector(to_unsigned(sample_cnt+2, 8)) then -- +2 because sample_cnt was stopping at 86 (decimal)
                            current_state <=  decrement_pos;
                        end if;
                    end if;
                    
                when decrement_pos =>
                    if enable_i = '0' then
                        current_state <= stop;
                    elsif sample_ready_i = '1' and enable_i = '1' then 
                        addr_cnt <= to_integer(signed(note_start_addr_i)) + sample_cnt;
                        ROM_qsin_addr <= std_logic_vector(to_unsigned(addr_cnt,12));
                        sample_cnt <= sample_cnt - 1;
                        sample_output <= ROM_qsin_sample_i & "0000000000000000";
                        if sample_cnt = 1 then 
                            current_state <=  increment_neg;
                        end if;
                    end if;
                    
                when increment_neg =>
                    if enable_i = '0' then
                        current_state <= stop;
                    elsif sample_ready_i = '1' and enable_i = '1' then 
                        addr_cnt <= to_integer(signed(note_start_addr_i)) + sample_cnt;
                        ROM_qsin_addr <= std_logic_vector(to_unsigned(addr_cnt,12));
                        sample_cnt <= sample_cnt + 1;
                        --sample_output <= (NOT(ROM_qsin_sample_i)) & "0000000000000000"; 
                        --std_logic_vector(to_unsigned(to_integer(unsigned( NOT(ROM_qsin_sample_i) )) + 1, 12)); -- ADD 1 TO std_logic_vector
                        sample_output <= std_logic_vector(to_unsigned(to_integer(unsigned( NOT(ROM_qsin_sample_i) )) + 1, 8)) & "0000000000000000"; -- Invert vector, add 1 to vector, and LSL 12
                        if note_sample_count_i = std_logic_vector(to_unsigned(sample_cnt+2, 8)) then -- +2 because sample_cnt was stopping at 86 (decimal)
                            current_state <=  decrement_neg;
                        end if;
                    end if;
                
                when decrement_neg =>
                    if enable_i = '0' then
                        current_state <= stop;
                    elsif sample_ready_i = '1' and enable_i = '1' then 
                        addr_cnt <= to_integer(signed(note_start_addr_i)) + sample_cnt;
                        ROM_qsin_addr <= std_logic_vector(to_unsigned(addr_cnt,12));
                        sample_cnt <= sample_cnt - 1;
                        sample_output <= std_logic_vector(to_unsigned(to_integer(unsigned( NOT(ROM_qsin_sample_i) )) + 1, 8)) & "0000000000000000";
                        if sample_cnt = 1 then 
                            current_state <=  increment_pos;
                        end if;
                    end if;
                    
                when stop =>
                    if enable_i = '1' then 
                        current_state <= increment_pos;
                        ROM_qsin_addr <= note_start_addr_i;
                        sample_cnt    <= 0; -- remettre le compteur a 0
                    end if;
                
           end case;
        end if;
    end process; 
end Behavioral;
