onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_conv_bcd_bin/DUT/clk
add wave -noupdate /tb_conv_bcd_bin/DUT/nRst
add wave -noupdate /tb_conv_bcd_bin/DUT/ena_convertir
add wave -noupdate -radix hexadecimal /tb_conv_bcd_bin/DUT/valor_bcd
add wave -noupdate /tb_conv_bcd_bin/DUT/valor_signo
add wave -noupdate /tb_conv_bcd_bin/DUT/valor_listo
add wave -noupdate -radix decimal /tb_conv_bcd_bin/valor_ca2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12911928 ps} 0}
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
WaveRestoreZoom {0 ps} {21525 ns}
