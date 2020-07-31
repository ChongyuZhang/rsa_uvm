class rsa_encrypt_2048b_sequence extends rsa_virtual_sequence;
	
		`uvm_object_utils(rsa_encrypt_2048b_sequence)
		
		function new (string name = "rsa_encrypt_2048b_sequence");
			super.new(name);
		endfunction
		
		task do_data();
			@(negedge p_sequencer.vif.reset);			
			this.wait_cycles(10);
			`uvm_do_on_with(seq, p_sequencer.rsa_sqr,{len == 2048; number == 10; foreach(inExp[i]) inExp[i] == 'h10001; data_idles == 'd10;})
			#1us;
		endtask

	endclass: rsa_encrypt_2048b_sequence
