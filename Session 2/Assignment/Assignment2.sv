import A2::*;

module Q1 ();

	int dyn_arr2 [] = '{9,1,8,3,4,4};
	int dyn_arr1 [] = new[6];

	initial begin
		foreach (dyn_arr1[i]) begin
			dyn_arr1[i] = i;
		end

		$display("dyn_arr1 elements: %0p, Size = %0d",dyn_arr1, dyn_arr1.size());
		$display("dyn_arr2 elements: %0p, Size = %0d",dyn_arr2, dyn_arr2.size());

		dyn_arr1.delete();

		dyn_arr2.reverse();
		$display("dyn_arr2 Reversed: %0p",dyn_arr2);

		dyn_arr2.reverse();
		dyn_arr2.sort();
		$display("dyn_arr2 Sorted: %0p",dyn_arr2);

		dyn_arr2.rsort();
		$display("dyn_arr2 Reverse Sorted: %0p",dyn_arr2);

		dyn_arr2.shuffle();
		$display("dyn_arr2 Suffled: %0p",dyn_arr2);
	end

endmodule 

//-----------------------------------------------End of Q1-------------------------------------------------

// module Q2();
    
//     CounterConstraints constraintVals = new;
//     parameter WIDTH = constraintVals.WIDTH;
    
//     bit clk, rst_n, load_n, up_down, ce;
//     bit [WIDTH-1:0] data_load;
//     logic [WIDTH-1:0] count_out;
//     logic max_count;
//     logic zero;
//     int Error_Count,Correct_Count;

//     counter#(.WIDTH(WIDTH)) DUT (.*);
    
// //---clk generation
//     initial begin
//          clk = 0;
//         forever begin
//             #1 clk = !clk;
//         end
//     end

//     initial begin

//         Error_Count = 0;
//         Correct_Count = 0;

//     //--Counter1
//         load_n = 0;
//         data_load = 'hf;
//         assert_reset;   

//     //--Counter2,3,4,5,6   

//         repeat(50) begin
//             assert (constraintVals.randomize());
//             rst_n = constraintVals.rst_n;
//             load_n = constraintVals.load_n;
//             ce = constraintVals.ce;
//             up_down = constraintVals.up_down;
//             data_load = constraintVals.data_load;

//             check_result(rst_n, ce,load_n,up_down,data_load);
//         end 

//         $display("Correct Count: %0d",Correct_Count);
//         $display("Error Count: %0d", Error_Count);
//         $stop;  
//     end

//     task assert_reset ;
//     rst_n = 0;
//     @(negedge clk);   
//     if ((count_out != 'b0)&&(zero != 1'b1))begin
//         $display("Reset failed");
//         Error_Count++;   
//     end
//     else begin
//         $display("Reset Passed");
//         Correct_Count++;
//     end 
//     rst_n = 1;
//     @(negedge clk);
//     endtask 

//     task GoldenModel(
//         input rst_n, ce,load_n,up_down,[WIDTH-1:0] data_load,
//         output zero,max_count,[WIDTH-1 : 0]count_out
//     );
//         if (rst_n == 0) begin
//             max_count = 0;
//             count_out = 'b0;
//         end

//         else if (load_n == 0) count_out = data_load;

//         else if (ce) begin
//             if(up_down == 1) count_out = count_out + 1;
//             else count_out = count_out - 1; 
//         end

//         if (count_out == 0) zero = 1;
//         else zero = 0;

//         if (count_out == {WIDTH{1'b1}}) max_count = 1; 
//         else max_count = 0;


//     endtask

//     task check_result (
//         input rst_n, ce,load_n,up_down,[WIDTH-1:0] data_load
//     );
//         logic zero_expected,max_count_expected;
//         logic [WIDTH-1:0] count_out_expected;

//         GoldenModel(
//             rst_n, ce,load_n,up_down,data_load,
//             zero_expected,max_count_expected,count_out_expected
//         );

//         @(negedge clk);
    
//         if((count_out == count_out_expected)&&(zero == zero_expected)&&(max_count == max_count_expected)) begin
//             Correct_Count++;
//         end

//         else begin
//             if (zero != zero_expected)
//                 $display("Time: %0t, Failed for Zero flag",$time);

//             else if (max_count != max_count_expected) 
//                 $display("Time: %0t, Failed for max_count flag, count_out= %0h",$time,count_out);

//             else if (count_out != count_out_expected) 
//                 $display("Time: %0t, Failed for count_out, Expected: %0b, Result: %0b",$time, count_out_expected,count_out);

//             Error_Count++;
//             $stop; 
//         end
//     endtask
// endmodule

//-----------------------------------------------End of Q2-------------------------------------------------

module Q3();

    bit clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    opcode_e opcode;
    bit signed [2:0] A, B;
    logic [15:0] leds,leds_exp;
    logic signed [5:0] out,out_exp;

    bit cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
    opcode_e opcode_reg;
    bit signed [2:0] A_reg, B_reg;

    int Error_Count,Correct_Count;

    ALSUconstraints constraintVals = new;

    ALSU DUT (.*);

    //---clk generation
    initial begin
         clk = 0;
        forever begin
            #1 clk = !clk;
        end
    end

    initial begin
        Error_Count = 0;
        Correct_Count = 0;

    //--ALSU1
        assert_reset;

    // ALSU 2,3,4,5
    
        repeat(2000) begin
            assert (constraintVals.randomize());
            rst = constraintVals.rst;
            cin = constraintVals.cin;
            red_op_A = constraintVals.red_op_A;
            red_op_B = constraintVals.red_op_B;
            bypass_A = constraintVals.bypass_A;
            bypass_B = constraintVals.bypass_B;
            direction = constraintVals.direction;
            serial_in = constraintVals.serial_in;
            opcode = constraintVals.opcode;
            A = constraintVals.A;
            B = constraintVals.B;

            if (rst) check_reset;
            else begin
                check_result(
                    rst, cin, red_op_A, red_op_B, bypass_A, bypass_B,
                    direction, serial_in, A, B, opcode
                    );
            end
        end
            red_op_A = 1;
            red_op_B = 1;
            check_result(
                rst, cin, red_op_A, red_op_B, bypass_A, bypass_B,
                direction, serial_in, A, B, opcode
            ); 

            // directed case to complete code coverage
            bypass_A = 1;
            bypass_B = 1;
            check_result(
                rst, cin, red_op_A, red_op_B, bypass_A, bypass_B,
                direction, serial_in, A, B, opcode
            );
        $display("Correct Count: %0d",Correct_Count);
        $display("Error Count: %0d", Error_Count);
        $stop;  

    end

    //------Tasks

    task assert_reset();

        rst = 1;
        check_reset();
    endtask

    task check_reset();
        @(negedge clk);
        if (out == 0 && leds == 0) begin
            @(negedge clk);
            if(out == 0 && leds == 0) begin
                Correct_Count++;
                $display("Reset passed");
            end
            else begin
                Error_Count++;
                $display("Reset failed");
                $stop;
            end
        end
        else begin
                Error_Count++;
                $display("Reset failed");
                $stop;
        end
        reset_internals();
    endtask

    task GoldenModel();

        bit valid;
    if (rst) begin
        reset_internals();
        out_exp = 'b0;
        leds_exp ='b0;
    end

    else begin
        check_validity(red_op_A_reg,red_op_B_reg,opcode_reg,valid);

        // leds expected behavior
        if (!valid) begin     
            leds_exp = ~leds;  
        end
        else begin
            leds_exp = 'b0;
        end

        // out expected behavior
        if(bypass_A_reg) begin
            out_exp = A_reg;
        end
        else if (bypass_B_reg) begin
            out_exp = B_reg;
        end

        else if (!valid) begin
            out_exp = 'b0;
        end

        else begin
            case (opcode_reg)
                OR: begin
                        if(red_op_A_reg) begin
                            out_exp = |A_reg;
                        end else if (!red_op_A_reg && red_op_B_reg) begin
                            out_exp = |B_reg;               
                        end else begin
                            out_exp = A_reg | B_reg;                  
                    end 
                end 

                XOR: begin
                        if(red_op_A_reg) begin
                            out_exp = ^A_reg;
                        end else if (!red_op_A_reg && red_op_B_reg) begin
                            out_exp = ^B_reg;                  
                        end else begin
                            out_exp = A_reg ^ B_reg;
                        end                
                end

                ADD: begin
                        out_exp = A_reg+B_reg+cin_reg;
                end

                MULT: begin
                        out_exp = A_reg*B_reg;
                end

                SHIFT: begin
                        if (direction_reg) out_exp = {out_exp[4:0], serial_in_reg};
                        else if (!direction_reg) out_exp = {serial_in_reg, out_exp[5:1]};    
                end

                ROTATE: begin
                        if (direction_reg) out_exp = {out_exp[4:0], out_exp[5]};
                        else if (!direction_reg) out_exp = {out_exp[0], out_exp[5:1]};
                end
                default: begin
                    out_exp = 'b0;
                end 
            endcase        
        end   
    end
        update_internals();
    endtask

    task reset_internals();
        cin_reg = 'b0;
        red_op_A_reg = 'b0;
        red_op_B_reg = 'b0;
        bypass_A_reg = 'b0;
        bypass_B_reg = 'b0;
        direction_reg = 'b0;
        serial_in_reg = 'b0;
        opcode_reg = OR;
        A_reg = 'b0;
        B_reg = 'b0;
    endtask

    task update_internals();
        cin_reg = cin;
        red_op_A_reg = red_op_A;
        red_op_B_reg = red_op_B;
        bypass_A_reg = bypass_A;
        bypass_B_reg = bypass_B;
        direction_reg = direction;
        serial_in_reg = serial_in;
        opcode_reg = opcode;
        A_reg = A;
        B_reg = B;
    endtask

    task check_validity(
        input red_op_A,red_op_B, opcode_e opcode,
        output isValid
    );
        case (opcode)
            INVALID_6,INVALID_7 : isValid = 0;

            ADD,MULT,SHIFT,ROTATE: begin
                if( red_op_A || red_op_B) isValid = 0;
                else isValid = 1;
            end

            default: isValid =1; 
        endcase

    endtask

    task check_result (
        input rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in,
        signed [2:0] A, B, opcode_e opcode
    );
        GoldenModel();
    
        @(negedge clk);    
        if((out == out_exp)&&(leds == leds_exp)) begin
            Correct_Count++;
        end
    
        else begin
            if (out != out_exp)
                $display("Time: %0t, Failed, out = %0h, Exected: %0h",$time,out, out_exp);
            
            else if (leds != leds_exp) 
                $display("Time: %0t, Failed, leds = %0h, Expected: %0h",$time,leds,leds_exp);

            Error_Count++;
            $stop; 
        end
    endtask
    
endmodule

