class access_test extends rsa_base_test;
	  
		`uvm_component_utils(access_test)
		
		function new(string name = "access_test", uvm_component parent);
			super.new(name, parent);
		endfunction
		
		task run_top_virtual_sequence();
			access_sequence seq = new();
			seq.start(env.virt_sqr);
		endtask
	endclass: access_test

