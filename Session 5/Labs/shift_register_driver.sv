
package driver;
    import 	uvm_pkg	::*;
    `include "uvm_macros.svh";
    import 	Sequence_item_pkg::*;

    class shift_reg_driver extends  uvm_driver;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual shift_reg_if shift_reg_vif;
	shift_reg_config_class shift_cfg;	

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(shift_reg_driver)

/*-------------------------------------------------------------------------------
-- Functions
---------------------------------------
----------------------------------------*/
	// Constructor
	function new(string name = "shift_reg_driver", uvm_component parent=null);
		super.new(name, parent);

	endfunction : new

	function void connect_phase( uvm_phase phase);
			super.connect_phase(phase);

		 shift_reg_vif = shift_cfg.shift_reg_vif;
	endfunction 

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		shift_reg_vif.reset = 1;
	endtask

endclass : shift_reg_driver
    
endpackage

