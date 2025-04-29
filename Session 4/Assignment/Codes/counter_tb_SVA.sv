
module counter_sva(clk ,rst_n, load_n, up_down, ce, data_load, count_out, max_count, zero);
    parameter WIDTH = 4;
    input clk;
    input rst_n;
    input load_n;
    input up_down;
    input ce;
    input [WIDTH-1:0] data_load;
    input [WIDTH-1:0] count_out;
    input max_count;
    input zero;

    reg [WIDTH-1:0] count_out_prev;

    always @(posedge clk or negedge rst_n) begin
        count_out_prev <= count_out; 
    end

// //=============Reset immediate assertion===============
    // always @(negedge rst_n) begin
    //     Reset: assert (count_out === 'b0)
    //         else $error("Assertion Reset failed!");
    // end

    always_comb begin
        if(!rst_n) begin 
            Reset: assert final (count_out === 'b0)
            else $error("Assertion Reset failed!");
        end
    end

//=========Checking zero flag functionality=============

    property Zero;
      @(negedge clk) (count_out ==={ WIDTH{1'b0} }) |-> zero; 
    endproperty

    zero_flag_a: assert property (Zero)
        else $error("Assertion zero_flag failed!");
    
    zero_flag_c: cover property (Zero);
//=========Checking max flag functionality=============
  property Max;
    @(negedge clk) (count_out ==={ WIDTH{1'b1} }) |-> max_count;
  endproperty
    max_flag_a: assert property (Max)
      else $error("Assertion max_count_flag failed!");

    max_flag_c: cover property (Max);  

//================Load functionality====================
    property LoadData;
        @(negedge clk) (!load_n && rst_n) |-> (count_out == data_load);
    endproperty

    Load_a: assert property (LoadData)
        else $error("Assertion Load_a failed!");
    
    Load_c: cover property (LoadData);

//========no load or ce or rst => counter freeze=======

    property Counter_Freeze;
        @(negedge clk) (load_n && rst_n && !ce) |-> (count_out == count_out_prev);
    endproperty

    Counter_Freeze_a: assert property (Counter_Freeze)
        else $error("Assertion Counter_Freeze_a failed!");
    
    Counter_Freeze_c: cover property (Counter_Freeze);

//==============Increment functionality================
    sequence increment_en;
        load_n && rst_n && ce && up_down;
    endsequence
    property Increment;
        @(negedge clk) increment_en |-> (count_out == count_out_prev +1'b1);  // 1 only is 32 bit, causing error 
    endproperty
    
    Increment_a: assert property (Increment)
        else $error("Assertion Increment_a failed!");
    
    Increment_c: cover property (Increment);

//==============Decrement functionality================
    sequence decrement_en;
        (load_n && rst_n) && (ce==1) && (up_down==0);
    endsequence
    property Decrement;
        @(negedge clk) decrement_en |-> (count_out == count_out_prev - 1'b1); 
    endproperty

    decrement_a: assert property (Decrement)
        else $error("Assertion decrement_a failed!");

    Decrement_c: cover property (Decrement);

endmodule