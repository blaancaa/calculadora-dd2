onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_calculadora/clk
add wave -noupdate /test_calculadora/nRst
add wave -noupdate /test_calculadora/columna
add wave -noupdate /test_calculadora/fila
add wave -noupdate /test_calculadora/mux_disp
add wave -noupdate /test_calculadora/disp
add wave -noupdate -radix hexadecimal /test_calculadora/op
add wave -noupdate /test_calculadora/dut/tecla_pulsada
add wave -noupdate -radix hexadecimal /test_calculadora/dut/tecla
add wave -noupdate -radix hexadecimal /test_calculadora/dut/operando1_bcd
add wave -noupdate -radix hexadecimal /test_calculadora/dut/operando2_bcd
add wave -noupdate /test_calculadora/dut/operacion
add wave -noupdate /test_calculadora/dut/estado
add wave -noupdate /test_calculadora/dut/signo_op1
add wave -noupdate /test_calculadora/dut/signo_op2
add wave -noupdate -radix decimal /test_calculadora/dut/resultado_ca2
add wave -noupdate -radix hexadecimal /test_calculadora/dut/resultado_BCD
add wave -noupdate /test_calculadora/dut/signo_res
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {868524046 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ms
update
WaveRestoreZoom {500726394 ps} {1232301589 ps}
