class rsa_monitor extends uvm_monitor;
	
		virtual rsa_intf intf;
		
		uvm_analysis_port #(data_t) mon_port;

		`uvm_component_utils(rsa_monitor)

		function new(string name = "rsa_monitor", uvm_component parent);
			super.new(name, parent);
			mon_port = new("mon_port", this);
		endfunction

		function void set_interface(virtual rsa_intf intf);
			if(intf == null)
				`uvm_error("GETVIF", "interface handle is NULL, please check if target interface has been intantiated")
			else
			this.intf = intf;
		endfunction

		task run_phase(uvm_phase phase);
			this.mon_trans();
		endtask

		task mon_trans();
			data_t m;
			bit [40:0] time_cnt;
			forever
			begin
				@(posedge intf.clk iff (intf.ds == 1));
				time_cnt = 0;
				wait(!intf.ready)
				forever
				begin
					time_cnt = time_cnt + 1;
					@(posedge intf.clk);
					if(intf.ready == 1) break;
				end
				@(negedge intf.clk);
				m.indata = intf.mon_ck.indata;
				m.inExp = intf.mon_ck.inExp;
				m.inMod = intf.mon_ck.inMod;
				m.cypher = intf.mon_ck.cypher;
				m.time_cnt = time_cnt;
				mon_port.write(m);
				`uvm_info(get_type_name(), "sent data_t to scoreboard", UVM_HIGH)
			end
		endtask
	endclass: rsa_monitor

