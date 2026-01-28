
class driver extends uvm_driver #(reg_seq_item);
        `uvm_component_utils(driver)

        virtual intf vif;
        reg_seq_item req;

  function new(string name = "driver", uvm_component parent=null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if (!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
                  `uvm_fatal("DRV","Failed to get virtual interface")
        endfunction

        task run_phase(uvm_phase phase);
          req = reg_seq_item::type_id::create("req");
          		reset_dut();
                forever begin
                        seq_item_port.get_next_item(req);
                        drive(req);
                        seq_item_port.item_done();
                end
        endtask

        task drive(reg_seq_item req);

  			// IDLE
  			@(posedge vif.clk);
          	
  			vif.wr_en <= 0;
  			vif.rd_en <= 0;
  			vif.addr  <= req.addr;

  			// WRITE
  			if (req.wr_en) begin
    			vif.wdata <= req.wdata;
    			vif.wr_en <= 1'b1;

    			@(posedge vif.clk);
    			vif.wr_en <= 1'b0;

    			`uvm_info("DRV",$sformatf("WRITE addr=%0h data=%0h",req.addr, req.wdata),UVM_LOW)
  			end

  			// READ
  			if (req.rd_en) begin
    			vif.rd_en <= 1'b1;

    			@(posedge vif.clk);
    			vif.rd_en <= 1'b0;

    			@(posedge vif.clk);
    			req.rdata = vif.rdata;

    			`uvm_info("DRV",$sformatf("READ addr=%0h data=%0h",req.addr, req.rdata),UVM_LOW)
  			end
	
	endtask

          
        	task reset_dut();
                        vif.rst_n <= 1'b0;
                        vif.wr_en <= 1'b0;
                		vif.rd_en <= 1'b0;
                        vif.wdata <= 32'h00000000;
                        vif.addr <= 1'b0;
            			repeat(5)@(posedge vif.clk);
                        `uvm_info("DRV", "System Reset", UVM_NONE);
                        vif.rst_n <= 1'b1;
                endtask


endclass
























/*
class driver extends uvm_driver #(reg_seq_item);
        `uvm_component_utils(driver)

        virtual intf vif;
        reg_seq_item req;

  function new(string name = "driver", uvm_component parent=null);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if (!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
                  `uvm_fatal("DRV","Failed to get virtual interface")
        endfunction

        task run_phase(uvm_phase phase);
          req = reg_seq_item::type_id::create("req");
                forever begin
                        seq_item_port.get_next_item(req);
                        drive(req);
                        seq_item_port.item_done();
                end
        endtask

        task drive(reg_seq_item req);
          @(posedge vif.clk);
                vif.rst_n <= 1'b0;
                vif.wr_en <= req.wr_en;
                vif.rd_en <= req.rd_en;
                vif.addr  <= req.addr;

                if (req.wr_en) begin
                        vif.wdata <= req.wdata;
                                repeat(1)@(posedge vif.clk);
                        `uvm_info("DRV", $sformatf("WRITE addr=%0h data=%0h", req.addr, req.wdata), UVM_LOW)
                	repeat(1)@(posedge vif.clk);

		end


                if (req.rd_en) begin
                  repeat(3)@(posedge vif.clk);
                        req.rdata = vif.rdata;
                        `uvm_info("DRV", $sformatf("READ addr=%0h data=%0h", req.addr, req.rdata), UVM_LOW)
                end
     endtask


        task reset_dut();
          @(posedge vif.clk);
                        vif.rst_n <= 1'b1;
                        vif.wr_en <= 1'b0;
                vif.rd_en <= 1'b0;
                        vif.wdata <= 32'h00000000;
                        vif.addr <= 1'b0;
            repeat(5)@(posedge vif.clk);
                        `uvm_info("DRV", "System Reset", UVM_NONE);
                        vif.rst_n <= 1'b0;
                endtask


endclass




class driver extends uvm_driver#(reg_seq_item);
  `uvm_component_utils(driver)

  virtual intf vif;

  function new(string name = "driver", uvm_component parent);

    super.new(name, parent);

  endfunction

  function void build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db#(virtual intf) :: get(this, "", "vif", vif))

      `uvm_fatal(get_full_name(),"DRV doesnt have interface");

  endfunction




  task drive();

    // WRITE operation
    if (req.wr_en) begin

      vif.rst_n   <= 1'b0;

      vif.wr_en <= 1'b1;

      vif.rd_en <= 1'b0;
      vif.addr  <= req.addr;

      vif.wdata <= req.wdata;	
      repeat(2) @(posedge vif.clk);

      `uvm_info("DRV",

        $sformatf("WRITE : addr=%0h wdata=%0h", req.addr, req.wdata),

        UVM_NONE);

      repeat(2) @(posedge vif.clk);

    end

    // READ operation

    else if (req.rd_en) begin

      repeat(1) @(posedge vif.clk);

      vif.rst_n   <= 1'b0;

      vif.wr_en <= 1'b0;

      vif.rd_en <= 1'b1;

      vif.addr  <= req.addr;

      vif.wdata <= '0;

      repeat(1) @(posedge vif.clk);

      req.rdata = vif.rdata;

      `uvm_info("DRV",

        $sformatf("READ : addr=%0h rdata=%0h", req.addr, req.rdata),

        UVM_NONE);

    end

  endtask


  task run_phase(uvm_phase phase);

    super.run_phase(phase);

    forever begin

      seq_item_port.get_next_item(req);

      drive();

      seq_item_port.item_done();

    end

  endtask

endclass

class driver extends uvm_driver#(reg_seq_item);
  	`uvm_component_utils(driver)
	virtual intf vif;

  	function new(string name = "driver", uvm_component parent);
    		super.new(name, parent);
  	endfunction

  	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
    		if(!uvm_config_db#(virtual intf) :: get(this, "", "vif", vif))
      		`uvm_fatal(get_full_name(),"DRV doesnt have interface");
  	endfunction


        task drive();
          //@(posedge vif.clk);
                vif.rst_n <= 1'b0;
                vif.wr_en <= req.wr_en;
                vif.rd_en <= req.rd_en;
                vif.addr  <= req.addr;

                if (req.wr_en) begin
			 repeat(1)@(posedge vif.clk);
                        vif.wdata <= req.wdata;
                                repeat(1)@(posedge vif.clk);
                        `uvm_info("DRV", $sformatf("WRITE addr=%0h data=%0h", req.addr, req.wdata), UVM_LOW)
                end


                if (req.rd_en) begin
                  repeat(2)@(posedge vif.clk);
                        req.rdata = vif.rdata;
                        `uvm_info("DRV", $sformatf("READ addr=%0h data=%0h", req.addr, req.rdata), UVM_LOW)
                end
     endtask

	task drive();

    		// WRITE operation
    		if (req.wr_en) begin
			vif.rst_n <= 1'b0;
                	vif.wr_en <= 1'b1;
                	vif.rd_en <= 1'b0;
                	vif.addr  <= req.addr;
			repeat(1)@(posedge vif.clk);
      			vif.wdata <= req.wdata;
			repeat(0) @(posedge vif.clk);
      			`uvm_info("DRV",$sformatf("WRITE : addr=%0h wdata=%0h", req.addr, req.wdata),UVM_NONE);
      			repeat(1)@(posedge vif.clk);
    		end

    		// READ operation
    		else if (req.rd_en) begin
			vif.rst_n <= 1'b0;
                        vif.wr_en <= 1'b0;
                        vif.rd_en <= 1'b1;                                              vif.addr  <= req.addr;
                        vif.wdata <= '0;
			repeat(3) @(posedge vif.clk);
      			req.rdata = vif.rdata;
      			`uvm_info("DRV",$sformatf("READ : addr=%0h rdata=%0h", req.addr, req.rdata), UVM_NONE);
    			repeat(1) @(posedge vif.clk);
		end
  	endtask


  	task run_phase(uvm_phase phase);
		req = reg_seq_item::type_id::create("req");
    		super.run_phase(phase);
    		forever begin
      			seq_item_port.get_next_item(req);
      			drive();
      			seq_item_port.item_done();
   	 	end
  	endtask
endclass

class driver extends uvm_driver#(reg_seq_item);
	`uvm_component_utils(driver)
	reg_seq_item tr;
	virtual intf tif;

	function new(input string path = "driver", uvm_component parent = null);
		super.new(path,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual intf)::get(this,"","vif",tif))
			`uvm_error("drv","Unable to access Interface");
	endfunction

	///////////////reset DUT at the start
	task reset_dut();
		@(posedge tif.clk);
		tif.rst_n <= 1'b0;
		tif.wr_en <= 1'b0;
		tif.rd_en <= 1'b0;
		tif.wdata <= 8'h00;
		tif.addr <= 1'b0;
		repeat(1)@(posedge tif.clk);
		`uvm_info("DRV", "System Reset", UVM_NONE);
		tif.rst_n <= 1'b1;
		repeat(1)@(posedge tif.clk);
		`uvm_info("DRV", $sformatf("[%0d] - ",tif.rst_n), UVM_NONE);
	endtask

	//////////////drive DUT
	task drive_dut();
		//@(posedge tif.clk);
		tif.rst_n <= 1'b1;
		tif.wr_en <= tr.wr_en;
		tif.rd_en <= tr.rd_en;
		tif.addr <= tr.addr;
		if(tr.wr_en == 1'b1)begin
			repeat(1)@(posedge tif.clk);
			tif.wdata <= tr.wdata;
			`uvm_info("DRV", $sformatf("[%0d] Data Write -> Wdata : %0d",tif.rst_n,tr.wdata), UVM_NONE);
			repeat(1) @(posedge tif.clk);
		end
		else if(tr.rd_en == 1'b1)begin
			repeat(3) @(posedge tif.clk);
			`uvm_info("DRV", $sformatf("[%0d] Data Read -> Rdata : %0d",tif.rst_n,tif.rdata), UVM_NONE);
			tr.rdata = tif.rdata;
			@(posedge tif.clk);
		end 
	endtask
	///////////////main task of driver
	virtual task run_phase(uvm_phase phase);
		tr = reg_seq_item::type_id::create("tr");
		reset_dut();
		forever begin
			seq_item_port.get_next_item(tr);
				drive_dut();
			seq_item_port.item_done(); 
		end
	endtask

endclass

*/
