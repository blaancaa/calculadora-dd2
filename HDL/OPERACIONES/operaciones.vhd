library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all; --operaciones con signo

entity operaciones is
   port(clk, nRst:                    in std_logic;
        ena_op:                       in std_logic_vector(1 downto 0);
        operando1_ca2, operando2_ca2: in std_logic_vector(10 downto 0); --hasta 999 con 11 bits
        operacion:                    in std_logic_vector(1 downto 0);
        ena_res:                      buffer std_logic;
        resultado_ca2:                buffer std_logic_vector(20 downto 0)); 
end entity;

architecture rtl of operaciones is
--suma/resta => 12 bits de resultado
--al multiplicar dejar tamaño automatticoy y quitarle luego el (21)
 signal res_multiplicador: std_logic_vector(21 downto 0);
begin

MULT: entity work.multiplicador(syn)
      port map( dataa => operando1_ca2,
                datab => operando2_ca2,
                result => res_multiplicador);

--dependiendo del valor de operacion sacamos un resultado u otro
  process(clk, nRst)
  begin
    if nRst ='0' then
      resultado_ca2 <= (others => '0');
      ena_res <= '0';
    elsif clk'event and clk = '1' then
      ena_res <= '0';
      if ena_op = "11" then
        case operacion is
          when "01" => --suma
            resultado_ca2 <= ((20 downto 11 => operando1_ca2(10)) & operando1_ca2) + ((20 downto 11 => operando2_ca2(10)) & operando2_ca2);

          when "10" => --resta
            resultado_ca2 <= ((20 downto 11 => operando1_ca2(10)) & operando1_ca2) - ((20 downto 11 => operando2_ca2(10)) & operando2_ca2);

          when "11" => --multiplicación
            resultado_ca2 <= res_multiplicador(20 downto 0);

          when others => 
            resultado_ca2 <= (others => '0');

        end case;
        ena_res <= '1';
      end if;
    end if;
  end process;
end rtl;

