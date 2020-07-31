class rsa_trans extends uvm_sequence_item;
    rand int          len;          //length of rsa
		rand bit [2047:0]	indata [];		//indata
		rand bit [2047:0]	inExp	[];		  //inExp
		rand bit [2047:0]	inMod	[];		  //inMod
		rand int			    data_idles;		//data_idles	
		bit		   [2047:0]	cypher;			  //cypher
		bit 				      rsp;			    //response to sequencer
		
		`uvm_object_utils_begin(rsa_trans)
			`uvm_field_int(len, UVM_ALL_ON)
			`uvm_field_array_int(indata, UVM_ALL_ON)
			`uvm_field_array_int(inExp, UVM_ALL_ON)
			`uvm_field_array_int(inMod, UVM_ALL_ON)
			`uvm_field_int(data_idles, UVM_ALL_ON)
			`uvm_field_int(cypher, UVM_ALL_ON)
			`uvm_field_int(rsp, UVM_ALL_ON)
		`uvm_object_utils_end
		
		constraint cstr
		{
			soft data_idles == 0;
			soft indata.size inside {[1:100]};
			inExp.size == indata.size;
			inMod.size == indata.size;
			foreach(indata[i]) indata[i] < inMod[i];
		};
		
		function new (string name = "rsa_trans");
			super.new(name);
		endfunction
endclass: rsa_trans

