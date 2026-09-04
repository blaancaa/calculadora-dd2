library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_conv_ca2_BCD is
end entity;

architecture test of tb_conv_ca2_BCD is
 constant T_clk:  time      := 1 us;
 signal resultado_ca2 : std_logic_vector(20 downto 0);
 signal res_listo : std_logic;
 signal clk, nRst, ena_res: std_logic;
 signal resultado_BCD: std_logic_vector(23 downto 0); 
 signal signo_res: std_logic;

begin
   DUT: entity work.conv_ca2_BCD(rtl)
        port map( clk => clk,
                  nRst => nRst,
                  ena_res => ena_res,
                  res_listo => res_listo,
                  resultado_ca2 => resultado_ca2,
                  resultado_BCD => resultado_BCD,
                  signo_res => signo_res);

  process
  begin
    clk <= '0';
    wait for T_clk/2;
    clk <= '1';
    wait for T_clk/2;
  end process;

  process
  begin
    nRst <= '0';
    resultado_ca2 <= (others => '0');
    ena_res <= '0';
    wait for 2*T_clk;
    nRst <= '1';

    wait for 3*T_clk;
    ena_res <= '1';
    resultado_ca2 <= '0' & X"00400"; --1.024
    wait for T_clk; 
    ena_res <= '0';
    wait until res_listo = '1';

    wait for 3*T_clk;
    ena_res <= '1';
    resultado_ca2 <='1' &  X"F423F"; --999.999
    wait for T_clk; 
    ena_res <= '0';
    wait until res_listo = '1';

    wait for 3*T_clk;
    ena_res <= '1';
    resultado_ca2 <='0' &  X"7FFFF"; --524.287
    wait for T_clk; 
    ena_res <= '0';
    wait until res_listo = '1';

    wait for 3*T_clk;
    ena_res <= '1';
    resultado_ca2 <='1' &  X"0C58F"; --65.535
    wait for T_clk; 
    ena_res <= '0';
    wait until res_listo = '1';

    wait for 3*T_clk;
    ena_res <= '1';
    resultado_ca2 <='0' &  X"0007B"; --123
    wait for T_clk; 
    ena_res <= '0';
    wait until res_listo = '1';

    wait for 3*T_clk;
    ena_res <= '1';
    resultado_ca2 <='1' &  X"00000"; --0
    wait for T_clk; 
    ena_res <= '0';
    wait until res_listo = '1'; 

    wait for 3*T_clk;
    ena_res <= '1';
    resultado_ca2 <= '0' & X"F4240"; --999.999 + 1 ¿debemos modelar aqui que no se pueda pasar?
    wait for T_clk; 
    ena_res <= '0';
    wait until res_listo = '1';

    wait for 3*T_clk; --PARA QUE SALGA EL ANTERIOR
    ena_res <= '1';
    resultado_ca2 <='1' &  X"00000"; --0
    wait for T_clk; 
    ena_res <= '0';
    wait until res_listo = '1'; 


    assert false report "se acabo" severity failure;
  end process;
end test;
