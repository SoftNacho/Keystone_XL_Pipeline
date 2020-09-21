onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /mp0_tb/clk
add wave -noupdate -divider Fetch
add wave -noupdate -label control_word /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/if_control_word
add wave -noupdate -label pc /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/pc/data
add wave -noupdate -label load_pc /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/load_pc
add wave -noupdate -label pcmux_sel /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/pcmux_sel_new
add wave -noupdate -label {ctrl_hzrd_stall
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/ctrl_hazard_stall
add wave -noupdate -label reset_sig /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/reset_sig
add wave -noupdate -label global_stall /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/global_stall
add wave -noupdate -label imem_stall /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/imem_stall
add wave -noupdate -label hazard_stall /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/hazard_stall
add wave -noupdate -label branch_enable /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/branch_enable
add wave -noupdate -label imem_resp /mp0_tb/NattyLight/lc3_b/mylittlecpu/imem_resp
add wave -noupdate -label imem_address /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/imem_address
add wave -noupdate -label imem_rdata /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/imem_rdata
add wave -noupdate /mp0_tb/NattyLight/ipmem_read
add wave -noupdate -label rom_opcode /mp0_tb/NattyLight/lc3_b/mylittlecpu/if_stage/rom_opcode
add wave -noupdate -label icache_dataway0 -expand /mp0_tb/NattyLight/i_cache/datapath/data0/data
add wave -noupdate -label icache_dataway1 -expand /mp0_tb/NattyLight/i_cache/datapath/data1/data
add wave -noupdate -label icache_tag0 /mp0_tb/NattyLight/i_cache/datapath/tag0/data
add wave -noupdate -label icache_tag1 /mp0_tb/NattyLight/i_cache/datapath/tag1/data
add wave -noupdate -label icache_valid0 /mp0_tb/NattyLight/i_cache/datapath/valid0/data
add wave -noupdate -label icache_valid1 /mp0_tb/NattyLight/i_cache/datapath/valid1/data
add wave -noupdate -label icache_hit /mp0_tb/NattyLight/i_cache/hit
add wave -noupdate -label icache_state /mp0_tb/NattyLight/i_cache/control/state
add wave -noupdate -divider Decode
add wave -noupdate -label control_word /mp0_tb/NattyLight/lc3_b/mylittlecpu/IFID/control_word_out
add wave -noupdate -label instruction /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/ir
add wave -noupdate -label sr1 /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/sr1
add wave -noupdate -label sr2 /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/sr2
add wave -noupdate -label sext5_out /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/sext5_out
add wave -noupdate -label load_regfile /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/registers/load
add wave -noupdate -label regfile_in /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/regfile_in
add wave -noupdate -label regfile -expand /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/registers/data
add wave -noupdate -label {idex_mem_read
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/hazmat/idex_mem_read
add wave -noupdate -label {ifid_rs
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/hazmat/ifid_rs
add wave -noupdate -label {ifid_rt
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/hazmat/ifid_rt
add wave -noupdate -label {idex_rd
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/hazmat/idex_rd
add wave -noupdate -label {hazard_stall
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/hazmat/hazard_stall
add wave -noupdate -label sr1_out /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/src_a
add wave -noupdate -label sr2_out /mp0_tb/NattyLight/lc3_b/mylittlecpu/id_stage/src_b
add wave -noupdate -divider Execute
add wave -noupdate -label control_word /mp0_tb/NattyLight/lc3_b/mylittlecpu/IDEX/control_word_out
add wave -noupdate -label dest /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/destmux/f
add wave -noupdate -label forwardA /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/forwardA
add wave -noupdate -label forwardB /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/forwardB
add wave -noupdate /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/hillarys_email_forwards/idex_rt
add wave -noupdate /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/hillarys_email_forwards/idex_rs
add wave -noupdate /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/hillarys_email_forwards/idex_rd
add wave -noupdate /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/hillarys_email_forwards/exmem_rd
add wave -noupdate /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/hillarys_email_forwards/memwb_rd
add wave -noupdate /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/hillarys_email_forwards/exmemb_hazard
add wave -noupdate -label alu_operand1 /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/ex_alu/a
add wave -noupdate -label alu_operand2 /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/alumux/f
add wave -noupdate -label alu_out /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/ex_alu/f
add wave -noupdate -label addermux_out /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/addermux/f
add wave -noupdate -label branch_addr /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage/ex_adder/f
add wave -noupdate -divider Mem
add wave -noupdate -label control_word /mp0_tb/NattyLight/lc3_b/mylittlecpu/ex_stage_register/control_word_out
add wave -noupdate -label load_stages /mp0_tb/NattyLight/lc3_b/mylittlecpu/load_stages
add wave -noupdate -label mar_a /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/marmux/a
add wave -noupdate -label mar_b /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/marmux/b
add wave -noupdate -label mar_f /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/marmux/f
add wave -noupdate -label mar_sel /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/marmux/sel
add wave -noupdate -label mdr_a /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/mdrmux/a
add wave -noupdate -label mdr_b /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/mdrmux/b
add wave -noupdate -label mdr_f /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/mdrmux/f
add wave -noupdate -label mdr_sel /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/mdrmux/sel
add wave -noupdate -label {icache_reset
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/icache_miss_counter/reset
add wave -noupdate -label {icache_ready
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/icache_miss_counter/ready
add wave -noupdate -label {icache_event
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/icache_miss_counter/count_event
add wave -noupdate -label {icache_count
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/icache_miss_counter/count
add wave -noupdate -label {icache_dataout
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/icache_miss_counter/data_out
add wave -noupdate /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/stall
add wave -noupdate /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/cur_state
add wave -noupdate -label way0_data /mp0_tb/NattyLight/d_cache/datapath/data0/data
add wave -noupdate -label way1_data /mp0_tb/NattyLight/d_cache/datapath/data1/data
add wave -noupdate -label way0_tag /mp0_tb/NattyLight/d_cache/datapath/tag0/data
add wave -noupdate -label way1_tag /mp0_tb/NattyLight/d_cache/datapath/tag1/data
add wave -noupdate -label way0_valid /mp0_tb/NattyLight/d_cache/datapath/valid0/data
add wave -noupdate -label way1_valid /mp0_tb/NattyLight/d_cache/datapath/valid1/data
add wave -noupdate -label way0_dirty /mp0_tb/NattyLight/d_cache/datapath/dirty0/data
add wave -noupdate -label way1_dirty /mp0_tb/NattyLight/d_cache/datapath/dirty1/data
add wave -noupdate -label dcache_state /mp0_tb/NattyLight/d_cache/control/state
add wave -noupdate /mp0_tb/NattyLight/d_cache/mem_read
add wave -noupdate -label dirty_control /mp0_tb/NattyLight/d_cache/control/dirty
add wave -noupdate -label {resp
} /mp0_tb/NattyLight/lc3_b/mylittlecpu/mem_stage/mem_resp_in
add wave -noupdate -divider Writeback
add wave -noupdate -label control_word /mp0_tb/NattyLight/lc3_b/mylittlecpu/MEMWB/control_word_out
add wave -noupdate -label regfilemux_sel /mp0_tb/NattyLight/lc3_b/mylittlecpu/wb_stage/regfilemux_sel
add wave -noupdate -label regfilemux_out /mp0_tb/NattyLight/lc3_b/mylittlecpu/wb_stage/regfilemux_out
add wave -noupdate -label alu_out /mp0_tb/NattyLight/lc3_b/mylittlecpu/wb_stage/alu_out
add wave -noupdate -divider Arbiter
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/ipmem_wdata
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/ipmem_address
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/ipmem_read
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/ipmem_write
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/dpmem_wdata
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/dpmem_address
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/dpmem_read
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/dpmem_write
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/pmem_rdata
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/mem_wdata
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/pmem_wdata
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/pmem_address
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/pmem_read
add wave -noupdate /mp0_tb/NattyLight/ARBYS_WE_HAVE_THE_MEATS/datapath/pmem_write
add wave -noupdate -divider L2
add wave -noupdate -divider {Eviction Write Buffer}
add wave -noupdate /mp0_tb/NattyLight/pmem_write
add wave -noupdate /mp0_tb/NattyLight/ewb/address
add wave -noupdate /mp0_tb/NattyLight/ewb/write
add wave -noupdate /mp0_tb/NattyLight/ewb/pmem_read
add wave -noupdate /mp0_tb/NattyLight/ewb/din
add wave -noupdate /mp0_tb/NattyLight/ewb/pmem_resp
add wave -noupdate /mp0_tb/NattyLight/ewb/resp
add wave -noupdate /mp0_tb/NattyLight/pmemewb_resp
add wave -noupdate /mp0_tb/NattyLight/ewb/dout
add wave -noupdate /mp0_tb/NattyLight/ewb/address_out
add wave -noupdate /mp0_tb/NattyLight/ewb/pmem_write
add wave -noupdate /mp0_tb/NattyLight/ewb/full
add wave -noupdate /mp0_tb/NattyLight/ewb/load
add wave -noupdate /mp0_tb/NattyLight/ewb/data
add wave -noupdate /mp0_tb/NattyLight/ewb/data_address
add wave -noupdate -divider 4way
add wave -noupdate /mp0_tb/phys_mem/mem
add wave -noupdate /mp0_tb/NattyLight/hehehehe/retrieve_data1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/retrieve_data0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/retrieve_data
add wave -noupdate /mp0_tb/NattyLight/hehehehe/eviction1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/eviction0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/eviction
add wave -noupdate /mp0_tb/NattyLight/hehehehe/hit_or_miss1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/hit_or_miss0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/hit_or_miss
add wave -noupdate /mp0_tb/NattyLight/hehehehe/lru
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_write1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_write0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_write
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_read1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_read0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_read
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_resp1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_resp0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_resp
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_wdata1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_wdata0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_wdata
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_rdata1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_rdata0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_rdata
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_address1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_address0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/pmem_address
add wave -noupdate /mp0_tb/NattyLight/hehehehe/miss_out
add wave -noupdate /mp0_tb/NattyLight/hehehehe/miss1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/miss0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_write_cache1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_write_cache0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_write
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_wdata_cache1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_wdata_cache0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_wdata
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_resp1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_resp0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_resp
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_read_cache1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_read_cache0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_read
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_rdata1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_rdata0
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_rdata
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_byte_enable
add wave -noupdate /mp0_tb/NattyLight/hehehehe/mem_address
add wave -noupdate /mp0_tb/NattyLight/hehehehe/hit_out
add wave -noupdate /mp0_tb/NattyLight/hehehehe/hit1
add wave -noupdate /mp0_tb/NattyLight/hehehehe/hit0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {952508 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 209
configure wave -valuecolwidth 119
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
configure wave -timelineunits ns
update
WaveRestoreZoom {99991663 ps} {100000439 ps}
