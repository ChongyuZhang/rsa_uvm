//rsa interface
interface rsa_intf(input clk, input reset);
	logic  	[2047:0]	indata;
	logic  	[2047:0]	inExp;
	logic  	[2047:0]	inMod;
	logic  	[2047:0]	cypher;
	logic  				    ds;
	logic  				    ready;

	clocking drv_ck @(posedge clk);
		default input #1ns output #1ns;
		output  indata, inExp, inMod, ds;
		input 	cypher, ready;
	endclocking
	clocking mon_ck @(posedge clk);
		default input #1ns output #1ns;
		input indata, inExp, inMod, ds, cypher, ready;
	endclocking
endinterface
