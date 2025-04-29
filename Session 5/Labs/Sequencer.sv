


package Sequencer;
import 	uvm_pkg	::*;
`include "uvm_macros.svh";
import 	Sequence_item_pkg::*;
	class shift_reg_Sequencer extends  uvm_sequencer #(shift_reg_SequenceItem);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_component_utils(shift_reg_Sequencer)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "shift_reg_Sequencer", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

endclass : shift_reg_Sequencer

	
endpackage : Sequencer

