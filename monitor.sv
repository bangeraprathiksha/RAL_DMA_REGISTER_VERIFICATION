class monitor extends uvm_monitor;
        `uvm_component_utils(monitor)

        uvm_analysis_port#(reg_seq_item) ap_mon;

        virtual intf vif;
        reg_seq_item req;

        function new(string name ="monitor",uvm_component parent);
                super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
          		ap_mon = new("ap_mon",this);
                if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
                        `uvm_error("MON","Failed to fetch interface signals")
        endfunction

                  
		task run_phase(uvm_phase phase);
  			reg_seq_item req;

  			forever begin
    			@(posedge vif.clk);

    			// ---------------- WRITE ----------------
    			if (vif.wr_en) begin
      				req = reg_seq_item::type_id::create("req");
      				req.wr_en = 1;
      				req.rd_en = 0;
      				req.addr  = vif.addr;
      				req.wdata = vif.wdata;

      				ap_mon.write(req);

      	`uvm_info("MON",$sformatf(" WRITE addr=%0h data=%0h",req.addr, req.wdata),UVM_LOW)
    			end

    		// ---------------- READ ----------------
    		if (vif.rd_en) begin
      			// wait until rdata is valid
      			@(posedge vif.clk);

      			req = reg_seq_item::type_id::create("req");
      			req.wr_en = 0;
      			req.rd_en = 1;
      			req.addr  = vif.addr;
      			req.rdata = vif.rdata;

      			ap_mon.write(req);
      
              	`uvm_info("MON",$sformatf(" READ addr=%0h data=%0h",req.addr, req.rdata),UVM_LOW)
    		end
  		end
	endtask


endclass
