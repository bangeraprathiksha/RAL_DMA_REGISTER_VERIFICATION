class subscriber extends uvm_component;
	`uvm_component_utils(subscriber)

  	uvm_analysis_imp #(reg_seq_item, subscriber) subscrb_port;

  	reg_seq_item cov_item;
  	real item_cov;

  	covergroup cg;
		option.per_instance = 1;
    		rst_cp : coverpoint cov_item.rst_n{ bins rst_bin[] = {0, 1};}
    		wr_en_cp : coverpoint cov_item.wr_en{ bins wr_en_bin[] = {0, 1};}
    		rd_en_cp : coverpoint cov_item.rd_en{ bins rd_en_bin[] = {0, 1};}
    		wdata_cp : coverpoint cov_item.wdata{ bins wdata_bin = {[0:$]};}
    		rdata_cp : coverpoint cov_item.rdata{ bins rdata_bin = {[0:$]};}
    		addr_cp : coverpoint cov_item.addr{ 
    			bins intr_addr = {[1024:1027]};   // 0x400
			bins ctrl_addr = {[1028:1031]};   // 0x404
			bins io_addr = {[1032:1035]};   // 0x408
			bins mem_addr = {[1036:1039]};   // 0x40C
			bins extra_info_addr  = {[1040:1043]};   // 0x410
			bins status_addr  = {[1044:1047]};   // 0x414
			bins transfer_count_addr = {[1048:1051]};   // 0x418
			bins descriptor_addr  = {[1052:1055]};   // 0x41C
			bins error_status_addr = {[1056:1059]};   // 0x420
			bins configure_addr = {[1060:1063]};   // 0x424
    			ignore_bins other_addr[] = {[0:1023]};
    		}

  	endgroup

  	function new(string name = "subscriber", uvm_component parent);
		super.new(name, parent);
		cg = new();
		subscrb_port = new("subscrb_port", this);
  	endfunction


  	function void write(reg_seq_item t); 
    		cov_item = t;
    		cg.sample();
	endfunction

  	function void extract_phase(uvm_phase phase);
  		super.extract_phase(phase);
 	 	item_cov = cg.get_coverage();
  	endfunction

  	function void report_phase(uvm_phase phase);
   		super.report_phase(phase);
    		`uvm_info(get_type_name, $sformatf(" Coverage ------> %0.2f%%,", item_cov), UVM_MEDIUM);
	endfunction

endclass
 
