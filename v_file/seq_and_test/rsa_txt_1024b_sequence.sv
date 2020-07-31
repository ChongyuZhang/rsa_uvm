class rsa_txt_1024b_sequence extends rsa_virtual_sequence;
	
		`uvm_object_utils(rsa_txt_1024b_sequence)
		
		function new (string name = "rsa_txt_1024b_sequence");
			super.new(name);
		endfunction
		
		task do_data();
			@(negedge p_sequencer.vif.reset);			
			this.wait_cycles(10);
      $readmemh("/home/chongyu/project/rsa_uvm/v_file/txt/encrypt_1024b_indata.txt", encrypt_indata);
      $readmemh("/home/chongyu/project/rsa_uvm/v_file/txt/decrypt_1024b_indata.txt", decrypt_indata);
      $readmemh("/home/chongyu/project/rsa_uvm/v_file/txt/decrypt_1024b_inExp.txt", decrypt_inExp);
      $readmemh("/home/chongyu/project/rsa_uvm/v_file/txt/encrypt_1024b_inMod.txt", inMod);
      foreach(encrypt_indata[j])
      begin
     	`uvm_do_on_with(seq, p_sequencer.rsa_sqr,{number == 1; foreach(indata[i]) indata[i] == encrypt_indata[j]; foreach(inExp[i]) inExp[i] == 'h10001; foreach(inMod[i]) inMod[i] == local::inMod[j]; data_idles == 'd10;})
     	`uvm_do_on_with(seq, p_sequencer.rsa_sqr,{number == 1; foreach(indata[i]) indata[i] == decrypt_indata[j]; foreach(inExp[i]) inExp[i] == decrypt_inExp[j]; foreach(inMod[i]) inMod[i] == local::inMod[j]; data_idles == 'd10;})
      end
			#1us;
		endtask

endclass: rsa_txt_1024b_sequence
