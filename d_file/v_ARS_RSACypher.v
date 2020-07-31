module v_ARS_RSACypher
#(
	parameter	KEYSIZE	=	2048
)
(
	input		    [KEYSIZE-1 : 0]	indata,
	input		    [KEYSIZE-1 : 0]	inExp,
	input		    [KEYSIZE-1 : 0]	inMod,
	output	reg	[KEYSIZE-1 : 0]	cypher,
	input					            	clk,
	input					             	ds,
	input				            		reset,
	output				          		ready
	
);
	
	reg 	[KEYSIZE-1 : 0]	modreg;
	reg 	[KEYSIZE-1 : 0]	root;
	wire 	[KEYSIZE-1 : 0]	square;
	reg 	[KEYSIZE-1 : 0]	sqrin;
	reg 	[KEYSIZE-1 : 0]	tempin;
	wire 	[KEYSIZE-1 : 0]	tempout;	
	reg 	[KEYSIZE-1 : 0]	count;
	
	wire multrdy, sqrrdy, bothrdy;
	reg multgo, sqrgo;
	reg done;
	
	assign	ready 	= done;
	assign	bothrdy = multrdy && sqrrdy;
	
	v_ARS_modmult
	#(
		.MPWID(	KEYSIZE	)
	)
	modmultiply
	(
		.mpand		(tempin	),	// input [MPWID-1:0] mpand
		.mplier		(sqrin	),	// input [MPWID-1:0] mplier
		.modulus	(modreg	),	// input [MPWID-1:0] modulus
		.product	(tempout),	// output [MPWID-1:0] product
		.clk		  (clk	  ),	// input  clk
		.ds			  (multgo	),	// input  ds
		.reset		(reset	),	// input  reset
		.ready		(multrdy) 	// output  ready
	);
	
	v_ARS_modmult
	#(
		.MPWID(	KEYSIZE	)
	)
	modsqr
	(
		.mpand		(root 	),	// input [MPWID-1:0] mpand
		.mplier		(root 	),	// input [MPWID-1:0] mplier
		.modulus	(modreg	),	// input [MPWID-1:0] modulus
		.product	(square	),	// output [MPWID-1:0] product
		.clk		  (clk	  ),	// input  clk
		.ds			  (multgo	),	// input  ds
		.reset		(reset	),	// input  reset
		.ready		(sqrrdy	) 	// output  ready
	);
	
	//counter manager process tracks counter and enable flags
	// handles DONE and COUNT signals
	always@(posedge clk or posedge reset)
	begin
		if(reset == 1'b1)
		begin
			count <= 'b0;
			done  <= 'b0;
		end
		else if(done == 1'b1 && ds == 1'b1)
		begin
			//first time through
			count	<=	{1'b0,inExp[KEYSIZE-1:1]};
			done	<=	'b0;
			//after first time
		end
		else if(count == 0)
		begin
			if(bothrdy == 1'b1 &&  multgo == 1'b0)
			begin
				cypher 	<= 	tempout;	// set output value
				done	<=	1'b1;
			end
		end
		else if(bothrdy == 1'b1)
		begin
			if(multgo == 1'b0)
			begin
				count <= {1'b0, count[KEYSIZE-1:1]};
			end
		end
	end
	
	// This process sets the input values for the squaring multitplier
	always@(posedge clk or posedge reset)
	begin
		if(reset == 1'b1 )
		begin
			root   <= 'b0;
			modreg <= 'b0;
		end
		else if(done == 1'b1 && ds == 1'b1)
		begin
			// first time through, input is sampled only once
			modreg 	<= 	inMod;
			root 	<= 	indata;
			//after first time, square result is fed back to multiplier
		end
		else
		begin
			modreg <= modreg;
			root   <= square;
		end
	end
	
	// this process enables the multipliers when it is safe to do so
	always@(posedge clk or posedge reset)
	begin
		if(reset == 1'b1 )
			multgo <= 1'b0;
		else if(done == 1'b1 && ds == 1'b1)
			// first time through - automatically trigger first multiplier cycle
			multgo <= 1'b1;
			// after first time, trigger multipliers when both operations are complete
		else if(count != 0 && bothrdy == 1'b1)
			multgo <= 1'b1;
			// when multipliers have been started, disable multiplier inputs
		else if(multgo == 1'b1)
			multgo <= 1'b0;
	end
	
	// This process sets input values for the product multiplier
	always@(posedge clk or posedge reset)
	begin
		if(reset == 1'b1)
		begin
			tempin <= 'b0;
			sqrin  <= 'b0;
		end
		else if(done == 1'b1 && ds == 1'b1)
		begin
			// first time through, input is sampled only once
			// if the least significant bit of the exponent is '1' then we seed the
			// multiplier with the message value. Otherwise, we seed it with 1.
			// The square is set to 1, so the result of the first multiplication will be
			// either 1 or the initial message value
			sqrin <= {{(KEYSIZE-1){1'b0}}, 1'b1};		
			if( inExp[0] == 1'b1 ) 
				tempin <= indata;
			else
				tempin 	<= {{ (KEYSIZE-1){1'b0} },1'b1};
		end
		else
		begin
			// after first time, the multiplication and square results are fed back through the multiplier.
			// The counter (exponent) has been shifted one bit to the right
			// If the least significant bit of the exponent is '1' the result of the most recent
			// squaring operation is fed to the multiplier.
			// Otherwise, the square value is set to 1 to indicate no multiplication.
			tempin <= tempout;
			if(count[0] == 1'b1)
				sqrin <= square;
			else
				sqrin <= {{(KEYSIZE-1){1'b0}}, 1'b1};
		end
	end
	
endmodule 
