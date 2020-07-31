class rsa_sequencer extends uvm_sequencer #(rsa_trans);
		`uvm_component_utils(rsa_sequencer)
		
		function new (string name = "rsa_sequencer", uvm_component parent);
			super.new(name, parent);
		endfunction
	endclass: rsa_sequencer
