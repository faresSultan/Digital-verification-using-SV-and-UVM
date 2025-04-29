
package Sequence_item_pkg;
	import 	uvm_pkg	::*;
	`include "uvm_macros.svh";
	class shift_reg_SequenceItem extends  uvm_sequence_item;

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	bit clk;
	rand logic reset;
  	rand logic serial_in, direction, mode;
  	rand logic [5:0] datain;

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(shift_reg_SequenceItem)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "shift_reg_SequenceItem");
		super.new(name);
	endfunction : new


	constraint 	Signals {
		
	}

endclass : shift_reg_SequenceItem

	
endpackage : Sequence_item_pkg

