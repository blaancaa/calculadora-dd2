onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ctrl_op/DUT/clk
add wave -noupdate /tb_ctrl_op/DUT/nRst
add wave -noupdate /tb_ctrl_op/DUT/tecla_pulsada
add wave -noupdate -radix hexadecimal /tb_ctrl_op/DUT/tecla
add wave -noupdate -radix hexadecimal /tb_ctrl_op/DUT/operando1_bcd
add wave -noupdate /tb_ctrl_op/DUT/signo_op1
add wave -noupdate -radix hexadecimal /tb_ctrl_op/DUT/operando2_bcd
add wave -noupdate /tb_ctrl_op/DUT/signo_op2
add wave -noupdate /tb_ctrl_op/DUT/operacion
add wave -noupdate /tb_ctrl_op/DUT/estado
add wave -noupdate /tb_ctrl_op/DUT/pulsado_op1
add wave -noupdate /tb_ctrl_op/DUT/pulsado_op2
add wave -noupdate /tb_ctrl_op/DUT/est
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37315330 ps} 0}
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
WaveRestoreZoom {0 ps} {61819250 ps}
