class top_reg_block extends uvm_reg_block;
        `uvm_object_utils(top_reg_block)

        rand INTR intr;
        rand CTRL ctrl;
        rand IO_ADDR io_addr;
        rand MEM_ADDR mem_addr;
        rand EXTRA_INFO extra_info;
        rand STATUS status;
        rand TRANSFER_COUNT transfer_count;
        rand DESCRIPTOR_ADDR descriptor_addr;
        rand ERROR_STATUS error_status;
        rand CONFIG configg;

        function new(string name = "top_reg_block");
                super.new(name,UVM_CVR_FIELD_VALS);
        endfunction

        function void build();
          
          	//add_hdl_path ("dut", "RTL");

                uvm_reg::include_coverage("*",UVM_CVR_FIELD_VALS);

                intr = INTR::type_id::create("intr");
                intr.build();
                intr.configure(this);
                intr.set_coverage(UVM_CVR_FIELD_VALS);

                ctrl = CTRL::type_id::create("ctrl");
                ctrl.build();
                ctrl.configure(this);
                ctrl.set_coverage(UVM_CVR_FIELD_VALS);

                io_addr = IO_ADDR::type_id::create("io_addr");
                io_addr.build();
                io_addr.configure(this);
                io_addr.set_coverage(UVM_CVR_FIELD_VALS);

                mem_addr = MEM_ADDR::type_id::create("mem_addr");
                mem_addr.build();
                mem_addr.configure(this);
                mem_addr.set_coverage(UVM_CVR_FIELD_VALS);

                extra_info = EXTRA_INFO::type_id::create("extra_info");
                extra_info.build();
                extra_info.configure(this);
                extra_info.set_coverage(UVM_CVR_FIELD_VALS);

                status = STATUS::type_id::create("status");
                status.build();
                status.configure(this);
                status.set_coverage(UVM_CVR_FIELD_VALS);

                transfer_count = TRANSFER_COUNT::type_id::create("transfer_count");
                transfer_count.build();
                transfer_count.configure(this);
                transfer_count.set_coverage(UVM_CVR_FIELD_VALS);

                descriptor_addr = DESCRIPTOR_ADDR::type_id::create("descriptor_addr");
                descriptor_addr.build();
                descriptor_addr.configure(this);
                descriptor_addr.set_coverage(UVM_CVR_FIELD_VALS);

                error_status = ERROR_STATUS::type_id::create("error_status");
                error_status.build();
                error_status.configure(this);
                error_status.set_coverage(UVM_CVR_FIELD_VALS);

                configg = CONFIG::type_id::create("configg");
                configg.build();
                configg.configure(this);
                configg.set_coverage(UVM_CVR_FIELD_VALS);
          	


		io_addr.add_hdl_path_slice("io_addr",0, 32);
        
	        default_map = create_map("default_map",'h0,4,UVM_LITTLE_ENDIAN);

                default_map.add_reg(intr,32'h400,"RW");
                default_map.add_reg(ctrl,32'h404,"RW");
                default_map.add_reg(io_addr,32'h408,"RW");
                default_map.add_reg(mem_addr,32'h40c,"RW");
                default_map.add_reg(extra_info,32'h410,"RW");
                default_map.add_reg(status,32'h414,"RO");
                default_map.add_reg(transfer_count,32'h418,"RO");
                default_map.add_reg(descriptor_addr,32'h41c,"RW");
                default_map.add_reg(error_status,32'h420,"RW");
                default_map.add_reg(configg,32'h424,"RW");


                lock_model();
        endfunction
endclass

