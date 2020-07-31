class rsa_env extends uvm_env;
		rsa_agent agt;
		rsa_scoreboard sbd;
		rsa_virtual_sequencer virt_sqr;

		`uvm_component_utils(rsa_env)

		function new (string name = "rsa_env", uvm_component parent);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			this.agt = rsa_agent::type_id::create("agt", this);
			this.sbd = rsa_scoreboard::type_id::create("sbd", this);
			this.virt_sqr = rsa_virtual_sequencer::type_id::create("virt_sqr", this);		
		endfunction

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			this.agt.monitor.mon_port.connect(this.sbd.rsa_fifo.analysis_export);
			this.virt_sqr.rsa_sqr = this.agt.sequencer;
		endfunction
	endclass: rsa_env

