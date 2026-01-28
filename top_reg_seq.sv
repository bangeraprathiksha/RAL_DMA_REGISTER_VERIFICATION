`include "defines.sv"
class top_reg_seq extends uvm_sequence;
        `uvm_object_utils(top_reg_seq)

        top_reg_block regmodel;

        function new(string name = "top_reg_seq");
                super.new(name);
        endfunction

        task body();
                // Base sequence does nothing
                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(), "Base RAL sequence started (no register access)", UVM_LOW)
        endtask

        // Common helper methods
        task do_write(uvm_reg r, uvm_reg_data_t data);
                uvm_status_e status;
                r.write(.status(status), .value(data), .parent(this));
                if (status != UVM_IS_OK)
                        `uvm_error("RAL", "Write failed")
        endtask

        task do_read(uvm_reg r, output uvm_reg_data_t data);
                uvm_status_e status;
                r.read(.status(status), .value(data), .parent(this));
                if (status != UVM_IS_OK)
                        `uvm_error("RAL", "Read failed")
        endtask

endclass



//reset_check_seq
class reset_check_seq extends top_reg_seq;
        `uvm_object_utils(reset_check_seq)

        function new(string name = "reset_check_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t data;
                uvm_reg_data_t read_data;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(), "\n\n----------------------RESET CHECK START ---------------------------------------\n\n",UVM_LOW)

                // INTR
                data = regmodel.intr.get_reset();
                do_write(regmodel.intr, data);
                do_read(regmodel.intr, read_data);
                //regmodel.intr.reset();

                if (read_data !== data)
                        `uvm_error("RESET_CHECK", $sformatf("INTR reset failed: wrote 0x%0h, read 0x%0h", data, read_data));

                // CTRL
                data = regmodel.ctrl.get_reset();
                do_write(regmodel.ctrl, data);
                do_read(regmodel.ctrl, read_data);
                if (read_data !== data)
                        `uvm_error("RESET_CHECK", $sformatf("CTRL reset failed: wrote 0x%0h, read 0x%0h", data, read_data));

                // IO_ADDR
                data = regmodel.io_addr.get_reset();
                do_write(regmodel.io_addr, data);
                do_read(regmodel.io_addr, read_data);
                if (read_data !== data)
                        `uvm_error("RESET_CHECK", $sformatf("IO_ADDR reset failed: wrote 0x%0h, read 0x%0h", data, read_data));

                // MEM_ADDR
                data = regmodel.mem_addr.get_reset();
                do_write(regmodel.mem_addr, data);
                do_read(regmodel.mem_addr, read_data);
                if (read_data !== data)
                        `uvm_error("RESET_CHECK", $sformatf("MEM_ADDR reset failed: wrote 0x%0h, read 0x%0h", data, read_data));

                // EXTRA_INFO
                data = regmodel.extra_info.get_reset();
                do_write(regmodel.extra_info, data);
                do_read(regmodel.extra_info, read_data);
                if (read_data !== data)
                        `uvm_error("RESET_CHECK", $sformatf("EXTRA_INFO reset failed: wrote 0x%0h, read 0x%0h", data, read_data));

                // STATUS (RO) no write; just read
                do_read(regmodel.status, read_data);
                data = regmodel.status.get_reset();
                if (read_data !== data)
                        `uvm_error("RESET_CHECK", $sformatf("STATUS reset incorrect: expected 0x%0h, read 0x%0h", data, read_data));

                // TRANSFER_COUNT (RO)  same as above
                do_read(regmodel.transfer_count, read_data);
                data = regmodel.transfer_count.get_reset();
                if (read_data !== data)
                        `uvm_error("RESET_CHECK", $sformatf("TRANSFER_COUNT reset incorrect: expected 0x%0h, read 0x%0h", data, read_data));

                // DESCRIPTOR_ADDR
                data = regmodel.descriptor_addr.get_reset();
                do_write(regmodel.descriptor_addr, data);
                do_read(regmodel.descriptor_addr, read_data);
                if (read_data !== data)
                    `uvm_error("RESET_CHECK", $sformatf("DESCRIPTOR_ADDR reset failed: wrote 0x%0h, read 0x%0h", data, read_data));

                // ERROR_STATUS (RW1C/RO)
                data = regmodel.error_status.get_reset();
                do_write(regmodel.error_status, data);
                do_read(regmodel.error_status, read_data);
                if (read_data !== data)
                    `uvm_error("RESET_CHECK", $sformatf("ERROR_STATUS reset failed: wrote 0x%0h, read 0x%0h", data, read_data));

                // CONFIG
                data = regmodel.configg.get_reset();
                do_write(regmodel.configg, data);
                do_read(regmodel.configg, read_data);
                if (read_data !== data)
                    `uvm_error("RESET_CHECK", $sformatf("CONFIG reset failed: wrote 0x%0h, read 0x%0h", data, read_data));

                `uvm_info(get_type_name(), "\n\n----------------------RESET CHECK ENDED ---------------------------------------\n\n",UVM_LOW)

    endtask
endclass



//intr_seq
class intr_seq extends top_reg_seq;
        `uvm_object_utils(intr_seq)

        function new(string name = "intr_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ INTR REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // intr_status [15:0] = RO
                // intr_mask   [31:16] = RW
                // --------------------------------------------------
                wdata = $urandom_range(0,32'hFFFF_FFFF);

                do_write(regmodel.intr, wdata);
                des = regmodel.intr.get();
                mir = regmodel.intr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.intr, rdata);
                des = regmodel.intr.get();
                mir = regmodel.intr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ INTR REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass



//intr_seq
class ctrl_seq extends top_reg_seq;
        `uvm_object_utils(ctrl_seq)

        function new(string name = "ctrl_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;
                uvm_status_e status;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ CTRL REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // start_dma    [0]     = RW
                // w_count      [15:1]  = RW
                // io_mem       [16]    = RW
                // Reserved     [31:17] = RW
                // --------------------------------------------------
                  
             repeat(`no_of_trans)begin
                  
                wdata = $urandom_range(0,32'hFFFF_FFFF);

                do_write(regmodel.mem_addr, wdata);
             
                des = regmodel.mem_addr.get();
                mir = regmodel.mem_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.mem_addr, rdata);
                des = regmodel.mem_addr.get();
                mir = regmodel.mem_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))
                  `uvm_info(get_type_name(), "\n______________________________________________________________________\n", UVM_LOW)
                  
             end
                
                  `uvm_info(get_type_name(), "\n FRONTDOOR WRITE AND BACKDOOR READ \n", UVM_LOW)
                  
                wdata = 32'hFFFF_ABCD;
               regmodel.io_addr.write(status, wdata,UVM_FRONTDOOR);
          		regmodel.io_addr.predict(wdata);
                des = regmodel.io_addr.get();
                mir = regmodel.io_addr.get_mirrored_value();
                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)
          		#15;
		
               regmodel.io_addr.read(status, rdata, UVM_BACKDOOR);
                des = regmodel.io_addr.get();
                mir = regmodel.io_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)    
          

                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ CTRL REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass


//io_addr_seq
class io_addr_seq extends top_reg_seq;
        `uvm_object_utils(io_addr_seq)

        function new(string name = "io_addr_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;
                uvm_status_e status;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ IO_ADDR REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // io_addr   [31:0] = RW
                // --------------------------------------------------

                  
             repeat(`no_of_trans)begin
                  
                wdata = $urandom_range(0,32'hFFFF_FFFF);

                do_write(regmodel.mem_addr, wdata);
             
                des = regmodel.mem_addr.get();
                mir = regmodel.mem_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.mem_addr, rdata);
                des = regmodel.mem_addr.get();
                mir = regmodel.mem_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))
                  `uvm_info(get_type_name(), "\n______________________________________________________________________\n", UVM_LOW)
                  
             end
                
                  `uvm_info(get_type_name(), "\n BACKDOOR WRITE AND FRONT DOOR READ \n", UVM_LOW)
                  
                wdata = 32'hFFFF_0000;
          		regmodel.io_addr.write(status, wdata,UVM_BACKDOOR);
          		regmodel.io_addr.predict(wdata);
                des = regmodel.io_addr.get();
                mir = regmodel.io_addr.get_mirrored_value();
                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)
          
		
				regmodel.io_addr.read(status, rdata, UVM_FRONTDOOR);
                des = regmodel.io_addr.get();
                mir = regmodel.io_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)    
          

                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ IO_ADDR REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass



//mem_addr
class mem_addr_seq extends top_reg_seq;
        `uvm_object_utils(mem_addr_seq)

        function new(string name = "mem_addr_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ MEM_ADDR REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // mem_addr   [31:0] = RW
                // --------------------------------------------------
                  
             repeat(`no_of_trans)begin
                  
                wdata = $urandom_range(0,32'hFFFF_FFFF);

                do_write(regmodel.mem_addr, wdata);
             
                des = regmodel.mem_addr.get();
                mir = regmodel.mem_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.mem_addr, rdata);
                des = regmodel.mem_addr.get();
                mir = regmodel.mem_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))
                  `uvm_info(get_type_name(), "\n______________________________________________________________________\n", UVM_LOW)
                  

            end
        `uvm_info(get_type_name(), "\n\n================ MEM_ADDR REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass

//extra_info
class extra_info_seq extends top_reg_seq;
        `uvm_object_utils(extra_info_seq)

        function new(string name = "extra_info_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ EXTRA_INFO REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // extra_info   [31:0] = RW
                // --------------------------------------------------
                wdata = $urandom_range(0,32'hFFFF_FFFF);

                do_write(regmodel.extra_info, wdata);
                des = regmodel.extra_info.get();
                mir = regmodel.extra_info.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.extra_info, rdata);
                des = regmodel.extra_info.get();
                mir = regmodel.extra_info.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ EXTRA_INFO REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass


//status
class status_seq extends top_reg_seq;
        `uvm_object_utils(status_seq)

        function new(string name = "status_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ STATUS REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // busy         [0]     = RO
                // done         [1]     = RO
                // error        [2]     = R0
                // paused       [3]     = RO
                // current_state[7:4]   = RO
                // fifo_leve    [15:8]  = RO
                // Reserved     [31:16] = RO
                // --------------------------------------------------

                wdata = $urandom_range(0,32'hFFFF_FFFF);
                do_write(regmodel.status, wdata);
                des = regmodel.status.get();
                mir = regmodel.status.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.status, rdata);
                des = regmodel.status.get();
                mir = regmodel.status.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ STATUS REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass


//transfer_count
class transfer_count_seq extends top_reg_seq;
        `uvm_object_utils(transfer_count_seq)

        function new(string name = "transfer_count_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ TRANSFER_COUNT REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // transfer_count   [31:0] = RO
                // --------------------------------------------------
                wdata = $urandom_range(0,32'hFFFF_FFFF);

                do_write(regmodel.transfer_count, wdata);
                des = regmodel.transfer_count.get();
                mir = regmodel.transfer_count.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.transfer_count, rdata);
                des = regmodel.transfer_count.get();
                mir = regmodel.transfer_count.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ TRANSFER_COUNT REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass



// descriptor_addr
class descriptor_addr_seq extends top_reg_seq;
        `uvm_object_utils(descriptor_addr_seq)

        function new(string name = "descriptor_addr_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ DESCRIPTOR_ADDR REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // descriptor_addr   [31:0] = RW
                // --------------------------------------------------
                wdata = $urandom_range(0,32'hFFFF_FFFF);

                do_write(regmodel.descriptor_addr, wdata);
                des = regmodel.descriptor_addr.get();
                mir = regmodel.descriptor_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.descriptor_addr, rdata);
                des = regmodel.descriptor_addr.get();
                mir = regmodel.descriptor_addr.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ DESCRIPTOR_ADDR REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass



//error_status
class error_status_seq extends top_reg_seq;
        `uvm_object_utils(error_status_seq)

        function new(string name = "error_status_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ ERROR_STATUS REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // bus_error            [0]     = RW1C
                // timeout_error        [1]     = RW1C
                // alignment_error      [2]     = RW1C
                // overflow_error       [3]     = RW1C
                // underflow_error      [4]     = RW1C
                // Reserved             [7:5]   = RO
                // error_code           [15:8]  = RO
                //error_addr_offset     [31:16] = RO
                // --------------------------------------------------

                wdata = $urandom_range(0,32'hFFFF_FFFF);
                do_write(regmodel.error_status, wdata);
                des = regmodel.error_status.get();
                mir = regmodel.error_status.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.error_status, rdata);
                des = regmodel.error_status.get();
                mir = regmodel.error_status.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ ERROR_STATUS REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass



//config
class config_seq extends top_reg_seq;
        `uvm_object_utils(config_seq)

        function new(string name = "config_seq");
                super.new(name);
        endfunction

        task body();
                uvm_reg_data_t rdata,wdata,des,mir;

                if (regmodel == null)
                        `uvm_fatal("NO_REGMODEL", "regmodel not assigned")

                `uvm_info(get_type_name(),"\n\n================ CONFIG REGISTER CHECK START ================\n\n",UVM_LOW)

                // --------------------------------------------------
                // priorityy            [1:0]   = RW
                // auto_restart         [2]     = RW
                // interrupt_enable     [3]     = RW
                // burst_size           [5:4]   = RW
                // data_width           [7:6]   = RW
                // descriptor_mode      [8]     = RW
                // Reserved             [31:9]  = RO
                // --------------------------------------------------

                wdata = $urandom_range(0,32'hFFFF_FFFF);
                do_write(regmodel.configg, wdata);
                des = regmodel.configg.get();
                mir = regmodel.configg.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("WRITE | WDATA=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h", wdata, des,mir),UVM_LOW)

                do_read(regmodel.configg, rdata);
                des = regmodel.configg.get();
                mir = regmodel.configg.get_mirrored_value();

                `uvm_info(get_type_name(),$sformatf("READ  | DUT=0x%08h DESIRED=0x%08h,  MIRRORED=0x%08h",rdata,des, mir),UVM_LOW)


                // Mirrored must match desired after read
                if (mir !== des)
                        `uvm_error(get_type_name(),$sformatf("Mirror mismatch: des=0x%08h mir=0x%08h",des, mir))

        `uvm_info(get_type_name(), "\n\n================ CONFIG REGISTER CHECK END =================\n\n", UVM_LOW)
    endtask
endclass
                  

//REGRESSION
class regression_seq extends top_reg_seq;

        `uvm_object_utils(regression_seq)

        reset_check_seq rst_seq;
        intr_seq intr_seq;
        ctrl_seq ctrl_seq;
        io_addr_seq io_addr_seq;
        mem_addr_seq mem_addr_seq;
        extra_info_seq extra_info_seq;
        status_seq status_seq;
        transfer_count_seq transfer_count_seq;
        descriptor_addr_seq descriptor_addr_seq;
        error_status_seq error_status_seq;
        config_seq config_seq;

        function new(string name = "regression_seq");
                super.new(name);
        endfunction

        virtual task body();

                `uvm_info(get_type_name(), "\n\n================ regression start =================\n\n", UVM_LOW)

                //  reset check for all registers
                `uvm_create(rst_seq)
                rst_seq.regmodel = this.regmodel;
                `uvm_send(rst_seq)

               // individual register tests
                `uvm_create(intr_seq)
                intr_seq.regmodel = this.regmodel;
                `uvm_send(intr_seq)

                `uvm_create(ctrl_seq)
                ctrl_seq.regmodel = this.regmodel;
                `uvm_send(ctrl_seq)

                `uvm_create(io_addr_seq)
                io_addr_seq.regmodel = this.regmodel;
                `uvm_send(io_addr_seq)

                `uvm_create(mem_addr_seq)
                mem_addr_seq.regmodel = this.regmodel;
                `uvm_send(mem_addr_seq)

                `uvm_create(extra_info_seq)
                extra_info_seq.regmodel = this.regmodel;
                `uvm_send(extra_info_seq)

                `uvm_create(status_seq)
                status_seq.regmodel = this.regmodel;
                `uvm_send(status_seq)

                `uvm_create(transfer_count_seq)
                transfer_count_seq.regmodel = this.regmodel;
                `uvm_send(transfer_count_seq)

                `uvm_create(descriptor_addr_seq)
                descriptor_addr_seq.regmodel = this.regmodel;
                `uvm_send(descriptor_addr_seq)

                `uvm_create(error_status_seq)
                error_status_seq.regmodel = this.regmodel;
                `uvm_send(error_status_seq)

                `uvm_create(config_seq)
                config_seq.regmodel = this.regmodel;
                `uvm_send(config_seq)

        endtask
endclass
                  
