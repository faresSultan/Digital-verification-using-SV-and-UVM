package alsu_sequence_pkg;
    import uvm_pkg::*;
    import alsu_seq_item_pkg::*;
    `include "uvm_macros.svh"


//=============================Reset Sequence===============================
    class alsu_reset_sequence extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_reset_sequence)
        alsu_seq_item seq_item;

        function new(string name = "alsu_reset_sequence");
            super.new(name);
        endfunction

        task body;
            seq_item = alsu_seq_item::type_id::create("seq_item");
            start_item(seq_item);

            seq_item.rst = 1;
            seq_item.A = 1;
            seq_item.B = 1;
            seq_item.opcode = ADD;

            finish_item(seq_item);
        endtask
    endclass

//=================opcode sequence constraint is disabled, all others are Enabled================

    class alsu_sequence_1 extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_sequence_1)
        alsu_seq_item seq_item;

        function new(string name = "alsu_sequence_1");
            super.new(name);
        endfunction

        task body;
            seq_item = alsu_seq_item::type_id::create("seq_item");

            seq_item.OpcodeSequence.constraint_mode(0);
            repeat(2000) begin
                start_item(seq_item);
                    assert (seq_item.randomize());
                finish_item(seq_item);
            end

            
        endtask
    endclass  

//=================opcode sequence constraint is Enabled, all others are Disabled================
    class alsu_sequence_2 extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_sequence_2)
        alsu_seq_item seq_item;

        function new(string name = "alsu_sequence_2");
            super.new(name);
        endfunction

        task body;
            seq_item = alsu_seq_item::type_id::create("seq_item");

            seq_item.OpcodeSequence.constraint_mode(1);
            seq_item.ALSUsignals.constraint_mode(0);
            seq_item.rst = 0;
            seq_item.bypass_A = 0;
            seq_item.bypass_B = 0;
            seq_item.red_op_A = 0;
            seq_item.red_op_B = 0;
            repeat(100) begin
                start_item(seq_item);
                    assert (seq_item.randomize());
                finish_item(seq_item);
            end

         
        endtask
    endclass 

//=================sequence to hit BinsBitwiseCrossWalkingA bins================

    class alsu_sequence_3 extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_sequence_3)
        alsu_seq_item seq_item;

        function new(string name = "alsu_sequence_3");
            super.new(name);
        endfunction

        task body;
            seq_item = alsu_seq_item::type_id::create("seq_item");
            

            seq_item.OpcodeSequence.constraint_mode(0); 
            seq_item.ALSUsignals.constraint_mode(1);
            repeat(50) begin
                start_item(seq_item); 
                    assert (seq_item.randomize() with{
                        A_exp inside{WalkingOnesSequence};
                        A == A_exp;
                        B == 0;
                        rst == 0;
                        opcode == opcode_exp;
                        red_op_A == 1;
                        opcode_exp dist {
                            OR := 50,
                            XOR := 50
                        };
                    });
                finish_item(seq_item);
            end

            
        endtask
    endclass  

//=================sequence to hit BinsBitwiseCrossWalkingB bins================

    class alsu_sequence_4 extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_sequence_4)
        alsu_seq_item seq_item;

        function new(string name = "alsu_sequence_4");
            super.new(name);
        endfunction

        task body;
            seq_item = alsu_seq_item::type_id::create("seq_item");
        
            seq_item.OpcodeSequence.constraint_mode(0); 
            seq_item.ALSUsignals.constraint_mode(1);
            repeat(50) begin
                start_item(seq_item); 
                    assert (seq_item.randomize() with{
                        A_exp inside{WalkingOnesSequence};
                        A == 0;
                        B == B_exp;
                        rst == 0;
                        opcode == opcode_exp;
                        red_op_B == 1;
                        red_op_A == 0;
                        opcode_exp dist {
                            OR := 50,
                            XOR := 50
                        };
                    });
                finish_item(seq_item);
            end    
        endtask
    endclass  

//===================sequence to hit Opcode transition bins===================

    class alsu_sequence_5 extends uvm_sequence #(alsu_seq_item);
        `uvm_object_utils(alsu_sequence_5)
        alsu_seq_item seq_item;
        opcode_e transitionPattern[6] = '{OR, XOR, ADD, MULT, SHIFT, ROTATE};

        function new(string name = "alsu_sequence_5");
            super.new(name);
        endfunction

        task body;
            seq_item = alsu_seq_item::type_id::create("seq_item");
        
            seq_item.OpcodeSequence.constraint_mode(0); 
            seq_item.ALSUsignals.constraint_mode(0);
            


            foreach (transitionPattern[i]) begin
                start_item(seq_item); 
                    seq_item.rst = 0;
                    seq_item.red_op_A = 0;
                    seq_item.red_op_B = 0;
                    seq_item.bypass_A = 0;
                    seq_item.bypass_B = 0;
                    seq_item.opcode = transitionPattern[i];
                finish_item(seq_item);
            end


        endtask
    endclass  

endpackage