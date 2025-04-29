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

        covergroup CovCode ;

            laod_data_cp: coverpoint data_load iff(rst_n && (!load_n)) ;
            count_outIncrement_cp: coverpoint count_out iff(rst_n && load_n && ce && up_down);

            count_outOverflow_cp: coverpoint count_out iff(rst_n && load_n && ce && up_down){
                bins OV = (MAX => 0);
            }

            count_outDecrement_cp: coverpoint count_out iff(rst_n && load_n && ce && !up_down);

            count_outUnderflow_cp: coverpoint count_out iff(rst_n && load_n && ce && !up_down){
                bins UV = (0 => MAX);
            }
        endgroup

        constraint CounterSignals{

            rst_n dist {
                'b0 := 10,
                'b1 := 90
            };
            load_n dist {
                'b1 := 90,
                'b0 := 10
            };
            ce dist {
                'b0 := 10,
                'b1 := 90
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
    randc opcode_e opcode_exp;
    rand opcode_e opcode_sequence [6];
    rand bit signed [2:0] A, B;
    randc bit[2:0] A_exp,B_exp;  
    parameter MAXPOS = 3 ;
    parameter MAXNEG = -4;


    covergroup CovCode ;

    //=============== A coverage points ======================
       A_cp: coverpoint A iff(!rst){
        bins A_data_0 = {0};     
        bins A_data_max = {MAXPOS};
        bins A_data_min = {MAXNEG};
        bins A_data_default = default;
       }

       A_WalkingOnes_cp: coverpoint unsigned'(A) iff(!rst && red_op_A){
        bins A_data_walkingones001 = {3'b001};
        bins A_data_walkingones010 = {3'b010};
        bins A_data_walkingones100 = {3'b100};
       }

    //=============== B coverage points ======================

       B_cp: coverpoint B iff(!(rst || bypass_A)){ //*
        bins B_data_0 = {0};
        bins B_data_max = {MAXPOS};
        bins B_data_min = {MAXNEG};
        bins B_data_default = default;
       }

       B_WalkingOnes_cp: coverpoint unsigned'(B) iff(!(rst || bypass_A) && red_op_B && !red_op_A){ 
        bins B_data_walkingones001 = {3'b001};
        bins B_data_walkingones010 = {3'b010};
        bins B_data_walkingones100 = {3'b100};

       }

    //=============== Opcode coverage points ====================== 

        ALU_cp: coverpoint opcode iff(!(rst || bypass_A || bypass_B)){

            bins Bins_shift[] = {SHIFT,ROTATE};
            bins Bins_arith[] = {ADD,MULT};
            bins Bins_bitwise[] = {OR,XOR};
            illegal_bins Bins_invalid = {INVALID_6,INVALID_7};
            bins Bins_trans = (OR => XOR => ADD => MULT => SHIFT => ROTATE);
        }

    //=========== reduction operation coverage point ==============
    
    red_op_A_cp: coverpoint red_op_A{
        bins red_op_A_bins = {1};
    }

    red_op_B_cp: coverpoint red_op_B{
        bins red_op_B_bins = {1};
    }


    //======================Cross coverpoints======================
        
        //1. add/mult cross A_cp and B_cp
        
        addMultCrossAB: cross ALU_cp, A_cp,B_cp{
            //option.cross_auto_bin_max = 0; 
            ignore_bins notArth = !binsof(ALU_cp.Bins_arith);
        }

        //2. add cross cin

        addCrossCin: cross ALU_cp, cin iff(opcode == ADD){
           //option.cross_auto_bin_max = 0;
           ignore_bins notADD = !binsof(ALU_cp.Bins_arith) intersect{ADD};
           ignore_bins notADD2 = !binsof(ALU_cp.Bins_arith);
        }
        
        //3. shift/rotate cross direction

        shiftRotateCrossDir: cross ALU_cp, direction {

            ignore_bins notShiftRotate = ! binsof(ALU_cp.Bins_shift);
        }

        //4. shift cross shift_in

        shiftCrossShiftin: cross ALU_cp, serial_in iff(opcode == SHIFT){

            ignore_bins notShiftBins = !binsof(ALU_cp.Bins_shift) intersect{SHIFT};
            ignore_bins notShift = !binsof(ALU_cp.Bins_shift);
        }

        //5. OR/XOR and redA cross (A=> walking ones, B=> 0) 

        BinsBitwiseCrossWalkingA: cross ALU_cp, B_cp, A_WalkingOnes_cp iff(red_op_A){

            ignore_bins notBitwise = !binsof(ALU_cp.Bins_bitwise);
            ignore_bins BnotZero = !binsof(B_cp.B_data_0);

        }

        //6. OR/XOR and (!redA && redopB) cross (B=> walking ones, A=> 0) 

        BinsBitwiseCrossWalkingB: cross ALU_cp, A_cp, B_WalkingOnes_cp iff((!red_op_A && red_op_B)){

            ignore_bins notBitwise = !binsof(ALU_cp.Bins_bitwise);
            ignore_bins BnotZero = !binsof(A_cp.A_data_0);

        }

        //7. reduction operation while opcode != OR/XOR

        Bins_invalid_reduction: cross ALU_cp , red_op_A_cp,red_op_B_cp {

            ignore_bins valid_A_reduction = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_A_cp.red_op_A_bins);
            ignore_bins valid_B_reduction = binsof(ALU_cp.Bins_bitwise) && binsof(red_op_B_cp.red_op_B_bins);
            ignore_bins transition_cp = binsof(ALU_cp.Bins_trans) ;
        } 
        
    endgroup  

    
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

    

        function new();
            CovCode = new();

        endfunction

        function void display_sequence();
            $display("opcode sequence: %0p",opcode_sequence);
        endfunction
        
    endclass    

endpackage
