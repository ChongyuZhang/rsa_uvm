class access_sequence extends rsa_virtual_sequence;
	
		`uvm_object_utils(access_sequence)
		
		function new (string name = "access_sequence");
			super.new(name);
		endfunction
		
		task do_data();
			@(negedge p_sequencer.vif.reset);			
			this.wait_cycles(10);
			`uvm_do_on_with(seq, p_sequencer.rsa_sqr,{len == 2048; number == 1; foreach(inExp[i]) inExp[i] == 'h10001; data_idles == 'd10;})
			`uvm_do_on_with(seq, p_sequencer.rsa_sqr,{len == 1024; number == 1; foreach(inExp[i]) inExp[i] == 'h10001; data_idles == 'd10;})
			#1us;
		endtask

	endclass: access_sequence
