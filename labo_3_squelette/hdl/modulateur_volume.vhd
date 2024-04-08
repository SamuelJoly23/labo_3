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
--    type state is (waiting, increment, decrement);
--    signal current_state    : state                         := waiting;
--    signal vol_sample       : std_logic_vector(23 downto 0) := (others => '0');
--    signal pixel            : std_logic                     := '0';
--    --signal start_jingle     : std_logic                     := '0';
--    signal volume           : std_logic_vector(3 downto 0) := (others => '0');
--    signal LSR              : std_logic_vector(3 downto 0) := (others => '0');

    type stateJingle is (turnOn, turnOff, attente);
    type stateVolume is (up, down, standby);
    signal state_Jingle : stateJingle                := attente;
    signal state_Volume : stateVolume                := standby;
    signal start_jingle : std_logic                  :='0';
    signal pixel : std_logic                         :='0';
    signal vol_sample: std_logic_vector(23 downto 0) := (others => '0');
    signal volume     : std_logic_vector(3 downto 0) := (others => '0');
    signal counter : integer range 1 to 15;
    signal niveau_pixel : std_logic_vector (6 downto 0) := "0000000";
   
    
    
    
    
    -----------------------------------------------------------------------
--    signal volume_reg :std_logic_vector (3 downto 0) :="0000";
--    signal start_jingle : std_logic := '0';
--    signal volume_bar : std_logic_vector (15 downto 0):= (others =>'0');
    
begin
---- A remplacer
      --sample_out <= vol_sample;
      sample_out <= std_logic_vector(shift_right(signed(sample_in), counter)); -- on va decaler notre entree de la valeur déterminer par counter
      counter <= 15 - to_integer(unsigned(volume)); -- counter est déterminer par notre volume: l'intensité max du volume - l'intensité "dispo"
        pixel_o         <= pixel;
        start_jingle_o  <= start_jingle;
        niveau_pixel <= volume & "000"; -- donne l'équivalent du niveau du volume en pixel
       
    
-----------------------------------------------------------------------------------------------------------------------    
    
    process (clk_i, rst_i, btnd_i, btnu_i,sample_in, row_i, column_i)
    begin
    
    if rst_i = '1' then
        state_Volume <= standby;
        state_Jingle <= attente;
        pixel   <= '1';
        start_jingle <= '0';
        volume <= "1111";
    elsif rising_edge(clk_i) then
    
        --Switch case qui gere le niveau du son
        case state_Volume is 
            when up => 
                if (btnu_i='0' and btnd_i = '0') then  -- l'état dans lequel on se retrouve des quon relache le bouton up
                    if (volume < "1111") then
                        volume <= std_logic_vector(unsigned(volume)+1); --augmente le volume
                    else
                    volume <= "1111"; --si on est ici, ca veut dire que le volume est deja au maximum, alors on y reste
                    end if;
                state_Volume <= standby;
                end if;
                
            when down =>
            if (btnu_i='0' and btnd_i = '0') then -- l'état dans lequel on se retrouve des quon relache le bouton down
                    if (volume > "0000") then
                        volume <= std_logic_vector(unsigned(volume)-1); -- diminue le volume
                    else
                    volume <= "0000"; --si on est ici, ca veut dire que le volume est deja au minimum, alors on y reste
                    end if;
                state_Volume <= standby;
                end if;
                
            when standby => -- etat en attente qu'un bouton soit peser
            if (btnu_i='1') then
                state_Volume <= up;
            elsif (btnd_i='1') then
                state_Volume <= down;
            else
                state_Volume <= standby;
            end if;
            end case;
            
            --Switch case qui gere l'activation du jingle
            case state_Jingle is 
                when turnOn =>
                    start_Jingle <= '1';
                    state_Jingle <= turnOff;
                    
                when turnOff =>
                    start_Jingle <= '0';
                    state_Jingle <= attente;
                    
                when attente => 
                    if (btnu_i='1' or btnd_i = '1') then
                        state_Jingle <= turnOn;
                    else
                        state_Jingle <= attente;
                    end if;
            end case;
            --Switch case qui gere l'activation des pixels
            if (column_i < niveau_pixel) then
                pixel <= '1';
            else 
                pixel <= '0';
            end if;
    end if;
end process;
end Behavioral;