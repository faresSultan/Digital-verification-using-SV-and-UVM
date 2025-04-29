
package alsu_seq_item_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

     typedef enum logic [2:0]  { 
        OR = 3'b00,
        XOR = 3'b001,
        ADD = 3'b010,
        MULT = 3'b011,
        SHIFT = 3'b100,
        ROTATE = 3'b101,
        INVALID_6 = 3'b110,
        INVALID_7 = 3'b111
     } opcode_e;

    class alsu_seq_item extends uvm_sequence_item;
        `uvm_object_utils(alsu_seq_item)

        rand bit cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
        bit clk;
        rand opcode_e opcode;
        randc opcode_e opcode_exp;
        rand opcode_e opcode_sequence [6];
        rand bit signed [2:0] A, B;
        randc bit[2:0] A_exp,B_exp;
        bit [2:0] WalkingOnesSequence[3] = '{3'b001,3'b010,3'b100};  
        parameter MAXPOS = 3 ;
        parameter MAXNEG = -4;

        function new(string name = "alsu_seq_item");
            super.new(name);
        endfunction

        constraint ALSUsignals{

                soft rst dist{
                    0 := 95, 1 := 5
                };
    
                if(opcode == (ADD||MULT)){
                    soft A dist{
                    0 := 30,3 := 30,-4:= 30
                    };

                    soft B dist{
                    0 := 30,3 := 30,-4:= 30
                    };
                }
                else if (opcode == (OR || XOR)){
                    A > 0;
                    B > 0;
                }

            soft opcode dist {
                [OR:ROTATE] :/ 95,
                [INVALID_6:INVALID_7] :/ 5
            };

            bypass_A dist{
                0 := 90, 1 := 10
            };
            bypass_B dist{
                0 := 90,1 := 10
            };

            if( opcode == (OR||XOR)){
                soft red_op_A dist{
                    0 := 50,1 := 50
                };
                soft red_op_B dist{
                    0 := 50,1 := 50
                };
            }
            else {
                soft red_op_A dist{
                    0 := 98,1 := 2
                };
                soft red_op_B dist{
                    0 := 98,1 := 2
                };
            }
        }

        constraint OpcodeSequence {
            unique{opcode_sequence};
            foreach (opcode_sequence[i]) opcode_sequence[i] inside {[OR:ROTATE]};
        }      
    endclass
endpackage