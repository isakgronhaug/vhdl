-- comb_lock.vhdl
-- x1 styrs av v√§nster skjutomkopplare S1
-- x0 styrs av h√∂ger skjutomkopplare S0
-- Typically connect the following at the connector area of DigiMod
-- sclk <-- 32kHz

library ieee;
  use ieee.std_logic_1164.all;

entity comb_lock is
  port (clk   : in  std_logic; -- "fast enough"
        reset : in  std_logic; -- active high
        x1    : in  std_logic; -- x1 is left
        x0    : in  std_logic; -- x0 is right
        u     : out std_logic
       );
end entity;

architecture rtl of comb_lock is
  signal x1s, x0s : std_logic; --synkade ingÂngar x1, x0
  signal q, q_plus : std_logic_vector(1 downto 0); --q1, q0, q1+, q0+
  signal prom_in : std_logic_vector(3 downto 0); --prom ingÂngar 3, 2, 1, 0 (q1, q0, x1s, x0s)
  signal prom_ut : std_logic_vector(2 downto 0); --prom utgÂngar, q1+, q0+, u
  begin
    prom_in <= q & x1s & x0s;
    q_plus <= prom_ut(2 downto 1);
    u <= prom_ut(0);

  process(prom_in)
  begin
    case prom_in is --tillstÂndstabell
      when "0000" => prom_ut <= "010";
      when "0001" => prom_ut <= "000";
      when "0010" => prom_ut <= "000";
      when "0011" => prom_ut <= "000";
      when "0100" => prom_ut <= "010";
      when "0101" => prom_ut <= "100";
      when "0110" => prom_ut <= "000";
      when "0111" => prom_ut <= "000";
      when "1000" => prom_ut <= "010";
      when "1001" => prom_ut <= "100";
      when "1010" => prom_ut <= "000";
      when "1011" => prom_ut <= "110";
      when "1100" => prom_ut <= "011";
      when "1101" => prom_ut <= "111";
      when "1110" => prom_ut <= "111";
      when "1111" => prom_ut <= "111";
      when others => prom_ut <= "000";
    end case;
  end process;

  process(clk, reset)
  begin
    if reset = '1' then
      x1s <= '0';
      x0s <= '0';
      q <= "00";
    elsif rising_edge(clk) then
      x1s <= x1;
      x0s <= x0;
      q <= q_plus;
    end if;
  end process;

end architecture;
