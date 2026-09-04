library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity tb_ctrl_op is
end entity;

architecture test of tb_ctrl_op is
constant T_clk:       time      := 1 us;
signal clk,nRst:      std_logic;
signal tecla_pulsada: std_logic;
signal tecla:         std_logic_vector(3 downto 0);
signal operando1_bcd: std_logic_vector(11 downto 0);
signal operando2_bcd: std_logic_vector(11 downto 0);
signal operacion:     std_logic_vector(1 downto 0);
signal estado:        std_logic_vector(1 downto 0);
signal pulsado_op1:   std_logic;
signal pulsado_op2:   std_logic;
signal signo_op1:     std_logic;
signal signo_op2:     std_logic;
procedure valor_numerico(constant numeros:     in std_logic_vector(3 downto 0);
                         signal clk:           in std_logic;
                         signal tecla_pulsada: out std_logic;
                         signal tecla:         out std_logic_vector(3 downto 0));

procedure cambio_signo( signal clk:           in std_logic;
                        signal tecla_pulsada: out std_logic;
                        signal tecla:         out std_logic_vector(3 downto 0));

procedure suma( signal clk:           in std_logic;
                signal tecla_pulsada: out std_logic;
                signal tecla:         out std_logic_vector(3 downto 0));

procedure resta( signal clk:           in std_logic;
                 signal tecla_pulsada: out std_logic;
                 signal tecla:         out std_logic_vector(3 downto 0));


procedure multiplicar( signal clk:           in std_logic;
                       signal tecla_pulsada: out std_logic;
                       signal tecla:         out std_logic_vector(3 downto 0));

procedure igual( signal clk:           in std_logic;
                 signal tecla_pulsada: out std_logic;
                 signal tecla:         out std_logic_vector(3 downto 0));

procedure valor_numerico(constant numeros:     in std_logic_vector(3 downto 0);
                         signal clk:           in std_logic;
                         signal tecla_pulsada: out std_logic;
                         signal tecla:         out std_logic_vector(3 downto 0)) is
begin
wait until clk'event and clk = '1';
tecla_pulsada <= '1';
tecla <= numeros;
wait until clk'event and clk = '1';
tecla_pulsada <= '0';
wait until clk'event and clk = '1';
end procedure;

procedure cambio_signo( signal clk:           in std_logic;
                        signal tecla_pulsada: out std_logic;
                        signal tecla:         out std_logic_vector(3 downto 0))is
begin
wait until clk'event and clk = '1';
tecla_pulsada <= '1';
tecla <= X"C";
wait until clk'event and clk = '1';
tecla_pulsada <= '0';
end procedure;

procedure suma( signal clk:           in std_logic;
                signal tecla_pulsada: out std_logic;
                signal tecla:         out std_logic_vector(3 downto 0))is
begin
wait until clk'event and clk = '1';
tecla_pulsada <= '1';
tecla <= X"A";
wait until clk'event and clk = '1';
tecla_pulsada <= '0';
end procedure;

procedure resta( signal clk:           in std_logic;
                 signal tecla_pulsada: out std_logic;
                 signal tecla:         out std_logic_vector(3 downto 0))is
begin
wait until clk'event and clk = '1';
tecla_pulsada <= '1';
tecla <= X"D";
wait until clk'event and clk = '1';
tecla_pulsada <= '0';
end procedure;

procedure multiplicar( signal clk:           in std_logic;
                       signal tecla_pulsada: out std_logic;
                       signal tecla:         out std_logic_vector(3 downto 0))is
begin
wait until clk'event and clk = '1';
tecla_pulsada <= '1';
tecla <= X"E";
wait until clk'event and clk = '1';
tecla_pulsada <= '0';
end procedure;

procedure igual( signal clk:           in std_logic;
                 signal tecla_pulsada: out std_logic;
                 signal tecla:         out std_logic_vector(3 downto 0))is
begin
wait until clk'event and clk = '1';
tecla_pulsada <= '1';
tecla <= X"B";
wait until clk'event and clk = '1';
tecla_pulsada <= '0';
end procedure;

begin
   DUT: entity work.ctrl_op(rtl)
        port map( clk           => clk,
                  nRst          => nRst,
                  tecla_pulsada => tecla_pulsada,
                  tecla         => tecla,
                  operando1_bcd => operando1_bcd,
                  operando2_bcd => operando2_bcd,
                  operacion     => operacion,
                  estado        => estado,
                  pulsado_op1   => pulsado_op1,
                  pulsado_op2   => pulsado_op2,
                  signo_op1     => signo_op1,
                  signo_op2     => signo_op2);

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
tecla <= (others => '0');
tecla_pulsada <= '0';
wait until clk'event and clk = '1';
nRst <= '1';
valor_numerico(X"0",clk,tecla_pulsada,tecla);
igual(clk,tecla_pulsada,tecla);
cambio_signo(clk,tecla_pulsada,tecla);
cambio_signo(clk,tecla_pulsada,tecla);
valor_numerico(X"0",clk,tecla_pulsada,tecla);
valor_numerico(X"5",clk,tecla_pulsada,tecla);
cambio_signo(clk,tecla_pulsada,tecla);
valor_numerico(X"5",clk,tecla_pulsada,tecla);
valor_numerico(X"9",clk,tecla_pulsada,tecla);
cambio_signo(clk,tecla_pulsada,tecla);
suma(clk,tecla_pulsada,tecla);
valor_numerico(X"2",clk,tecla_pulsada,tecla);
igual(clk,tecla_pulsada,tecla);
cambio_signo(clk,tecla_pulsada,tecla);
valor_numerico(X"5",clk,tecla_pulsada,tecla);
valor_numerico(X"9",clk,tecla_pulsada,tecla);
cambio_signo(clk,tecla_pulsada,tecla);
valor_numerico(X"0",clk,tecla_pulsada,tecla);
valor_numerico(X"7",clk,tecla_pulsada,tecla);
resta(clk,tecla_pulsada,tecla);
valor_numerico(X"5",clk,tecla_pulsada,tecla);
valor_numerico(X"9",clk,tecla_pulsada,tecla);
cambio_signo(clk,tecla_pulsada,tecla);
valor_numerico(X"0",clk,tecla_pulsada,tecla);
valor_numerico(X"7",clk,tecla_pulsada,tecla);
valor_numerico(X"0",clk,tecla_pulsada,tecla);
igual(clk,tecla_pulsada,tecla);
valor_numerico(X"0",clk,tecla_pulsada,tecla);
cambio_signo(clk,tecla_pulsada,tecla);
multiplicar(clk,tecla_pulsada,tecla);
igual(clk,tecla_pulsada,tecla);
valor_numerico(X"3",clk,tecla_pulsada,tecla);
wait until clk'event and clk = '1';
assert false report "se acabo" severity failure;
end process;
end test;