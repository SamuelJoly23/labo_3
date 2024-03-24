library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity modulateur_volume is
  port (
    rst_i          : in  std_logic;
    clk_i          : in  std_logic;
    btnd_i         : in  std_logic;
    btnu_i         : in  std_logic;
    sample_in      : in  std_logic_vector(23 downto 0);
    sample_out     : out std_logic_vector(23 downto 0);
    column_i       : in  std_logic_vector(6 downto 0);
    row_i          : in  std_logic_vector(4 downto 0);
    pixel_o        : out std_logic;
    start_jingle_o : out std_logic
    );
end modulateur_volume;

architecture Behavioral of modulateur_volume is
  -- A completer
    type state is (waiting, increment, decrement);
    signal current_state    : state                         := waiting;
    signal vol_sample       : std_logic_vector(23 downto 0) := (others => '0');
    signal pixel            : std_logic                     := '0';
    signal start_jingle     : std_logic                     := '0';
    signal volume           : std_logic_vector(3 downto 0) := (others => '0');
    signal LSR              : std_logic_vector(3 downto 0) := (others => '0');
begin
-- A remplacer
--  sample_out <= sample_in;
--  pixel_o <= '0';
--  start_jingle_o <= btnu_i;
    sample_out      <= vol_sample;
    pixel_o         <= pixel;
    start_jingle_o  <= start_jingle;
    
    
    process (clk_i, rst_i)
    begin
        if rst_i = '1' then -- Réinitialisation des signaux et retour à l'état de repos
            -- Réinitialisation des buffers et du compteur
            vol_sample      <= (others => '0');
            pixel           <= '0';
            start_jingle    <= '0';
            current_state   <= waiting;
            volume          <= X"F";
            
        elsif rising_edge(clk_i) then
            case current_state is
                when waiting =>
                    if btnu_i = '1' then 
                        current_state <= increment;
                        start_jingle <= '1';
                        if volume < X"F" then 
                            volume <= std_logic_vector(to_unsigned(to_integer(unsigned( volume )) + 1,4));
                        end if;
                    elsif btnd_i <= '1' then 
                        current_state <= decrement;
                        start_jingle <= '1';
                        if volume > X"0" then 
                            volume <= std_logic_vector(to_unsigned(to_integer(unsigned( volume )) - 1,4));
                        end if;
                    end if;
                    LSR <= std_logic_vector(to_unsigned(15 - to_integer(unsigned( volume )),4)); -- trouver la valeur du shift right
                    vol_sample <= std_logic_vector(shift_right(unsigned(vol_sample), to_integer(unsigned(LSR)))); -- amplifier le signal selon le volume
                
                when increment =>
                    start_jingle <= '0';
                    
                when decrement => 
                    start_jingle <= '0';
                    
            end case;
        end if;
    end process;
end Behavioral;
