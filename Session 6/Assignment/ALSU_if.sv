     typedef enum logic [2:0]  { 
        OR = 3'b00,
        XOR = 3'b001,
        ADD = 3'b010,
        MULT = 3'b011,
        SHIFT = 3'b100,
        ROTATE = 3'b101,
        INVALID_6 = 3'b110,
        INVALID_7 = 3'b111
     } opcode_e;

interface ALSU_if(input bit clk);
    
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";
    logic cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    logic [2:0] opcode;
    logic signed [2:0] A, B;
    logic [15:0] leds;
    logic signed [5:0] out;

    modport monitor (
        input clk, cin, rst, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in,
        opcode,A,B,leds,out
        );

endinterface