class test extends uvm_test;

        `uvm_component_utils(test)

        env e;
        top_reg_seq seq;

        function new(string name = "test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                e = env::type_id::create("e",this);
                seq = top_reg_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                        phase.drop_objection(this);
        endtask

endclass

class reset_check_test extends test;

        `uvm_component_utils(reset_check_test)

        reset_check_seq seq;

        function new(string name = "reset_check_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = reset_check_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                        phase.drop_objection(this);
        endtask

endclass

class intr_test extends test;

        `uvm_component_utils(intr_test)

        intr_seq seq;

        function new(string name = "intr_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = intr_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                        phase.drop_objection(this);
        endtask

endclass

class ctrl_test extends test;
	`uvm_component_utils(ctrl_test)
	
	ctrl_seq seq;
	
	function new(string name = "ctrl_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq = ctrl_seq::type_id::create("seq");
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			seq.regmodel = e.regmodel;
			seq.start(e.ag.seqr);
			phase.phase_done.set_drain_time(this,20);
		phase.drop_objection(this);		
	endtask

endclass

class io_addr_test extends test;

        `uvm_component_utils(io_addr_test)

        io_addr_seq seq;

        function new(string name = "io_addr_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = io_addr_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                        phase.drop_objection(this);
        endtask

endclass

class mem_addr_test extends test;

        `uvm_component_utils(mem_addr_test)

        mem_addr_seq seq;

        function new(string name = "mem_addr_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = mem_addr_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                phase.drop_objection(this);
        endtask

endclass

class extra_info_test extends test;

        `uvm_component_utils(extra_info_test)

        extra_info_seq seq;

        function new(string name = "extra_info_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = extra_info_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                phase.drop_objection(this);
        endtask

endclass


class status_test extends test;

        `uvm_component_utils(status_test)

        status_seq seq;

        function new(string name = "status_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = status_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                phase.drop_objection(this);
        endtask

endclass


class transfer_count_test extends test;

        `uvm_component_utils(transfer_count_test)

        transfer_count_seq seq;

        function new(string name = "transfer_count_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = transfer_count_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                phase.drop_objection(this);
        endtask

endclass


class descriptor_addr_test extends test;

        `uvm_component_utils(descriptor_addr_test)

        descriptor_addr_seq seq;

        function new(string name = "descriptor_addr_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = descriptor_addr_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                phase.drop_objection(this);
        endtask

endclass



class error_status_test extends test;

        `uvm_component_utils(error_status_test)

        error_status_seq seq;

        function new(string name = "error_status_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = error_status_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                phase.drop_objection(this);
        endtask

endclass



class config_test extends test;

        `uvm_component_utils(config_test)

        config_seq seq;

        function new(string name = "config_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = config_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                phase.drop_objection(this);
        endtask

endclass



class regression_test extends test;

        `uvm_component_utils(regression_test)

        regression_seq seq;

        function new(string name = "regression_test", uvm_component parent);
                super.new(name,parent);
        endfunction

        virtual function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                seq = regression_seq::type_id::create("seq");
        endfunction

        virtual task run_phase(uvm_phase phase);
                phase.raise_objection(this);
                        seq.regmodel = e.regmodel;
                        seq.start(e.ag.seqr);
                        phase.phase_done.set_drain_time(this, 20);
                phase.drop_objection(this);
        endtask

endclass
