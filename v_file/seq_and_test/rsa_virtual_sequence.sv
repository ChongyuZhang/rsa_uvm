class rsa_virtual_sequence extends uvm_sequence;
	
    bit [2047:0] encrypt_indata [30];
    bit [2047:0] decrypt_indata [30];
    bit [2047:0] decrypt_inExp [30];
    bit [2047:0] inMod [30];

    rsa_trans trans;
		rsa_base_sequence seq;
		
		`uvm_object_utils(rsa_virtual_sequence)
		`uvm_declare_p_sequencer(rsa_virtual_sequencer)

		function new (string name = "rsa_virtual_sequence");
			super.new(name);
		endfunction

		virtual task body();
			`uvm_info(get_type_name(), "=====================STARTED=====================", UVM_LOW)
			this.do_data();
			`uvm_info(get_type_name(), "=====================FINISHED=====================", UVM_LOW)
		endtask

		virtual task do_data();
		endtask

		task wait_cycles(int n);
			repeat(n) @(posedge p_sequencer.vif.clk);
		endtask
	endclass: rsa_virtual_sequence	
