class env extends uvm_env;

        `uvm_component_utils(env)

        agent ag;
        top_reg_block regmodel;
        top_adapter adapter_inst;

  uvm_reg_predictor #(reg_seq_item) predictor_inst;

        function new(string name = "env", uvm_component parent);
                super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
          predictor_inst = uvm_reg_predictor#(reg_seq_item)::type_id::create("predictor_inst",this);
                ag = agent::type_id::create("ag",this);
                regmodel = top_reg_block::type_id::create("regmodel",this);
		regmodel.set_hdl_path_root("tb_top.dut");
                regmodel.build();
                adapter_inst = top_adapter::type_id::create("adapter_inst",this);
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);

                regmodel.default_map.set_sequencer(.sequencer(ag.seqr),.adapter(adapter_inst));

          		regmodel.default_map.set_base_addr(0);
                predictor_inst.map = regmodel.default_map;

                predictor_inst.adapter = adapter_inst;

          ag.mon.ap_mon.connect(predictor_inst.bus_in);

                regmodel.default_map.set_auto_predict(0);
        endfunction
endclass

