
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ctrl_tec is
port(clk, nRst, tic : in std_logic;
     columna: in std_logic_vector(3 downto 0);
     tecla, fila: buffer std_logic_vector(3 downto 0);
     tecla_pulsada : buffer std_logic);
end entity;

architecture rtl of ctrl_tec is
 signal tecla_detectada, ena, lim, columna_activa, tecla_detectada_anterior: std_logic;
 signal reg_tecla, reg_tecla2: std_logic_vector(3 downto 0);
 signal col_x_reg, col_sin_rebotes, fila_reg: std_logic_vector(3 downto 0);
 signal cnt: std_logic_vector(8 downto 0);
  type t_estado is (espera, muestreo);
  signal estado: t_estado;
begin

--rebotes
 process(nRst, clk)
 begin
   if nRst = '0' then
     col_x_reg <= X"0";
   elsif clk'event and clk = '1' then
     col_x_reg <= columna;
   end if;
 end process;

 process(nRst, clk)
 begin
   if nRst = '0' then
     col_sin_rebotes <= X"F";
   elsif clk'event and clk = '1' then
     if tic = '1' then --con tic
       col_sin_rebotes <= col_x_reg;
     end if;
   end if;
 end process;

--detector de tecla

  reg_tecla <= x"C" when fila_reg = "0111" and col_sin_rebotes = "0111" else --fila 3 
               x"B" when fila_reg = "0111" and col_sin_rebotes = "1011" else
               x"0" when fila_reg = "0111" and col_sin_rebotes = "1101" else
               x"A" when fila_reg = "0111" and col_sin_rebotes = "1110" else 

               x"D" when fila_reg = "1011" and col_sin_rebotes = "0111" else --fila 2
               x"9" when fila_reg = "1011" and col_sin_rebotes = "1011" else
               x"8" when fila_reg = "1011" and col_sin_rebotes = "1101" else
               x"7" when fila_reg = "1011" and col_sin_rebotes = "1110" else 

               x"E" when fila_reg = "1101" and col_sin_rebotes = "0111" else --fila 1
               x"6" when fila_reg = "1101" and col_sin_rebotes = "1011" else
               x"5" when fila_reg = "1101" and col_sin_rebotes = "1101" else
               x"4" when fila_reg = "1101" and col_sin_rebotes = "1110" else 

               x"F" when fila_reg = "1110" and col_sin_rebotes = "0111" else --fila 0
               x"3" when fila_reg = "1110" and col_sin_rebotes = "1011" else
               x"2" when fila_reg = "1110" and col_sin_rebotes = "1101" else
               x"1" when fila_reg = "1110" and col_sin_rebotes = "1110" else 
	      "0000";

  process(clk, nRst)
  begin
    if nRst = '0' then
      tecla_detectada_anterior <= '0';
    elsif clk'event and clk = '1' then
      if tic = '1' then 
        tecla_detectada_anterior <= tecla_detectada;
      end if;
    end if;
  end process;
 

  process(clk, nRst)
  begin
    if nRst = '0' then
      tecla <= (others => '0');
      tecla_pulsada <= '0';
    elsif clk'event and clk = '1' then
        tecla_pulsada <= '0';
      if tecla_detectada = '1' and tecla_detectada_anterior = '0' then --cuando tecla detectada tenga flanco de subida
        tecla <= reg_tecla;
        tecla_pulsada <= '1';
      end if;
    end if;
  end process;


--muestreador

--Muestrea cíclicamente las filas(pasea un nivel bajo, empezando por la primera fila y hasta 
--llegar  a  la  última,  repitiendo  la  secuencia  indefinidamente),  hasta  que  en  alguna  de  las 
--entradas de las columnas se detecte un nivel bajo. 

  process(clk, nRst)
  begin
    if nRst = '0' then
      fila <= "1111"; 
      estado <= espera;
    elsif clk'event and clk = '1' then
      if tic = '1' then

        case estado is
          when espera =>                          
            if tecla_detectada = '0' then --muestreamos hasta detectar tecla
              fila <= "1110"; --fila0
              estado <= muestreo;
            end if;

          when muestreo =>  
            if columna_activa = '0' then --muestreamos hasta detectar tecla 
               case fila is 
                 when "1110" => fila <= "1101"; --fila1
                 when "1101" => fila <= "1011"; --fila2
                 when "1011" => fila <= "0111"; --fila3
                 when others => fila <= "1110"; --fila0 de nuevo
               end case;
            else --se ha detectado tecla)
              estado <= espera;
            end if;

        end case;
      end if;
    end if;
  end process;

  tecla_detectada <= '1' when col_sin_rebotes /= X"F" else
                     '0'; --se detecta tecla cuando una de las columnas se pone a 0

  columna_activa <= '1' when columna /= "1111" else '0';

 process(nRst, clk)--registramos la fila tambien
 begin
   if nRst = '0' then
     fila_reg <= "1111";
   elsif clk'event and clk = '1' then
     if tic = '1' then --con tic
       fila_reg <= fila;
     end if;
   end if;
 end process;

end rtl;