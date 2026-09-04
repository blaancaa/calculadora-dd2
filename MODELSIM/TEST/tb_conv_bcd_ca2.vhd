library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_conv_BCD_ca2 is
end entity;

architecture test of tb_conv_BCD_ca2 is
constant T_clk:  time      := 1 us;
signal clk,nRst: std_logic;
signal valor_bcd: std_logic_vector(11 downto 0);
signal valor_ca2: std_logic_vector(10 downto 0);
signal valor_signo, ena_convertir: std_logic;
signal valor_listo: std_logic;

 procedure espera_cambio(constant digitos_bcd: in std_logic_vector(11 downto 0);
                         constant sig: in std_logic;
                         signal clk: in std_logic;
                         signal ena_convertir: out std_logic;
                         signal valor_listo: in std_logic;
                         signal valor_signo: out std_logic;
                         signal valor_bcd: out std_logic_vector(11 downto 0)
                        );
 procedure espera_cambio(constant digitos_bcd: in std_logic_vector(11 downto 0);
                         constant sig: in std_logic;
                         signal clk: in std_logic;
                         signal ena_convertir: out std_logic;
                         signal valor_listo: in std_logic;
                         signal valor_signo: out std_logic;
                         signal valor_bcd: out std_logic_vector(11 downto 0)
                        )is
 begin
   wait until clk'event and clk = '1';
   ena_convertir <= '1';
   valor_bcd <= digitos_bcd;
   valor_signo <= sig;
   wait until valor_listo = '1';
   ena_convertir <= '0';
   wait for 2*T_clk;
 end procedure;

begin

   DUT: entity work.conv_BCD_ca2(rtl)
        port map( clk           => clk,
                  nRst          => nRst,
                  ena_convertir => ena_convertir,
                  valor_listo   => valor_listo,
                  valor_signo   => valor_signo,
                  valor_bcd     => valor_bcd,
                  valor_ca2     => valor_ca2);

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
  valor_bcd <= (others => '0');
  valor_signo <= '0';
  ena_convertir <= '0';
  wait for 2*T_clk;
  nRst <= '1';
  espera_cambio(X"453", '0', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  espera_cambio(X"999", '1', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  espera_cambio(X"888", '0', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  espera_cambio(X"555", '1', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  espera_cambio(X"222", '0', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  espera_cambio(X"002", '1', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  espera_cambio(X"067", '0', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  espera_cambio(X"008", '0', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  espera_cambio(X"000", '1', clk, ena_convertir, valor_listo, valor_signo, valor_bcd);
  assert false report "se acabo" severity failure;
 end process;
end test;