	class rsa_base_sequence extends uvm_sequence #(rsa_trans);
	
    rand int          len;
		rand bit [2047:0] indata[];
		rand bit [2047:0] inExp [];
		rand bit [2047:0] inMod [];
		rand int          data_idles;
		rand int          number;

		constraint cstr
		{
      soft data_idles == 0;
      soft indata.size == number;
      soft number inside{[1:100]};
			inExp.size == indata.size;
			inMod.size == indata.size;
			foreach(indata[i]) indata[i] < inMod[i];
      len inside {2048, 1024};

      if(len == 2048)
        foreach(indata[i])
        {
          soft indata[i][2047] == 1;
          soft inExp[i][2047] == 1;
          soft inMod[i][2047] == 1;
          indata[i] < inMod[i];
        }
      if(len == 1024)
        foreach(indata[i])
        {
          soft indata[i][2047:1023] == 1;
          soft inExp[i][2047:1023] == 1;
          soft inMod[i][2047:1023] == 1;
          indata[i] < inMod[i];
        }
		};
		
		`uvm_object_utils_begin(rsa_base_sequence)
			`uvm_field_int(len, UVM_ALL_ON)
			`uvm_field_array_int(indata, UVM_ALL_ON)
			`uvm_field_array_int(inExp, UVM_ALL_ON)
			`uvm_field_array_int(inMod, UVM_ALL_ON)
			`uvm_field_int(data_idles, UVM_ALL_ON)
			`uvm_field_int(number, UVM_ALL_ON)
		`uvm_object_utils_end
		
		function new (string name = "rsa_base_sequence");
			super.new(name);
		endfunction

		task body();
      rsa_trans req, rsp;
			`uvm_do_with(req, {	local::len > 0 -> len == local::len;
                          foreach(local::indata[i]) local::indata[i] >= 0 -> indata[i] == local::indata[i]; 
								          foreach(local::inExp[i]) local::inExp[i] >= 0 -> inExp[i] == local::inExp[i];
								          foreach(local::inMod[i]) local::inMod[i] >= 0 -> inMod[i] == local::inMod[i];
								          local::number > 0 -> indata.size() == local::number;
							          	local::data_idles >= 0 -> data_idles == local::data_idles;
						            })
			get_response(rsp);
			assert(rsp.rsp)
				else $error("[RSPERR] %0t error response received!", $time);
		endtask

		function void post_randomize();
			string s;
			s = {s, "AFTER RANDOMIZATION \n"};
			s = {s, "=======================================\n"};
			s = {s, "rsa_sequence object content is as below: \n"};
			s = {s, super.sprint()};
			s = {s, "=======================================\n"};
			`uvm_info(get_type_name(), s, UVM_HIGH)
		endfunction
		
  endclass: rsa_base_sequence

