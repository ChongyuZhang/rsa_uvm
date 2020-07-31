`timescale 1ns/1ns

`include "rsa_intf.sv"

module tb;
	logic   clk;
	logic   reset;

	//DUT
	v_ARS_RSACypher
	#(
		.KEYSIZE(2048)
	)
	modmultiply
	(
		.indata	(intf.indata),	// input  [2047:0] indata
		.inExp	(intf.inExp	),	// input  [2047:0] inExp
		.inMod	(intf.inMod	),	// input  [2047:0] inMod
		.cypher	(intf.cypher),	// output [2047:0] cypher
		.clk	  (clk		    ),	// input  clk
		.ds		  (intf.ds	  ),	// input  ds
		.reset	(reset		  ),	// input  reset
		.ready	(intf.ready	) 	// output ready
	);
  
  // clock generation
	initial
	begin 
		clk <= 0;
		forever
		begin
			#5 clk <= !clk;
		end
	end

  // reset trigger
	initial
	begin 
		#5 reset <= 1;
		repeat(10) @(posedge clk);
		reset <= 0;
	end

	import	rsa_pkg::*;
	import 	uvm_pkg::*;

	rsa_intf intf(.*);
	
	//uvm_config
	//set the virtual interface in env
	initial
	begin
		uvm_config_db#(virtual rsa_intf)::set(uvm_root::get(), "uvm_test_top.env.agt", "vif", intf);
		uvm_config_db#(virtual rsa_intf)::set(uvm_root::get(), "uvm_test_top.env.virt_sqr", "vif", intf);
		run_test("access_test");
	end
	
endmodule
