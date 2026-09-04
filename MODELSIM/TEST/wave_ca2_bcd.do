onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_conv_bin_bcd/clk
add wave -noupdate /tb_conv_bin_bcd/nRst
add wave -noupdate /tb_conv_bin_bcd/ena_res
add wave -noupdate -radix decimal /tb_conv_bin_bcd/resultado_ca2
add wave -noupdate -radix hexadecimal /tb_conv_bin_bcd/resultado_BCD
add wave -noupdate /tb_conv_bin_bcd/signo_res
add wave -noupdate /tb_conv_bin_bcd/res_listo
add wave -noupdate /tb_conv_bin_bcd/DUT/estado
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20410443 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 127
configure wave -valuecolwidth 50
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
WaveRestoreZoom {0 ps} {201492284 ps}
