class rsa_scoreboard extends uvm_scoreboard;
		//counter
		int cmp_count;
		int error_count;
		
		uvm_tlm_analysis_fifo #(data_t) rsa_fifo;
		
		`uvm_component_utils(rsa_scoreboard)

		function new (string name = "rsa_scoreboard", uvm_component parent);
			super.new(name, parent);
			rsa_fifo = new("rsa_fifo", this);
			this.cmp_count = 0;
			this.error_count = 0;
		endfunction

		task run_phase(uvm_phase phase);
			this.data_compare();
		endtask

		task data_compare();
			data_t t;
			forever
			begin
				rsa_fifo.get(t);
				`uvm_info(get_type_name(), $sformatf("get indata %0h", t.indata), UVM_HIGH)
				`uvm_info(get_type_name(), $sformatf("get inExp %0h", t.inExp), UVM_HIGH)
				`uvm_info(get_type_name(), $sformatf("get inMod %0h", t.inMod), UVM_HIGH)
        t.ref_cypher = ref_rsa(t.indata, t.inExp, t.inMod);
				if(t.cypher !== t.ref_cypher )
        begin
					`uvm_error("SV_REF COMP ERRPR!", $sformatf("%0h !== %0h", t.cypher, t.ref_cypher))
          this.error_count++;
        end
				else
				begin
					`uvm_info("SV_REF COMP SUCCEED!", $sformatf("%0h === %0h", t.cypher, t.ref_cypher), UVM_LOW)
					`uvm_info("TIME CNT", $sformatf("time count : %0d", t.time_cnt), UVM_LOW)
				end
        this.cmp_count++;
			end
		endtask
		
		function bit [2047:0] ref_rsa(bit [2047:0] data, bit [2047:0] exp, bit [2047:0] mod);
			bit [4095:0] temp = 0;
			bit [2047:0] cypher = 1;
			while(exp > 0)
			begin
				if(exp[0] == 0)
				begin
					temp = data * data;
					data = temp % mod;
					exp = exp >> 1;
				end
				else
				begin
					temp = cypher * data;
					cypher = temp % mod;
					exp = exp - 1'b1;
				end
			end
			return cypher;
		endfunction
	endclass: rsa_scoreboard

