library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity conv_ca2_BCD is
   port(clk, nRst: in std_logic;
        resultado_ca2: in std_logic_vector(20 downto 0);
        ena_res: in std_logic;
        res_listo: buffer std_logic;
        resultado_BCD: buffer std_logic_vector(23 downto 0);
        signo_res: buffer std_logic
        );
end entity;

architecture rtl of conv_ca2_BCD is
signal bcd_reg: std_logic_vector(23 downto 0);
signal bin_reg: std_logic_vector (20 downto 0);
signal cuenta: std_logic_vector(4 downto 0); --contador de 0 a 20
type t_estado is (LIBRE, CARGAR, BUCLE, HECHO);
signal estado: t_estado;
signal c_u, c_d, c_c, c_um, c_dm: std_logic;
signal reg_resul, reg_resul_d, reg_resul_c, reg_resul_um, reg_resul_dm, reg_resul_cm: std_logic_vector(4 downto 0);
signal suma_bcd: std_logic_vector(23 downto 0);
signal reg_signo_res: std_logic;


begin

  process(clk, nRst)
  begin
    if nRst = '0' then 
      estado <= LIBRE;
      bcd_reg <= (others => '0');
      bin_reg <= (others => '0');
      cuenta <= (others => '0');
      resultado_BCD <= (others => '0');
      res_listo <= '0';
      signo_res <= '0';

    elsif clk'event and clk = '1' then
      case estado is

        when LIBRE =>
          res_listo <= '0';
          if ena_res = '1' then
            estado <= CARGAR;
          end if;

        when CARGAR =>
          if resultado_ca2(20) = '0' then
             bin_reg <= resultado_ca2;
          else
             bin_reg <= '0' & (not (resultado_ca2(19 downto 0)) + '1');
          end if;
          reg_signo_res <= resultado_ca2(20);
          bcd_reg  <= (others => '0');
          cuenta  <= (others => '0');
          estado <= BUCLE;

        when BUCLE =>
          -- Aplicamos el algoritmo: BCD = BCD + BCD + MSB_Binario
          bcd_reg <= suma_bcd;

          -- Desplazamos el registro binario hacia la izquierda
          bin_reg <= bin_reg(19 downto 0) & '0';

          if cuenta = 19 then
            estado <= HECHO;
          else
            cuenta <= cuenta + 1;
          end if;

        when HECHO =>
          res_listo <= '1';
          resultado_BCD <= bcd_reg;
          signo_res <= reg_signo_res;
          estado <= LIBRE;

      end case;
    end if;
  end process;

  --bloque sumador bcd combinacional
  -- bcd_reg + bcd_reg + bit_entrante = 2*bcd_reg + bit_entrante
  reg_resul    <= ('0' & bcd_reg(3 downto 0))   + bcd_reg(3 downto 0)   + bin_reg(19); -- El MSB entra como carry al sumador
  reg_resul_d  <= ('0' & bcd_reg(7 downto 4))   + bcd_reg(7 downto 4)   + c_u;
  reg_resul_c  <= ('0' & bcd_reg(11 downto 8))  + bcd_reg(11 downto 8)  + c_d;
  reg_resul_um <= ('0' & bcd_reg(15 downto 12)) + bcd_reg(15 downto 12) + c_c;
  reg_resul_dm <= ('0' & bcd_reg(19 downto 16)) + bcd_reg(19 downto 16) + c_um;
  reg_resul_cm <= ('0' & bcd_reg(23 downto 20)) + bcd_reg(23 downto 20) + c_dm;

  -- Lógica de corrección (Si > 9, resta 10 y genera acarreo)
  
  --UNIDADES
  process(reg_resul)
  begin
    if reg_resul > 9 then
      suma_bcd(3 downto 0) <= reg_resul(3 downto 0) - "1010";
      c_u <= '1';
    else
      suma_bcd(3 downto 0) <= reg_resul(3 downto 0);
      c_u <= '0';
    end if;
  end process;


  --DECENAS
  process(reg_resul_d)
  begin
    if reg_resul_d > 9 then
      suma_bcd(7 downto 4) <= reg_resul_d(3 downto 0) - "1010";
      c_d <= '1';
    else
      suma_bcd(7 downto 4) <= reg_resul_d(3 downto 0);
      c_d <= '0';
    end if;
  end process;


  --CENTENAS
  process(reg_resul_c)
  begin
    if reg_resul_c > 9 then
      suma_bcd(11 downto 8) <= reg_resul_c(3 downto 0) - "1010";
      c_c <= '1';
    else
      suma_bcd(11 downto 8) <= reg_resul_c(3 downto 0);
      c_c <= '0';
    end if;
  end process;

  --UNIDADES DE MILLAR
  process(reg_resul_um)
  begin
    if reg_resul_um > 9 then
      suma_bcd(15 downto 12) <= reg_resul_um(3 downto 0) - "1010";
      c_um <= '1';
    else
      suma_bcd(15 downto 12) <= reg_resul_um(3 downto 0);
      c_um <= '0';
    end if;
  end process;

  --DECENAS DE MILLAR
  process(reg_resul_dm)
  begin
    if reg_resul_dm > 9 then
      suma_bcd(19 downto 16) <= reg_resul_dm(3 downto 0) - "1010";
      c_dm <= '1';
    else
      suma_bcd(19 downto 16) <= reg_resul_dm(3 downto 0);
      c_dm <= '0';
    end if;
  end process;

  --CENTENAS DE MILLAR
  suma_bcd(23 downto 20) <= reg_resul_cm(3 downto 0);


end rtl;
