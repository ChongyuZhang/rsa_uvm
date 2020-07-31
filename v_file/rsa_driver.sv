class rsa_driver extends uvm_driver #(rsa_trans);
		
		virtual rsa_intf intf;
		
		`uvm_component_utils(rsa_driver)

		function new (string name = "rsa_driver", uvm_component parent);
			super.new(name, parent);
		endfunction
	  
		function void set_interface(virtual rsa_intf intf);
		  if(intf == null)
			`uvm_error("GETVIF","interface handle is NULL, please check if target interface has been intantiated")
		  else
			this.intf = intf;
		endfunction

		task run_phase(uvm_phase phase);
			fork
				this.rsa_drive();
				this.rsa_reset();
			join
		endtask
		//reset
		task rsa_reset();
			forever 
			begin
				@(negedge intf.reset);
				intf.indata <= 0;
				intf.inExp <= 0;
				intf.inMod <= 0;
				intf.ds <= 0;
			end
		endtask

		task rsa_drive();
			rsa_trans req, rsp;
			@(negedge intf.reset);
			forever begin
				seq_item_port.get_next_item(req);
				this.do_driver(req);
				void'($cast(rsp, req.clone()));
				rsp.rsp = 1;
				rsp.set_sequence_id(req.get_sequence_id());
				seq_item_port.item_done(rsp);
			end
		endtask
		
		task do_driver(input rsa_trans t);
			foreach(t.indata[i])
			begin
				repeat(t.data_idles) data_idle();
				@(posedge intf.clk);
				intf.drv_ck.indata <= t.indata[i];
				intf.drv_ck.inExp <= t.inExp[i];
				intf.drv_ck.inMod <= t.inMod[i];
				intf.drv_ck.ds <= 1;
				@(posedge intf.clk);
				intf.drv_ck.ds <= 0;
				wait(intf.ready == 0)
				@(posedge intf.ready);
				t.cypher = intf.cypher;
			end
		endtask
		//IDLE
		task data_idle();
			@(posedge intf.clk);
			intf.indata <= 0;
			intf.inExp <= 0;
			intf.inMod <= 0;
			intf.ds <= 0;
		endtask
	endclass: rsa_driver

