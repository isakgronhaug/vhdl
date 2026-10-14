-- dice.vhdl
-- Tryckknapp (T0) "roll" rullar tärningen
-- roll=0 : tärningen ligger stilla och visar ett värde
-- roll=1 : tärningen rullar
-- Strömbrytare (S0) "fake" väljer riktig eller falsk tärning
-- fake=0 : riktig tärning, dvs samma sannolikhet för 1,2,3,4,5 och 6
-- fake=1 : falsk tärning, dvs tre gånger högre sannolikhet för 6
-- Typically connect the following at the connector area of DigiMod
-- sclk <-- 32kHz

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity dice is
  port (
    clk   : in  std_logic;
    reset : in  std_logic;
    roll  : in  std_logic;
    fake  : in  std_logic;
    seg   : out std_logic_vector(6 downto 0);
    dp    : out std_logic;
    an    : out std_logic_vector(3 downto 0));
end entity;

architecture arch of dice is
  signal roll_s, fake_s : std_logic;
  signal cnt, fusk : unsigned(3 downto 0);

      type rom is array (0 to 6) of std_logic_vector(6 downto 0);
  constant mem : rom := (
    "1000000",
    "1111001",
    "0100100",
    "0110000",
    "0011001",
    "0010010",
    "0000010"
  );

  begin
    process(clk, reset) begin
      if reset = '1' then
        roll_s <= '0';
        fake_s <= '0';
        cnt <= "0001";
      elsif rising_edge(clk) then
        roll_s <= roll;
        fake_s <= fake;
        
        if (roll_s = '1') then 
          if (fake_s = '1') and (cnt = 8) then
            cnt <= "0001";
          elsif (fake_s = '0') and (cnt >= 6) then
            cnt <= "0001";
          else 
            cnt <= cnt + 1;
          end if;
        end if;
      end if;
    end process;

fusk <= "0110" when cnt > 6 else cnt;
seg <= mem(to_integer(fusk));
dp <= '1';
an <= "1110";

end architecture;
