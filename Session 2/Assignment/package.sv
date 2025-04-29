package A2;
    
//Counter

// class CounterConstraints;

// parameter WIDTH = `WIDTH;
// rand bit rst_n;
// rand bit load_n;
// rand bit up_down;
// rand bit ce;
// rand bit [WIDTH-1:0] data_load;

// function new();
//     $display("WIDTH = %0d",WIDTH);
// endfunction


//     constraint CounterSignals{

//         rst_n dist {
//             'b0 := 10,
//             'b1 := 90
//         };
//         load_n dist {
//             'b0 := 70,
//             'b1 := 30
//         };
//         ce dist {
//             'b0 := 70,
//             'b1 := 30
//         };
//         up_down dist {
//             'b0 := 50,
//             'b1 := 50
//         };
//         data_load !=0;
//     }
//     endclass 


    //----------------------------------------------- End of Q2 ----------------------------------

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
    rand opcode_e opcode;
    rand bit signed [2:0] A, B;
    
    constraint ALSUsignals{

            rst dist{
                0 := 95,
                1 := 5
            };
 
            if(opcode == (ADD||MULT)){
                A dist{
                0 := 30,
                3 := 30,
                -4:= 30
                };

                B dist{
                0 := 30,
                3 := 30,
                -4:= 30
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
            0 := 90,
            1 := 10
        };
        bypass_B dist{
            0 := 90,
            1 := 10
        };

        if( opcode == (OR||XOR)){
            red_op_A dist{
                0 := 50,
                1 := 50
            };
            red_op_B dist{
                0 := 50,
                1 := 50
            };
        }
        else {
            red_op_A dist{
                0 := 98,
                1 := 2
            };
            red_op_B dist{
                0 := 98,
                1 := 2
            };
        }
    }
        
    endclass
endpackage

