-- timer.vhdl
-- Tryckknapp (T0) "startknapp" startar nedräkningen av timern från 8.
-- Timern räknar sedan ned autonomt till 0 och stannar.
-- Utsignal "alarm" tänds när timern visar 0
-- Typically connect the following at the connector area of DigiMod
-- sclk <-- 1Hz

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity timer is
  port (clk        : in  std_logic; -- clk is 1 Hz
        reset      : in  std_logic; -- aktiv hög
        startknapp : in  std_logic; -- aktiv hög
        alarm      : out std_logic;
        seg        : out std_logic_vector(6 downto 0);
        dp         : out std_logic;
        an         : out std_logic_vector(3 downto 0)
       );
end entity;

architecture rtl of timer is
  signal x_s, x_s2, x_EP : std_logic;
  signal cnt : unsigned(3 downto 0);

    type rom is array (0 to 8) of std_logic_vector(6 downto 0);
  constant mem : rom := (
    "1000000",
    "1111001",
    "0100100",
    "0110000",
    "0011001",
    "0010010",
    "0000010",
    "1111000",
    "0000000"
  );

begin
  process(clk, reset) begin
    if reset = '1' then
      x_s <= '0';
      x_s2 <= '0';
      cnt <= "0000";
    elsif rising_edge(clk) then
      x_s <= startknapp;
      x_s2 <= x_s;
      if (x_EP = '1') and (cnt = 0) then
        cnt <= "1000";
      elsif cnt /= 0 then
        cnt <= cnt - 1;
      end if;
    end if;
  end process;
  x_EP <= x_s and (not x_s2);

  alarm <= '1' when cnt = "0000" else '0';

  seg <= mem(to_integer(cnt));
  dp <= '1';
  an <= "1110";

end architecture;

