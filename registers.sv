
////////INTR REGISTER (0x400)
class INTR extends uvm_reg;
        `uvm_object_utils(INTR)

        uvm_reg_field intr_status;
        rand uvm_reg_field intr_mask;

        //adding coverpoints
        covergroup intr_cov;
                option.per_instance = 1;

                coverpoint intr_status.value{
                        bins lower = {[16'h0000:16'hAAAA]};
                        bins mid = {[16'hAAAB:16'hF000]};
                        bins high = {[16'hF001:16'hFFFF]};
                }
                coverpoint intr_mask.value{
                        bins lower = {[16'h0000:16'hAAAA]};
                        bins mid = {[16'hAAAB:16'hF000]};
                        bins high = {[16'hF001:16'hFFFF]};
                }

        endgroup

        function new(string name = "INTR");
                super.new(name, 32, UVM_CVR_ALL);
                intr_cov = new();
        endfunction

        function void build();

                intr_status = uvm_reg_field::type_id::create("intr_status");
                intr_mask   = uvm_reg_field::type_id::create("intr_mask");

                intr_status.configure(  .parent(this),
                                        .size(16),
                                        .lsb_pos(0),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(16'h0000),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));

                intr_mask.configure(    .parent(this),
                                        .size(16),
                                        .lsb_pos(16),
                                        .access("RW"),
                                        .volatile(0),
                                        .reset(16'h0000),
                                        .has_reset(1),
                                        .is_rand(1),
                                        .individually_accessible(1));
        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en,bit is_read, uvm_reg_map map);
                intr_cov.sample();
        endfunction

        virtual function void sample_values();
                super.sample_values();
                intr_cov.sample();
        endfunction

endclass


//////CTRL REGISTER (0x404)
class CTRL extends uvm_reg;
        `uvm_object_utils(CTRL)

        rand uvm_reg_field start_dma;
        rand uvm_reg_field w_count;
        rand uvm_reg_field io_mem;
        uvm_reg_field Reserved;

        covergroup ctrl_cov;
                option.per_instance = 1;

                coverpoint start_dma.value;
                coverpoint w_count.value {
                        bins lower = {[15'h0000:15'h2AAA]};
                        bins mid   = {[15'h2AAB:15'h5555]};
                        bins high  = {[15'h5556:15'h7FFF]};
                }
                coverpoint io_mem.value;
                coverpoint Reserved.value {
                        bins lower = {[17'h00000:17'h0AAAA]};
                        bins mid   = {[17'h0AAAB:17'h15555]};
                        bins high  = {[17'h15556:17'h1FFFF]};
                }


        endgroup

        function new(string name = "CTRL");
                super.new(name, 32, UVM_CVR_ALL);
                ctrl_cov = new();
        endfunction

        function void build();

                start_dma = uvm_reg_field::type_id::create("start_dma");
                w_count   = uvm_reg_field::type_id::create("w_count");
                io_mem    = uvm_reg_field::type_id::create("io_mem");
                Reserved  = uvm_reg_field::type_id::create("Reserved");

                start_dma.configure(    .parent(this),
                                        .size(1),
                                        .lsb_pos(0),
                                        .access("RW"),
                                        .volatile(0),
                                        .reset(0),
                                        .has_reset(1),
                                        .is_rand(1),
                                        .individually_accessible(1));

                w_count.configure(      .parent(this),
                                        .size(15),
                                        .lsb_pos(1),
                                        .access("RW"),
                                        .volatile(0),
                                        .reset(15'h0000),
                                        .has_reset(1),
                                        .is_rand(1),
                                        .individually_accessible(1));

                io_mem.configure(       .parent(this),
                                        .size(1),
                                        .lsb_pos(16),
                                        .access("RW"),
                                        .volatile(0),
                                        .reset(0),
                                        .has_reset(1),
                                        .is_rand(1),
                                        .individually_accessible(1));

                Reserved.configure(     .parent(this),
                                        .size(15),
                                        .lsb_pos(17),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(0),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));

        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en,bit is_read, uvm_reg_map map);
                ctrl_cov.sample();
        endfunction

        virtual function void sample_values();
                super.sample_values();
                ctrl_cov.sample();
        endfunction

endclass



//////IO_ADDR Register (0x408)
class IO_ADDR extends uvm_reg;
        `uvm_object_utils(IO_ADDR)

        rand uvm_reg_field io_addr;

        covergroup io_addr_cov;
                option.per_instance = 1;
                coverpoint io_addr.value {
                        bins lower = {[32'h00000000:32'h2AAAAAAA]};
                        bins mid   = {[32'h2AAAAAAB:32'h55555555]};
                        bins high  = {[32'h55555556:32'hFFFFFFFF]};
        }
        endgroup

        function new(string name = "IO_ADDR");
                super.new(name, 32, UVM_CVR_ALL);
                io_addr_cov = new();
        endfunction

        function void build();

                io_addr = uvm_reg_field::type_id::create("io_addr");

                io_addr.configure(      .parent(this),
                                        .size(32),
                                        .lsb_pos(0),
                                        .access("RW"),
                                        .volatile(0),
                                        .reset(32'h00000000),
                                        .has_reset(1),
                                        .is_rand(1),
                                        .individually_accessible(1));

        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
                io_addr_cov.sample();
        endfunction

        function void sample_values();
                super.sample_values();
                io_addr_cov.sample();
        endfunction

endclass


//////MEM_ADDR Register (0x40C)
class MEM_ADDR extends uvm_reg;
        `uvm_object_utils(MEM_ADDR)

        rand uvm_reg_field mem_addr;

        covergroup mem_addr_cov;
                option.per_instance = 1;
                coverpoint mem_addr.value {
                        bins lower = {[32'h00000000:32'h2AAAAAAA]};
                        bins mid   = {[32'h2AAAAAAB:32'h55555555]};
                        bins high  = {[32'h55555556:32'hFFFFFFFF]};
        }
        endgroup

        function new(string name = "MEM_ADDR");
                super.new(name, 32, UVM_CVR_ALL);
                mem_addr_cov = new();
        endfunction

        function void build();

                mem_addr = uvm_reg_field::type_id::create("mem_addr");

                mem_addr.configure(     .parent(this),
                                        .size(32),
                                        .lsb_pos(0),
                                        .access("RW"),
                                        .volatile(0),
                                        .reset(32'h00000000),
                                        .has_reset(1),
                                        .is_rand(1),
                                        .individually_accessible(1));

        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
                mem_addr_cov.sample();
        endfunction

        function void sample_values();
                super.sample_values();
                mem_addr_cov.sample();
        endfunction

endclass



////// EXTRA_INFO Register (0x410)
class EXTRA_INFO extends uvm_reg;
        `uvm_object_utils(EXTRA_INFO)

        rand uvm_reg_field extra_info;

        covergroup extra_info_cov;
                option.per_instance = 1;
                coverpoint extra_info.value {
                        bins lower = {[32'h00000000:32'h2AAAAAAA]};
                        bins mid   = {[32'h2AAAAAAB:32'h55555555]};
                        bins high  = {[32'h55555556:32'hFFFFFFFF]};
        }
        endgroup

        function new(string name = "EXTRA_INFO");
                super.new(name, 32, UVM_CVR_ALL);
                extra_info_cov = new();
        endfunction

        function void build();

                extra_info = uvm_reg_field::type_id::create("extra_info");

                extra_info.configure(   .parent(this),
                                        .size(32),
                                        .lsb_pos(0),
                                        .access("RW"),
                                        .volatile(0),
                                        .reset(32'h00000000),
                                        .has_reset(1),
                                        .is_rand(1),
                                        .individually_accessible(1));

        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
                extra_info_cov.sample();
        endfunction

        function void sample_values();
                super.sample_values();
                extra_info_cov.sample();
        endfunction

endclass


////// STATUS Register (0x414)
class STATUS extends uvm_reg;
        `uvm_object_utils(STATUS)

        uvm_reg_field busy;
        uvm_reg_field done;
        uvm_reg_field error;
        uvm_reg_field paused;
        uvm_reg_field current_state;
        uvm_reg_field fifo_level;
        uvm_reg_field Reserved;

        covergroup status_cov;
                option.per_instance = 1;

                coverpoint busy.value;
                coverpoint done.value;
                coverpoint error.value;
                coverpoint paused.value;

                coverpoint current_state.value{
                        bins lower = {[4'h0:4'h6]};
                        bins mid = {[4'h7:4'hA]};
                        bins high = {[4'hB:4'hF]};
                }
                coverpoint fifo_level.value{
                        bins lower = {[8'h00:8'h11]};
                        bins mid = {[8'h12:8'h13]};
                        bins high = {[8'h1F:8'hFF]};
                }

                coverpoint Reserved.value{
                        bins lower = {[16'h0000:16'hAAAA]};
                        bins mid = {[16'hAAAB:16'hF000]};
                        bins high = {[16'hF001:16'hFFFF]};
                }

        endgroup


        function new(string name = "STATUS");
                super.new(name, 32, UVM_CVR_ALL);
                status_cov = new();
        endfunction

        function void build();

                busy = uvm_reg_field::type_id::create("busy");
                done = uvm_reg_field::type_id::create("done");
                error = uvm_reg_field::type_id::create("error");
                paused = uvm_reg_field::type_id::create("paused");
                current_state = uvm_reg_field::type_id::create("current_state");
                fifo_level = uvm_reg_field::type_id::create("fifo_level");
                Reserved = uvm_reg_field::type_id::create("Reserved");

                busy.configure(         .parent(this),
                                        .size(1),
                                        .lsb_pos(0),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(0),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));
                done.configure(         .parent(this),
                                        .size(1),
                                        .lsb_pos(1),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(0),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));
                error.configure(        .parent(this),
                                        .size(1),
                                        .lsb_pos(2),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(0),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));
                paused.configure(       .parent(this),
                                        .size(1),
                                        .lsb_pos(3),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(0),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));
                current_state.configure(.parent(this),
                                        .size(4),
                                        .lsb_pos(4),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(4'h0),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));
                fifo_level.configure(   .parent(this),
                                        .size(8),
                                        .lsb_pos(8),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(8'h00),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));
                Reserved.configure(     .parent(this),
                                        .size(16),
                                        .lsb_pos(16),
                                        .access("RO"),
                                        .volatile(0),
                                        .reset(16'h0000),
                                        .has_reset(1),
                                        .is_rand(0),
                                        .individually_accessible(1));





        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
                status_cov.sample();
        endfunction

        function void sample_values();
                super.sample_values();
                status_cov.sample();
        endfunction
endclass



////// TRANSFER_COUNT Register (0x418)
class TRANSFER_COUNT extends uvm_reg;
        `uvm_object_utils(TRANSFER_COUNT)

        rand uvm_reg_field transfer_count;

        covergroup transfer_count_cov;
                option.per_instance = 1;
                coverpoint transfer_count.value {
                        bins lower = {[32'h00000000:32'h2AAAAAAA]};
                        bins mid   = {[32'h2AAAAAAB:32'h55555555]};
                        bins high  = {[32'h55555556:32'hFFFFFFFF]};
        }
        endgroup

        function new(string name = "TRANSFER_COUNT");
                super.new(name, 32, UVM_CVR_ALL);
                transfer_count_cov = new();
        endfunction

        function void build();

                transfer_count = uvm_reg_field::type_id::create("transfer_count");

                transfer_count.configure(       .parent(this),
                                                .size(32),
                                                .lsb_pos(0),
                                                .access("RO"),
                                                .volatile(0),
                                                .reset(32'h00000000),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));

        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
                transfer_count_cov.sample();
        endfunction

        function void sample_values();
                super.sample_values();
                transfer_count_cov.sample();
        endfunction

endclass


////// DESCRIPTOR_ADDR Register (0x41C)
class DESCRIPTOR_ADDR extends uvm_reg;
        `uvm_object_utils(DESCRIPTOR_ADDR)

        rand uvm_reg_field  descriptor_addr;

        covergroup descriptor_addr_cov;
                option.per_instance = 1;
                coverpoint descriptor_addr.value {
                        bins lower = {[32'h00000000:32'h2AAAAAAA]};
                        bins mid   = {[32'h2AAAAAAB:32'h55555555]};
                        bins high  = {[32'h55555556:32'hFFFFFFFF]};
        }
        endgroup


        function new(string name = "DESCRIPTOR_ADDR");
                super.new(name, 32, UVM_CVR_ALL);
                descriptor_addr_cov = new();
        endfunction

        function void build();

                 descriptor_addr = uvm_reg_field::type_id::create("descriptor_addr");

                 descriptor_addr.configure(     .parent(this),
                                                .size(32),
                                                .lsb_pos(0),
                                                .access("RW"),
                                                .volatile(0),
                                                .reset(32'h00000000),
                                                .has_reset(1),
                                                .is_rand(1),
                                                .individually_accessible(1));

        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
                descriptor_addr_cov.sample();
        endfunction

        function void sample_values();
                super.sample_values();
                descriptor_addr_cov.sample();
        endfunction

endclass



////// ERROR_STATUS Register (0x420)
class ERROR_STATUS extends uvm_reg;
        `uvm_object_utils(ERROR_STATUS)

        rand uvm_reg_field  bus_error;
        rand uvm_reg_field  timeout_error;
        rand uvm_reg_field  alignment_error;
        rand uvm_reg_field  overflow_error;
        rand uvm_reg_field  underflow_error;
         uvm_reg_field  Reserved;
        rand uvm_reg_field  error_code;
        rand uvm_reg_field  error_addr_offset;

        covergroup error_status_cov;
                option.per_instance = 1;
                coverpoint bus_error.value;
                coverpoint timeout_error.value;
                coverpoint overflow_error.value;
                coverpoint underflow_error.value;

                coverpoint Reserved.value{
                        bins lower = {[3'h0:3'h6]};
                        bins mid = {[3'h7:3'hA]};
                        bins high = {[3'hB:3'hF]};
                }
                coverpoint error_code.value{
                        bins lower = {[8'h00:8'h11]};
                        bins mid = {[8'h12:8'h13]};
                        bins high = {[8'h1F:8'hFF]};
                }

                coverpoint error_addr_offset.value{
                        bins lower = {[16'h0000:16'hAAAA]};
                        bins mid = {[16'hAAAB:16'hF000]};
                        bins high = {[16'hF001:16'hFFFF]};
                }

        endgroup
        function new(string name = "ERROR_STATUS");
                super.new(name, 32, UVM_CVR_ALL);
                error_status_cov = new();
        endfunction

        function void build();

                 bus_error = uvm_reg_field::type_id::create("bus_error");
                 timeout_error = uvm_reg_field::type_id::create("timeout_error");
                 alignment_error = uvm_reg_field::type_id::create("alignment_error");
                 underflow_error = uvm_reg_field::type_id::create("underflow_error");
                 overflow_error = uvm_reg_field::type_id::create("overflow_error");
                 Reserved = uvm_reg_field::type_id::create("Reserved");
                 error_code = uvm_reg_field::type_id::create("error_code");
                 error_addr_offset = uvm_reg_field::type_id::create("error_addr_offset");

                bus_error.configure(            .parent(this),
                                                .size(1),
                                                .lsb_pos(0),
                                                .access("W1C"),
                                                .volatile(1),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));

                 timeout_error.configure(       .parent(this),
                                                .size(1),
                                                .lsb_pos(1),
                                                .access("W1C"),
                                                .volatile(1),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));

                 alignment_error.configure(     .parent(this),
                                                .size(1),
                                                .lsb_pos(2),
                                                .access("W1C"),
                                                .volatile(1),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));

                overflow_error.configure(       .parent(this),
                                                .size(1),
                                                .lsb_pos(3),
                                                .access("W1C"),
                                                .volatile(1),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));

                underflow_error.configure(      .parent(this),
                                                .size(1),
                                                .lsb_pos(4),
                                                .access("W1C"),
                                                .volatile(1),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));


                 Reserved.configure(            .parent(this),
                                                .size(3),
                                                .lsb_pos(5),
                                                .access("RO"),
                                                .volatile(0),
                                                .reset(3'b000),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));

                error_code.configure(           .parent(this),
                                                .size(8),
                                                .lsb_pos(8),
                                                .access("RO"),
                                                .volatile(0),
                                                .reset(8'h00),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));

                 error_addr_offset.configure(   .parent(this),
                                                .size(16),
                                                .lsb_pos(16),
                                                .access("RO"),
                                                .volatile(0),
                                                .reset(16'h0000),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));
        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
                error_status_cov.sample();
        endfunction

        function void sample_values();
                super.sample_values();
                error_status_cov.sample();
        endfunction

endclass


////// CONFIG Register (0x424)
class CONFIG extends uvm_reg;
        `uvm_object_utils(CONFIG)

        rand uvm_reg_field  priorityy;
        rand uvm_reg_field  auto_restart;
        rand uvm_reg_field  interrupt_enable;
        rand uvm_reg_field  burst_size;
        rand uvm_reg_field  data_width;
        rand uvm_reg_field  descriptor_mode;
        uvm_reg_field  Reserved;

        covergroup config_cov;
                option.per_instance = 1;

                coverpoint priorityy.value{
                        bins low = {[0:1]};
                        bins high = {[2:3]};
                }
                coverpoint auto_restart.value;
                coverpoint interrupt_enable.value;

                coverpoint burst_size.value{
                        bins low = {[0:1]};
                        bins high = {[2:3]};
                }
                coverpoint data_width.value{
                        bins low = {[0:1]};
                        bins high = {[2:3]};
                }
                coverpoint descriptor_mode.value;
                coverpoint Reserved.value {
                        bins lower = {[23'h000000:23'h0AAAAA]};
                        bins mid   = {[23'h0AAAAB:23'h0F0000]};
                        bins high  = {[23'h0F0001:23'h7FFFFF]};
                }

        endgroup
        function new(string name = "CONFIG");
                super.new(name, 32, UVM_CVR_ALL);
                config_cov = new();
        endfunction

        function void build();

                 priorityy = uvm_reg_field::type_id::create("priorityy");
                 auto_restart = uvm_reg_field::type_id::create("auto_restart");
                 interrupt_enable = uvm_reg_field::type_id::create("interrupt_enable");
                 burst_size = uvm_reg_field::type_id::create("burst_size");
                 data_width = uvm_reg_field::type_id::create("data_width");
                 descriptor_mode = uvm_reg_field::type_id::create("descriptor_mode");
                 Reserved = uvm_reg_field::type_id::create("Reserved");

                priorityy.configure(            .parent(this),
                                                .size(2),
                                                .lsb_pos(0),
                                                .access("RW"),
                                                .volatile(0),
                                                .reset(2'b00),
                                                .has_reset(1),
                                                .is_rand(1),
                                                .individually_accessible(1));

                 auto_restart.configure(        .parent(this),
                                                .size(1),
                                                .lsb_pos(2),
                                                .access("RW"),
                                                .volatile(0),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(1),
                                                .individually_accessible(1));

                  interrupt_enable.configure(   .parent(this),
                                                .size(1),
                                                .lsb_pos(3),
                                                .access("RW"),
                                                .volatile(0),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(1),
                                                .individually_accessible(1));

                 burst_size.configure(          .parent(this),
                                                .size(2),
                                                .lsb_pos(4),
                                                .access("RW"),
                                                .volatile(0),
                                                .reset(2'b00),
                                                .has_reset(1),
                                                .is_rand(1),
                                                .individually_accessible(1));

                 data_width.configure(          .parent(this),
                                                .size(1),
                                                .lsb_pos(6),
                                                .access("RW"),
                                                .volatile(0),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(1),
                                                .individually_accessible(1));

                 descriptor_mode.configure(     .parent(this),
                                                .size(1),
                                                .lsb_pos(8),
                                                .access("RW"),
                                                .volatile(0),
                                                .reset(0),
                                                .has_reset(1),
                                                .is_rand(1),
                                                .individually_accessible(1));

                Reserved.configure(             .parent(this),
                                                .size(23),
                                                .lsb_pos(9),
                                                .access("RO"),
                                                .volatile(0),
                                                .reset(23'h000000),
                                                .has_reset(1),
                                                .is_rand(0),
                                                .individually_accessible(1));

        endfunction

        virtual function void sample(uvm_reg_data_t data, uvm_reg_data_t byte_en, bit is_read, uvm_reg_map map);
                config_cov.sample();
        endfunction

        function void sample_values();
                super.sample_values();
                config_cov.sample();
        endfunction
endclass
