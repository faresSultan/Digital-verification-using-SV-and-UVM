import Assignment3::*;


module counter_tb();
    
    CounterConstraints constraintVals = new;
    parameter WIDTH = constraintVals.WIDTH;
    
    bit clk, rst_n, load_n, up_down, ce;
    bit [WIDTH-1:0] data_load;
    logic [WIDTH-1:0] count_out;
    logic max_count;
    logic zero;
    int Error_Count,Correct_Count;

    counter#(.WIDTH(WIDTH)) DUT (.*);
    
//---clk generation
    initial begin
         clk = 0;
        forever begin
            constraintVals.clk = clk;
            #1 clk = !clk;
        end
    end

    initial begin

        Error_Count = 0;
        Correct_Count = 0;

    //--Counter1
        load_n = 0;
        data_load = 'hf;
        assert_reset;   

    //--Counter2,3,4,5,6   

        repeat(1000) begin
            assert (constraintVals.randomize());
            rst_n = constraintVals.rst_n;
            load_n = constraintVals.load_n;
            ce = constraintVals.ce;
            up_down = constraintVals.up_down;
            data_load = constraintVals.data_load;

            check_result(rst_n, ce,load_n,up_down,data_load);
        end

        // directed test to complete functional coverage (load zero to the counter)
            rst_n = 1;
            constraintVals.rst_n = rst_n;
            load_n = 0;
            constraintVals.load_n = load_n;
            data_load = 0;
            constraintVals.data_load = data_load;
            check_result(rst_n, ce,load_n,up_down,data_load); 

        $display("Correct Count: %0d",Correct_Count);
        $display("Error Count: %0d", Error_Count);
        $stop;  
    end

    task assert_reset ;
    rst_n = 0;
    @(negedge clk);   
    if ((count_out != 'b0)&&(zero != 1'b1))begin
        $display("Reset failed");
        Error_Count++;   
    end
    else begin
        $display("Reset Passed");
        Correct_Count++;
    end 
    rst_n = 1;
    @(negedge clk);
    endtask 

    task GoldenModel(
        input rst_n, ce,load_n,up_down,[WIDTH-1:0] data_load,
        output zero,max_count,[WIDTH-1 : 0]count_out
    );
        if (rst_n == 0) begin
            max_count = 0;
            count_out = 'b0;
        end

        else if (load_n == 0) count_out = data_load;

        else if (ce) begin
            if(up_down == 1) count_out = count_out + 1;
            else count_out = count_out - 1; 
        end

        if (count_out == 0) zero = 1;
        else zero = 0;

        if (count_out == {WIDTH{1'b1}}) max_count = 1; 
        else max_count = 0;


    endtask

    task check_result (
        input rst_n, ce,load_n,up_down,[WIDTH-1:0] data_load
    );
        logic zero_expected,max_count_expected;
        logic [WIDTH-1:0] count_out_expected;

        GoldenModel(
            rst_n, ce,load_n,up_down,data_load,
            zero_expected,max_count_expected,count_out_expected
        );

        @(negedge clk);

        constraintVals.count_out = count_out;
        if((count_out == count_out_expected)&&(zero == zero_expected)&&(max_count == max_count_expected)) begin
            Correct_Count++;
        end

        else begin
            if (zero != zero_expected)
                $display("Time: %0t, Failed for Zero flag",$time);

            else if (max_count != max_count_expected) 
                $display("Time: %0t, Failed for max_count flag, count_out= %0h",$time,count_out);

            else if (count_out != count_out_expected) 
                $display("Time: %0t, Failed for count_out, Expected: %0b, Result: %0b",$time, count_out_expected,count_out);

            Error_Count++;
            $stop; 
        end
    endtask
endmodule