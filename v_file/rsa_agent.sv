class rsa_agent extends uvm_agent;
	
		rsa_driver driver;
		rsa_monitor monitor;
		rsa_sequencer sequencer;
		
		virtual rsa_intf vif;

		`uvm_component_utils(rsa_agent)

		function new(string name = "rsa_agent", uvm_component parent);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			// get virtual interface
			if(!uvm_config_db#(virtual rsa_intf)::get(this,"","vif", vif))
			begin
				`uvm_fatal("GETVIF","cannot get vif handle from config DB")
			end
			driver = rsa_driver::type_id::create("driver", this);
			monitor = rsa_monitor::type_id::create("monitor", this);
			sequencer = rsa_sequencer::type_id::create("sequencer", this);
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			driver.seq_item_port.connect(sequencer.seq_item_export);
			driver.set_interface(vif);
			monitor.set_interface(vif);
		endfunction
		
	endclass: rsa_agent

