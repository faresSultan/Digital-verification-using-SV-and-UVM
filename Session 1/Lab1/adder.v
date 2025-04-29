module adder(
    input clk,reset,
    input signed [3:0] A,B,
    output reg signed [4:0] C
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            C <= 5'b0;
        else 
            C <= A + B;
    end
endmodule