class rsa_txt_1024b_test extends rsa_base_test;
	  
		`uvm_component_utils(rsa_txt_1024b_test)
		
		function new(string name = "rsa_txt_1024b_test", uvm_component parent);
			super.new(name, parent);
		endfunction
		
		task run_top_virtual_sequence();
		  rsa_txt_1024b_sequence seq = new();
			seq.start(env.virt_sqr);
		endtask
	endclass: rsa_txt_1024b_test

