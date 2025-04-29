import Assignment3::*;

module ALSU_tb();

    bit clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    opcode_e opcode;
    bit signed [2:0] A, B;
    logic [15:0] leds,leds_exp;
    logic signed [5:0] out,out_exp;

    bit cin_reg, red_op_A_reg, red_op_B_reg, bypass_A_reg, bypass_B_reg, direction_reg, serial_in_reg;
    opcode_e opcode_reg;
    bit signed [2:0] A_reg, B_reg;
    opcode_e transitionPattern[6];

    int Error_Count,Correct_Count;

    ALSUconstraints constraintVals = new;

    ALSU DUT (.*);

    //---clk generation
    initial begin
         clk = 0;
        forever begin
            constraintVals.clk = clk;
            #1 clk = !clk;
        end
    end

    always @(negedge rst or negedge bypass_A or negedge bypass_B ) begin
        
        if(!(rst || bypass_A || bypass_B)) constraintVals.CovCode.start();
        else constraintVals.CovCode.stop();
    end

    always @(posedge rst or posedge bypass_A or posedge bypass_B ) begin
        constraintVals.CovCode.stop();
    end

    always @(posedge clk) begin
       if(!(rst || bypass_A || bypass_B)) constraintVals.CovCode.sample();
    end  

    initial begin
        Error_Count = 0;
        Correct_Count = 0;

    //--ALSU1
        assert_reset;

    // ALSU 2,3,4,5
    
//========= LOOP1: opcode sequence constraint disabled, all others enabled =========

        constraintVals.OpcodeSequence.constraint_mode(0);
        constraintVals.ALSUsignals.constraint_mode(1);  

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
                check_result();
            end
        end
            red_op_A = 1;
            red_op_B = 1;
            check_result();

            // directed case to complete code coverage
            bypass_A = 1;
            bypass_B = 1;
            check_result();

//========= LOOP2: opcode sequence constraint Enabled, all others Disabled =========


        constraintVals.OpcodeSequence.constraint_mode(1); 
        constraintVals.ALSUsignals.constraint_mode(0); 
        rst = 0;
        red_op_A = 0;
        red_op_B = 0;
        bypass_A = 0;
        bypass_B = 0;
		
		

        repeat (100) begin
                assert (constraintVals.randomize());
                cin = constraintVals.cin;
                direction = constraintVals.direction;
                serial_in = constraintVals.serial_in;
                A = constraintVals.A;
                B = constraintVals.B;

                foreach (constraintVals.opcode_sequence[i]) begin
                    opcode = constraintVals.opcode_sequence[i];

                    check_result();
                end
        end
        
//====== Directed Test case to complete functional coverage(opcode transition)
        transitionPattern = '{OR, XOR, ADD, MULT, SHIFT, ROTATE};
		constraintVals.rst = 0;
				constraintVals.red_op_A = 0;
				constraintVals.red_op_B = 0;
				constraintVals.bypass_A = 0;
				constraintVals.bypass_B = 0;
			
            foreach (transitionPattern[i]) begin
                opcode = transitionPattern[i];
                constraintVals.opcode = opcode;
				$display("Opcode = %0s ",constraintVals.opcode); 
                check_result();
            end

        $display("Correct Count: %0d",Correct_Count);
        $display("Error Count: %0d", Error_Count);
        $stop;  

    end




//============================ Tasks ==============================

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

    task check_result ();
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