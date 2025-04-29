


package shift_reset_sequence;
	import 	uvm_pkg	::*;
`include "uvm_macros.svh";
import 	Sequence_item_pkg::*;

class shift_reset_sequence extends  uvm_sequence#(shift_reg_SequenceItem);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	shift_reg_SequenceItem	seq_item;


/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(shift_reset_sequence)

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "shift_reset_sequence");
		super.new(name);
	endfunction : new

	task body();

		seq_item = shift_reg_SequenceItem::type_id::create("seq_item");
		start_item(seq_item);
		seq_item.reset	= 1;
		seq_item.serial_in = 1;
		seq_item.direction = 1;
		seq_item.mode =0;
  		finish_item(seq_item);
		
	endtask : 	body

endclass : shift_reset_sequence

class shift_main_sequence extends  uvm_sequence#(shift_reg_SequenceItem);

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	

/*-------------------------------------------------------------------------------
-- UVM Factory register
-------------------------------------------------------------------------------*/
	// Provide implementations of virtual methods such as get_type_name and create
	`uvm_object_utils(shift_main_sequence)
	shift_reg_SequenceItem seq_item ;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	// Constructor
	function new(string name = "shift_main_sequence");
		super.new(name);
	endfunction : new

	task body();
		seq_item = shift_reg_SequenceItem::type_id::create("main_seq");

		repeat(100) begin
			start_item(seq_item);
			assert(seq_item.randomize());
			finish_item(seq_item);
		end
	endtask : body

endclass : shift_main_sequence
	
endpackage : shift_reset_sequence
