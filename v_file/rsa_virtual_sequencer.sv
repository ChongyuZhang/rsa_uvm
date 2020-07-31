class rsa_virtual_sequencer extends uvm_sequencer;
		rsa_sequencer rsa_sqr;
		
		virtual rsa_intf vif;
		
		`uvm_component_utils(rsa_virtual_sequencer)
		
		function new (string name = "rsa_virtual_sequencer", uvm_component parent);
			super.new(name, parent);
		endfunction
		
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			if(!uvm_config_db#(virtual rsa_intf)::get(this,"","vif", vif))
			begin
				`uvm_fatal("GETVIF","cannot get vif handle from config DB")
			end
		endfunction
	endclass: rsa_virtual_sequencer

