package Assignment3;

//---------Q2-------------

class CounterConstraints;

    parameter WIDTH = 4, MAX = 15;
    rand bit rst_n;
    rand bit load_n;
    rand bit up_down;
    rand bit ce;
    rand bit [WIDTH-1:0] data_load;
    bit clk;
    logic [WIDTH-1:0] count_out;

        covergroup CovCode @(posedge clk);

            laod_data_cp: coverpoint data_load iff(rst_n && (!load_n)) ;
            count_outIncrement_cp: coverpoint count_out iff(rst_n && ce && up_down);

            count_outOverflow_cp: coverpoint count_out iff(rst_n && ce && up_down){
                bins OV = (MAX => 0);
            }

            count_outDecrement_cp: coverpoint count_out iff(rst_n && ce && !up_down);

            count_outUnderflow_cp: coverpoint count_out iff(rst_n && ce && !up_down){
                bins UV = (0 => MAX);
            }
        endgroup

        constraint CounterSignals{

            rst_n dist {
                'b0 := 10,
                'b1 := 90
            };
            load_n dist {
                'b0 := 70,
                'b1 := 30
            };
            ce dist {
                'b0 := 70,
                'b1 := 30
            };
            up_down dist {
                'b0 := 50,
                'b1 := 50
            };
            data_load !=0;
        }

        function new();
            CovCode = new();
        endfunction
    endclass


 //----------------------Q3-------------

 typedef enum bit [2:0]  { 
        OR = 3'b00,
        XOR = 3'b001,
        ADD = 3'b010,
        MULT = 3'b011,
        SHIFT = 3'b100,
        ROTATE = 3'b101,
        INVALID_6 = 3'b110,
        INVALID_7 = 3'b111
     } opcode_e;



    class ALSUconstraints;
    rand bit cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    bit clk;
    rand opcode_e opcode;
    rand opcode_e opcode_sequence [6];
    rand bit signed [2:0] A, B;
    parameter MAXPOS = 3 ;
    parameter MAXNEG = -4;


    covergroup CovCode ;

    //=============== A coverage points ======================
       A_cp: coverpoint A iff(!rst){
        bins A_data_0 = {0};     // law shelt {} bedee error
        bins A_data_max = {MAXPOS};
        bins A_data_min = {MAXNEG};
        bins A_data_default = default;
       }

       A_WalkingOnes_cp: coverpoint A iff(!rst && red_op_A){
        bins A_data_walkingones[] = {001, 010, 100};
       }

    //=============== B coverage points ======================

       B_cp: coverpoint B iff(!(rst || bypass_A)){ //*
        bins B_data_0 = {0};
        bins B_data_max = {MAXPOS};
        bins B_data_min = {MAXNEG};
        bins B_data_default = default;
       }

       B_WalkingOnes_cp: coverpoint B iff(!(rst || bypass_A) && red_op_B && !red_op_A){ 
        bins B_data_walkingones[] = {001, 010, 100};
       }

    //=============== Opcode coverage points ====================== 

        ALU_cp: coverpoint opcode iff(!(rst || bypass_A || bypass_B)){

            bins Bins_shift[] = {SHIFT,ROTATE};
            bins Bins_arith[] = {ADD,MULT};
            bins Bins_bitwise[] = {OR,XOR};
            illegal_bins Bins_invalid = {INVALID_6,INVALID_7};
            bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
        }
    endgroup  

    
    constraint ALSUsignals{

            rst dist{
                0 := 95, 1 := 5
            };
 
            if(opcode == (ADD||MULT)){
                A dist{
                0 := 30,3 := 30,-4:= 30
                };

                B dist{
                0 := 30,3 := 30,-4:= 30
                };
            }
            else if (opcode == (OR || XOR)){
                A > 0;
                B > 0;
            }

        opcode dist {
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
            red_op_A dist{
                0 := 50,1 := 50
            };
            red_op_B dist{
                0 := 50,1 := 50
            };
        }
        else {
            red_op_A dist{
                0 := 98,1 := 2
            };
            red_op_B dist{
                0 := 98,1 := 2
            };
        }
    }

    constraint OpcodeSequence {
        unique{opcode_sequence};
        foreach (opcode_sequence[i]) opcode_sequence[i] inside {[OR:ROTATE]};
    }

        function new();
            CovCode = new();
        endfunction

        function void display_sequence();
            $display("opcode sequence: %0p",opcode_sequence);
        endfunction
        
    endclass    

endpackage
