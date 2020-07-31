package rsa_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

  // data_t for rsa data and ref result
  typedef struct packed {
		bit	[2047:0] 	indata;
		bit	[2047:0]	inExp;
		bit	[2047:0]	inMod;
		bit [2047:0]	cypher;
		bit [2047:0]	ref_cypher;
		bit [40:0]		time_cnt;
	} data_t;

  // include verification environment files
  `include "rsa_trans.sv"
  `include "rsa_base_sequence.sv"
  `include "rsa_driver.sv"
  `include "rsa_monitor.sv"
  `include "rsa_sequencer.sv"
  `include "rsa_agent.sv"
  `include "rsa_scoreboard.sv"
  `include "rsa_virtual_sequencer.sv"
  `include "rsa_env.sv"
  `include "rsa_base_test.sv"
  `include "rsa_virtual_sequence.sv"
  
  // include sequences and tests
  `include "rsa_access_sequence.sv"
  `include "rsa_access_test.sv"

  `include "rsa_encrypt_2048b_sequence.sv"
  `include "rsa_encrypt_2048b_test.sv"

  `include "rsa_decrypt_2048b_sequence.sv"
  `include "rsa_decrypt_2048b_test.sv"

  `include "rsa_encrypt_1024b_sequence.sv"
  `include "rsa_encrypt_1024b_test.sv"

  `include "rsa_decrypt_1024b_sequence.sv"
  `include "rsa_decrypt_1024b_test.sv"

  `include "rsa_txt_2048b_sequence.sv"
  `include "rsa_txt_2048b_test.sv"

  `include "rsa_txt_1024b_sequence.sv"
  `include "rsa_txt_1024b_test.sv"

endpackage
