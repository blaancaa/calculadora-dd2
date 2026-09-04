
library ieee;
use ieee.std_logic_1164.all;

entity CALCULADORA is 
generic(                        -- Los valores por defecto para sintesis logica. En la simulacion se utilizan otros valores para escalarla
    DIV_1ms : natural := 49999
   );
port(
    clk           : in std_logic;
    nRst          : in std_logic;
    columna       : in std_logic_vector(3 downto 0);
    fila          : buffer std_logic_vector(3 downto 0);
    mux_disp      : buffer std_logic_vector(7 downto 0);
    seg           : buffer std_logic_vector(7 downto 0)
    );  
end entity;

architecture estructural of CALCULADORA is
  signal tic_1ms:         std_logic;
  signal tic_5ms:         std_logic;
  signal tecla_pulsada:   std_logic;
  signal tecla:           std_logic_vector(3 downto 0);
  signal operando1_bcd:   std_logic_vector(11 downto 0);
  signal operando2_bcd:   std_logic_vector(11 downto 0);
  signal operacion:       std_logic_vector(1 downto 0);
  signal estado:          std_logic_vector(1 downto 0);
  signal pulsado_op1:     std_logic;
  signal pulsado_op2:     std_logic;
  signal signo_op1:       std_logic;
  signal signo_op2:       std_logic;
  signal ena_op:          std_logic_vector(1 downto 0);
  signal operando2_ca2:   std_logic_vector(10 downto 0);
  signal operando1_ca2:   std_logic_vector(10 downto 0);
  signal ena_res:         std_logic;
  signal resultado_ca2:   std_logic_vector(20 downto 0);  
  signal res_listo:       std_logic;
  signal resultado_BCD:   std_logic_vector(23 downto 0);
  signal signo_res:       std_logic;
begin

CTRL_TEC: entity work.ctrl_tec(rtl)
port map(
    clk           => clk,
    nRst          => nRst,
    tic           => tic_5ms,
    columna       => columna,
    tecla         => tecla,
    fila          => fila,
    tecla_pulsada => tecla_pulsada
    );  

CTRL_OP: entity work.ctrl_op(rtl) 
port map(
     clk           => clk,
     nRst          => nRst,
     tecla_pulsada => tecla_pulsada,
     tecla         => tecla,
     operando1_bcd => operando1_bcd,
     operando2_bcd => operando2_bcd,
     operacion     => operacion,               
     estado        => estado,      --ACABAR              
     pulsado_op1   => pulsado_op1,
     pulsado_op2   => pulsado_op2,
     signo_op1     => signo_op1,               
     signo_op2     => signo_op2                
    );

OP1: entity work.conv_BCD_ca2(rtl) 
port map(
    clk           => clk,
    nRst          => nRst,
    ena_convertir => pulsado_op1,
    valor_bcd     => operando1_bcd,
    valor_signo   => signo_op1,
    valor_listo   => ena_op(1),
    valor_ca2     => operando1_ca2
    );

OP2: entity work.conv_BCD_ca2(rtl) 
port map(
    clk           => clk,
    nRst          => nRst,
    ena_convertir => pulsado_op2,
    valor_bcd     => operando2_bcd,
    valor_signo   => signo_op2,
    valor_listo   => ena_op(0), 
    valor_ca2     => operando2_ca2
    );

Operar: entity work.operaciones(rtl) 
port map(
     clk           => clk,
     nRst          => nRst,
     ena_op        => ena_op,
     operando1_ca2 => operando1_ca2,
     operando2_ca2 => operando2_ca2,
     operacion     => operacion,
     ena_res       => ena_res,
     resultado_ca2 => resultado_ca2
    );

Resul: entity work.conv_ca2_BCD(rtl) 
port map(
    clk           => clk,
    nRst          => nRst,
    resultado_ca2 => resultado_ca2,
    ena_res       => ena_res,
    res_listo     => res_listo,  --No tiene utilidad creo
    resultado_BCD => resultado_BCD, 
    signo_res     => signo_res
    );

TIMER: entity work.timer(rtl) 
generic map(
    DIV_1ms     => DIV_1ms
    )
port map(
    clk         => clk,
    nRst        => nRst,
    tic_5ms     => tic_5ms,
    tic_1ms     => tic_1ms
    );
	
DISPLAY: entity work.displays(rtl) 
port map(
     clk      => clk,
     nRst     => nRst,
     tic_1ms  => tic_1ms,
     pres     => estado,
     op1      => operando1_bcd,
     op1_sgn  => signo_op1,
     op2      => operando2_bcd,
     op2_sgn  => signo_op2,
     res      => resultado_BCD,
     res_sgn  => signo_res,
     mux_disp => mux_disp,
     disp     => seg 
    );


end estructural;