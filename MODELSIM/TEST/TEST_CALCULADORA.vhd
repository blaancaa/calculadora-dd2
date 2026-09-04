
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity TEST_CALCULADORA is
end entity;

architecture test of TEST_CALCULADORA is

-- Segnales del DUT

  signal clk:              std_logic;
  signal nRst:             std_logic;
  signal columna:          std_logic_vector(3 downto 0);
  signal fila:             std_logic_vector(3 downto 0);
  signal mux_disp:         std_logic_vector(7 downto 0);
  signal disp:             std_logic_vector(7 downto 0);

-- aux

  signal op:               std_logic_vector(3 downto 0);

 -- Constantes

  constant Tclk:           time := 20 ns; -- reloj de 50 MHz
  constant pulsacion_corta:time := 30 us; -- 1 tic de 250 ms

    -- Pulsación de una tecla del teclado
  procedure pulsa_tecla(signal   columna:   out std_logic_vector(3 downto 0); 
                        signal   clk:       in  std_logic;
			signal   fila:      in  std_logic_vector(3 downto 0);
                        constant tecla_test:     in  std_logic_vector(3 downto 0);
                        constant duracion:  in  time -- duracion de la pulsacion en ms
                        ); 

   -- Pulsacion de una tecla del teclado
  procedure pulsa_tecla(signal   columna:   out std_logic_vector(3 downto 0); 
                        signal   clk:       in  std_logic;
			signal   fila:      in  std_logic_vector(3 downto 0);
                        constant tecla_test:     in  std_logic_vector(3 downto 0);
                        constant duracion:  in  time -- duracion de la pulsacion en ms
                        ) is
  begin
   case(tecla_test) is
     when X"0" =>
       wait until fila'event and fila = "0111";
       columna <= "1101";
     when X"1" =>
       wait until fila'event and fila = "1110";
       columna <= "1110";
     when X"2" =>
       wait until fila'event and fila = "1110";
       columna <= "1101";
     when X"3" =>
       wait until fila'event and fila = "1110";
       columna <= "1011";
     when X"4" =>
       wait until fila'event and fila = "1101";
       columna <= "1110";
     when X"5" =>
       wait until fila'event and fila = "1101";
       columna <= "1101";
     when X"6" =>
       wait until fila'event and fila = "1101";
       columna <= "1011";
     when X"7" =>
       wait until fila'event and fila = "1011";
       columna <= "1110";
     when X"8" =>
       wait until fila'event and fila = "1011";
       columna <= "1101";
     when X"9" =>
       wait until fila'event and fila = "1011";
       columna <= "1011";
     when X"A" =>
       wait until fila'event and fila = "0111";
       columna <= "1110";
     when X"B" =>
       wait until fila'event and fila = "0111";
       columna <= "1011";
     when X"C" =>
       wait until fila'event and fila = "0111";
       columna <= "0111";
     when X"D" =>
       wait until fila'event and fila = "1011";
       columna <= "0111";
     when X"E" =>
       wait until fila'event and fila = "1101";
       columna <= "0111";
     when X"F" =>
       wait until fila'event and fila = "1110";
       columna <= "0111";  
     when others => null; 
   end case;
   wait for duracion;
   columna <= "1111";
   wait for 1000*Tclk;
   wait until clk'event and clk = '1';
   wait until clk'event and clk = '1';
 end procedure;
  
  begin

  -- Reloj de 50 MHz

  process
  begin
    clk <= '0';
    wait for Tclk/2;
    clk <= '1';
    wait for Tclk/2;
  end process;
 
  -- CALCULADORA

  dut: entity work.CALCULADORA(estructural)
       generic map(DIV_1ms     => 49  -- 1:1000
                   )
       port map(clk           => clk,
                nRst          => nRst,
                columna       => columna,
                fila          => fila,
                mux_disp      => mux_disp,
                seg           => disp
                );

  
-- Secuencia de estimulos

  process
  begin
	
    -- Reset
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    nRst <= '1';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    nRst <= '0';
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    columna <= (others => '1');
    wait until clk'event and clk = '1';
    wait until clk'event and clk = '1';
    nRst <= '1';
    op <= X"0"; 
    -- Fin de reset
    wait for 10*Tclk;
    wait until clk'event and clk = '1';
    report "*****************************TEST: fin del NRST";

    -- OPERACIONES
    report "*****************************TEST: OPERACIONES";
    wait for 200 us;
    wait until clk'event and clk = '1';
    -- suma 76+43, resta 76-43, multiplicacion 76*43
    op <= X"A"; --SUMA
    for i in 0 to 2 loop
          pulsa_tecla(columna, clk, fila, X"7", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"6", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, op, pulsacion_corta);--operación
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"4", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"3", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"B", pulsacion_corta); --=
          wait until clk'event and clk = '1';
          if i = 0 then
            op <= X"D"; --RESTA
          elsif i = 1 then
            op <= X"E"; --MULTIPLICAR
          end if;
          wait for 10*Tclk;
          wait until clk'event and clk = '1';

    end loop;

    -- suma, resta, multiplicacion de 0 y -0
    op <= X"A"; --SUMA
    for i in 0 to 2 loop
          pulsa_tecla(columna, clk, fila, X"0", pulsacion_corta); -- 0
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, op, pulsacion_corta); -- operación
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"C", pulsacion_corta); -- -
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"0", pulsacion_corta); -- -0
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"B", pulsacion_corta); -- =
          wait until clk'event and clk = '1';
          if i = 0 then
            op <= X"D"; --RESTA
          elsif i = 1 then
            op <= X"E"; --MULTIPLICAR
          end if;
          wait for 10*Tclk;
          wait until clk'event and clk = '1';
    end loop;

    -- suma, resta, multiplicacion de 024 y -785
    op <= X"A"; --SUMA
    for i in 0 to 2 loop
          pulsa_tecla(columna, clk, fila, X"0", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"2", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"4", pulsacion_corta); -- 024
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, op, pulsacion_corta); -- operación
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"C", pulsacion_corta); -- -
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"7", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"8", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"5", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"C", pulsacion_corta); -- +
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"C", pulsacion_corta); -- -785
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"B", pulsacion_corta); -- =
          wait until clk'event and clk = '1';
          if i = 0 then
            op <= X"D"; --RESTA
          elsif i = 1 then
            op <= X"E"; --MULTIPLICAR
          end if;
          wait for 10*Tclk;
          wait until clk'event and clk = '1';

    end loop;

    -- suma, resta, multiplicacion de -999 y -999
    op <= X"A"; --SUMA
    for i in 0 to 2 loop
          pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"C", pulsacion_corta); -- -999
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, op, pulsacion_corta); --operación
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"C", pulsacion_corta); -- -999
          wait until clk'event and clk = '1';
          pulsa_tecla(columna, clk, fila, X"B", pulsacion_corta); -- =
          wait until clk'event and clk = '1';
          if i = 0 then
            op <= X"D"; --RESTA
          elsif i = 1 then
            op <= X"E"; --MULTIPLICAR
          end if;
          wait for 10*Tclk;
          wait until clk'event and clk = '1';

    end loop;

    -- multiplicacion de 999 y -999
    op <= X"E"; --MULTIPLICAR
    pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
    wait until clk'event and clk = '1';
    pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
    wait until clk'event and clk = '1';
    pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta); -- 999
    wait until clk'event and clk = '1';
    pulsa_tecla(columna, clk, fila, op, pulsacion_corta); -- operación
    wait until clk'event and clk = '1';
    pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
    wait until clk'event and clk = '1';
    pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
    wait until clk'event and clk = '1';
    pulsa_tecla(columna, clk, fila, X"9", pulsacion_corta);
    wait until clk'event and clk = '1';
    pulsa_tecla(columna, clk, fila, X"C", pulsacion_corta); -- -999
    wait until clk'event and clk = '1';
    pulsa_tecla(columna, clk, fila, X"B", pulsacion_corta); -- =
    wait until clk'event and clk = '1';
    wait for 10*Tclk;
    wait until clk'event and clk = '1';

    -- Fin del test
    assert false
    report "fin del test de CALCULADORA"
    severity failure;

  end process;
end test;
