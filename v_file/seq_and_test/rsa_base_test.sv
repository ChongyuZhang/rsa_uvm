class rsa_base_test extends uvm_test;
  
		rsa_env env;
		
		`uvm_component_utils(rsa_base_test)

		function new(string name = "rsa_base_test", uvm_component parent);
			super.new(name, parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			env = rsa_env::type_id::create("env", this);
		endfunction

		function void end_of_elaboration_phase(uvm_phase phase);
			super.end_of_elaboration_phase(phase);
			uvm_root::get().set_report_verbosity_level_hier(UVM_HIGH);
			uvm_root::get().set_report_max_quit_count(1);
			uvm_root::get().set_timeout(1s);
		endfunction

		task run_phase(uvm_phase phase);
			phase.raise_objection(this);
			this.run_top_virtual_sequence();
			phase.drop_objection(this);
		endtask

		virtual task run_top_virtual_sequence();
		endtask
endclass: rsa_base_test

