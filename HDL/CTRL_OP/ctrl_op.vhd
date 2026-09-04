library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all; --operaciones con signo

entity ctrl_op is
   port(clk, nRst, tecla_pulsada: in std_logic;
        tecla: in std_logic_vector(3 downto 0);
        operando1_bcd, operando2_bcd: buffer std_logic_vector(11 downto 0); --hasta 999 con 12 bits
        operacion, estado: buffer std_logic_vector(1 downto 0);
        pulsado_op1, pulsado_op2, signo_op1, signo_op2: buffer std_logic); 
end entity;

architecture rtl of ctrl_op is
 signal reg_tecla_pulsada: std_logic;
 type t_est is (espera, primer_operando, segundo_operando, resultado);
 signal est: t_est;
 function tipo_operacion (tecla: std_logic_vector(3 downto 0);
                          tecla_pulsada: std_logic) return std_logic_vector;
 function tipo_operacion (tecla: std_logic_vector(3 downto 0);
                          tecla_pulsada: std_logic) return std_logic_vector is
 begin
    if tecla = X"A" and tecla_pulsada = '1' then
       return "01";
    elsif tecla = X"D" and tecla_pulsada = '1' then
       return "10";
    elsif tecla = X"E" and tecla_pulsada = '1' then
       return "11";
    else
       return "00";
    end if;
 end function;

begin
  -- Control del estado 
  process(clk, nRst)
  begin
    if nRst = '0' then
      est <= espera;
      operando1_bcd <= X"000";
      operando2_bcd <= X"000";
      pulsado_op1 <= '0';
      pulsado_op2 <= '0';
      signo_op1 <= '0';
      signo_op2 <= '0';
      operacion <= "00";

    elsif clk'event and clk = '1' then
      if tecla_pulsada = '1' then
        case est is
          when espera => 
            if (tecla = X"B" or tecla = X"0") and tecla_pulsada = '1'  then --pulsamos un numero
                operando1_bcd <= X"000";
            elsif (tecla = X"A" or tecla = X"D" or tecla = X"E") and tecla_pulsada = '1' then --pulsamos suma, resta o multiplicacion
                operando1_bcd <= X"000";
                pulsado_op1 <= '1';
                est <= segundo_operando;
                operacion <= tipo_operacion(tecla,tecla_pulsada);
            elsif tecla = X"C" and tecla_pulsada = '1' then
                signo_op1 <= not signo_op1; --cambia de signo
            elsif tecla_pulsada = '1' then
                operando1_bcd <= X"00" & tecla;
                est <= primer_operando;
            end if;

          when primer_operando => 

            if (tecla = X"A" or tecla = X"D" or tecla = X"E") and tecla_pulsada = '1' then --pulsamos suma, resta o multiplicacion
              pulsado_op1 <= '1';
              operacion <= tipo_operacion(tecla,tecla_pulsada);
              est <= segundo_operando;
            elsif tecla = X"C" and tecla_pulsada = '1' then
                signo_op1 <= not signo_op1; --cambia de signo
            elsif tecla /= X"B" and tecla_pulsada = '1' then --para que no escriba B
                if operando1_bcd(11 downto 8) = X"0" then -- Para que no escriba mas de 3 digitos
                   operando1_bcd <= operando1_bcd(7 downto 0) & tecla;
                else
                   operando1_bcd <= operando1_bcd;
                end if;
            end if;

          when segundo_operando => 

            if tecla = X"B" and tecla_pulsada = '1' then --pulsamos igual
              pulsado_op2 <= '1';
              est <= resultado;
            elsif tecla = X"C" and tecla_pulsada = '1' then
                signo_op2 <= not signo_op2; --cambia de signo
            elsif (tecla = X"0" and operando2_bcd = X"000") and tecla_pulsada = '1' then
                operando2_bcd <= X"000";
            elsif (tecla = X"A" or tecla = X"D" or tecla = X"E") and tecla_pulsada = '1' then --si recibimos un 0 habiendo metido un digito valido, si se guarda
                operando2_bcd <= operando2_bcd;
            elsif tecla_pulsada = '1' then --para que no escriba A, D o E
                if operando2_bcd(11 downto 8) = X"0" then -- Para que no escriba mas de 3 digitos 
                   operando2_bcd <= operando2_bcd(7 downto 0) & tecla;
                else
                   operando2_bcd <= operando2_bcd;
                end if;
            end if;
          when resultado => 

            if (tecla = X"B" or tecla = X"A" or tecla = X"D" or tecla = X"E" or tecla = X"C" or tecla = X"0") and tecla_pulsada = '1' then --pulsamos igua, suma, resta, multiplicacion, signo o cero
              operando1_bcd <= X"000";
              operando2_bcd <= X"000";
              pulsado_op1 <= '0';
              pulsado_op2 <= '0';
              signo_op1 <= '0';
              signo_op2 <= '0';
              operacion <= "00";
              est <= espera;
            elsif tecla_pulsada = '1' then
              operando1_bcd <= X"00" & tecla;
              operando2_bcd <= X"000";
              pulsado_op1 <= '0';
              pulsado_op2 <= '0';
              signo_op1 <= '0';
              signo_op2 <= '0';
              operacion <= "00";
              est <= primer_operando;
            end if;
        end case;
      end if;
    end if;
  end process;

  estado <= "00" when est = espera or est = primer_operando else
            "01" when est = segundo_operando else
            "10" when est = resultado else
            "XX";

  process(clk, nRst)
  begin
    if nRst = '0' then
      reg_tecla_pulsada <= '0';
    elsif clk'event and clk = '1' then
      reg_tecla_pulsada <= tecla_pulsada;
    end if;
  end process;

end rtl;

