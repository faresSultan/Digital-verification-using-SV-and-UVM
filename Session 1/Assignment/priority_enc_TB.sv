module enc_tb ();

    logic clk;
    logic rst;
    logic [3:0] D;	
    logic [1:0] Y;	
    logic valid;

    integer Error_Count, Correct_Count;

    priority_enc DUT (.clk(clk),.rst(rst),.D(D),.Y(Y),.valid(valid));

    initial begin
        clk = 0;

        forever begin
            #1 clk = ~clk;
        end
    end


    initial begin

    Error_Count = 0;
    Correct_Count = 0;
    D = 'b0001;
    
    //ENC_1
    assert_reset;

    // ENC_2
    D = 'b0000;
    @(negedge clk);
    if (valid == 'b0) begin
        $display("Passed for D = 'b%0b",D);
        Correct_Count++;
    end
    else begin 
        $display("Passed for D = 'b%0b",D);
         Error_Count++;
    end

    //ENC_3
    D = 'b0001;
    check_result('b11,'b1);

    D = 'b0010;
    check_result('b10,'b1);

    D = 'b0011;
    check_result('b11,'b1);

    D = 'b0100;
    check_result('b01,'b1);

    D = 'b0101;
    check_result('b11,'b1);

    D = 'b0110;
    check_result('b10,'b1);

    D = 'b0111;
    check_result('b11,'b1);

    D = 'b1000;
    check_result('b00,'b1);

    D = 'b1001;
    check_result('b11,'b1);

    D = 'b1010;
    check_result('b10,'b1);

    D = 'b1011;
    check_result('b11,'b1);

    D = 'b1100;
    check_result('b01,'b1);

    D = 'b1101;
    check_result('b11,'b1);

    D = 'b1110;
    check_result('b10,'b1);

    D = 'b1111;
    check_result('b11,'b1);

    //ENC_4

    assert_reset; // rst : L->H & valid: H:L

    D = 'b0001;    // D[3]: H->L 
    check_result('b11,'b1);

    $display("Error Count: %0d", Error_Count);
    $display("Correct Count: %0d", Correct_Count);

    $stop;        
    end

    task assert_reset ;

    rst = 1;
    @(negedge clk);

    if ((Y != 'b0)|| (valid != 'b0))
     begin
      $display("Reset failed");
      Error_Count++;   
    end
    else begin
     $display("Reset Passed");
     Correct_Count++;
    end
    rst = 0;
    
endtask 

task check_result(logic [1:0] expected_Y, logic excpected_valid);

    @(negedge clk);

    if ((Y == expected_Y) && (valid == excpected_valid)) begin
        $display("Passed for D = 'b%0b",D);
        Correct_Count++;
    end
    else begin 
        $display("Passed for D = 'b%0b",D);
         Error_Count++;
    end
endtask 
    
endmodule


