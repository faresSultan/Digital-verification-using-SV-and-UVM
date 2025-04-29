module DSP_tb ();
    logic [17:0] A,B,D;
    logic [47:0] C;
    logic rst_n,clk;
    logic [47:0] P;

    integer Error_Count, Correct_Count;

    DSP DUT (.*);

initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
    end
end

initial begin
    Error_Count = 0; Correct_Count = 0;

//DSP_1
     A = 1;B = 1; D = 1; C = 1;
    assert_reset;

//DSP_2
    repeat (25) begin
        A = $random;
        B = $random;
        D = $random;
        C = $random;
        check_result(A,B,D,C);
    end

    assert_reset;  // to complete the toggle coverage for rst_n signal

    $display("Error Count = %0d\n",Error_Count);
    $display("Correct Count = %0d\n",Correct_Count);
    $stop;
end
   

// Golden model
task DSP_Golden_Model(
      input [17:0] A,B,D,
      input [47:0] C,
      output [47:0] P_expected
);
    logic [17:0] adder_result;
    adder_result = B+D;
    P_expected = (adder_result * A)+C;
    
endtask 

// Tasks
task assert_reset ;

    rst_n = 0;
    @(negedge clk);   // check the reset of the Output register
    if (P != 'b0)
     begin
      $display("Reset failed");
      Error_Count++;   
    end
    else begin
        C = 0;
        rst_n = 1; // to allow inputs to propegate
         @(negedge clk);
         @(negedge clk);   // check the rest of internal registers  

         if (P !== 'b0)
         begin
            $display("Reset failed");
            Error_Count++;   
        end 
        else begin
             $display("Reset Passed");
             Correct_Count++;
        end
    end 
endtask 

task check_result (
        input [17:0] A,B,D,
        input [47:0] C
);
    logic [47:0] P_expected;

    DSP_Golden_Model(A,B,D,C,P_expected);

    @(negedge clk);
    @(negedge clk);
    @(negedge clk);
    @(negedge clk);

    if(P == P_expected) begin
        $display("Passed for A = %0h, B = %0h, D = %0h, C = %0h -> Expected Result = %0h",A,B,D,C,P_expected);
        Correct_Count++;
    end
    else begin
        $display("Time: %0t, Failed for A = %0h, B = %0h, D = %0h, C = %0h -> Expected Result = %0h, Result = %0h",
        $time, A,B,D,C,P_expected,P);

        Error_Count++;
        $stop;
    end
endtask

endmodule