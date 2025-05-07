module ALSU_SVA(ALSU_if IF);

    wire invalid,invalid_opcode,invalid_red_op;

    assign invalid_red_op = (IF.red_op_A | IF.red_op_B) & (IF.opcode[1] | IF.opcode[2]);
    assign invalid_opcode = IF.opcode[1] & IF.opcode[2];
    assign invalid = !IF.rst && (invalid_red_op | invalid_opcode);

    always_comb begin
        if(IF.rst) begin 
            Reset: assert final ((IF.out === 'b0) && (IF.leds === 'b0))
            else $error("Assertion Reset failed!");
        end
    end

//=================================sequences===========================================

    sequence Shift_Left;
        (IF.opcode == 'b100) && IF.direction;
    endsequence

    sequence Shift_Right;
        (IF.opcode == 'b100) && !IF.direction;
    endsequence

    sequence Rotate_Left;
        (IF.opcode == 'b101) && IF.direction;
    endsequence

    sequence Rotate_Right;
        (IF.opcode == 'b101) && !IF.direction;
    endsequence
//=================================Properties===========================================
    property Invalid_stimulus_leds_exp;
        @(posedge IF.clk) disable iff(IF.rst) (invalid) |=> ##1 IF.leds == ~$past(IF.leds,1); 
    endproperty

    property Invalid_stimulus_out_exp; //**** 
        @(posedge IF.clk) disable iff(IF.rst || IF.bypass_A || IF.bypass_B)
            (invalid) |=> ##1 IF.out === 3'b000; 
    endproperty

    property valid_stimulus;
        @(posedge IF.clk) !(invalid) |=> ##1 IF.leds == 0; 
    endproperty

    property bypass_A_feature;
        @(posedge IF.clk) 
            disable iff(IF.rst) 
                IF.bypass_A |=> ##1 IF.out == $past(IF.A,2); 
    endproperty

    property bypass_B_feature;
        @(posedge IF.clk)
            disable iff(IF.rst || IF.bypass_A) 
                IF.bypass_B |=> ##1 IF.out == $past(IF.B,2); 
    endproperty

    property redOR_A_feature;
        @(posedge IF.clk)
             disable iff(IF.rst || IF.bypass_A || IF.bypass_B)
                IF.opcode =='b000 && IF.red_op_A |=> ##1 IF.out == |$past(IF.A,2); 
    endproperty

    property redXOR_A_feature;
        @(posedge IF.clk)
             disable iff(IF.rst || IF.bypass_A || IF.bypass_B)
                IF.opcode =='b001 && IF.red_op_A |=> ##1 IF.out == ^$past(IF.A,2); 
    endproperty

    property redOR_B_feature;
        @(posedge IF.clk) 
            disable iff(IF.rst || IF.bypass_A || IF.bypass_B) 
                IF.opcode =='b000 && !IF.red_op_A && IF.red_op_B |=> ##1 IF.out == |$past(IF.B,2); 
    endproperty

    property redXOR_B_feature;
        @(posedge IF.clk)
             disable iff(IF.rst || IF.bypass_A || IF.bypass_B) 
                IF.opcode =='b001 && !IF.red_op_A && IF.red_op_B |=> ##1 IF.out == ^$past(IF.B,2);  
    endproperty

    property normalOR_feature;
        @(posedge IF.clk)
             disable iff(IF.rst || IF.bypass_A || IF.bypass_B) 
                IF.opcode =='b000 && !IF.red_op_A && !IF.red_op_B |=> ##1 IF.out == $past(IF.A,2) | $past(IF.B,2); 
    endproperty

    property normalXOR_feature;
        @(posedge IF.clk)
             disable iff(IF.rst || IF.bypass_A || IF.bypass_B) 
                IF.opcode =='b001 && !IF.red_op_A && !IF.red_op_B |=> ##1 IF.out == $past(IF.A,2) ^ $past(IF.B,2); 
    endproperty

    property ADD_feature;
        @(posedge IF.clk) 
            disable iff (IF.rst || IF.bypass_A || IF.bypass_B || invalid)
                (IF.opcode == 'b010) |=> ##1 (IF.out == ($past(IF.A,2) + $past(IF.B,2) + $past(IF.cin,2)));
    endproperty

    property Multiply_feature;
        @(posedge IF.clk) 
            disable iff(IF.rst || IF.bypass_A || IF.bypass_B || invalid) 
                IF.opcode == 'b011 |=> ##1 IF.out == $past(IF.A,2) * $past(IF.B,2); 
    endproperty

    property Shift_Left_feature;
        @(posedge IF.clk) 
            disable iff(IF.rst || IF.bypass_A || IF.bypass_B || invalid) 
                Shift_Left |-> ##2 IF.out == $past({IF.out[4:0],IF.serial_in},1); 
    endproperty

    property Shift_Right_feature;
        @(posedge IF.clk) 
            disable iff(IF.rst || IF.bypass_A || IF.bypass_B || invalid)
                Shift_Right |=> ##1 IF.out == $past({IF.serial_in, IF.out[5:1]},2); 
    endproperty

    property Rotate_Left_feature;
        @(posedge IF.clk) 
            disable iff(IF.rst || IF.bypass_A || IF.bypass_B || invalid) 
                Rotate_Left |=> ##1 IF.out == $past({IF.out[4:0],IF.out[5]},2); 
    endproperty

    property Rotate_Right_feature;
        @(posedge IF.clk) 
            disable iff(IF.rst || IF.bypass_A || IF.bypass_B || invalid) 
                Rotate_Right |=> ##1 IF.out == {$past(IF.out[0],2), $past(IF.out[5:1],2)}; 
    endproperty
//=================================Assert Properties===========================================

    invalid_stimulus_leds_exp: assert property (Invalid_stimulus_leds_exp)
        else $fatal("Assertion Invalid_stimulus_leds_exp failed!");
    cover property (Invalid_stimulus_leds_exp);

    invalid_stimulus_out_exp: assert property(Invalid_stimulus_out_exp)
        else $fatal("Assertion Invalid_stimulus_out_exp failed!");
    cover property(Invalid_stimulus_out_exp);
    
    Valid_stimulus: assert property (valid_stimulus)
        else $fatal("Assertion valid_stimulus failed!");
    cover property(valid_stimulus);

    Bypass_A_feature: assert property (bypass_A_feature)
        else $fatal("Assertion bypass_A_feature failed!");
    cover property(bypass_A_feature);

    Bypass_B_feature: assert property (bypass_B_feature)
        else $fatal("Assertion bypass_B_feature failed!");
    cover property(bypass_B_feature);

    RedOR_A_feature: assert property (redOR_A_feature)
        else $fatal("Assertion redOR_A_feature failed!");
    cover property(redOR_A_feature);
    
    RedXOR_A_feature: assert property (redXOR_A_feature)
        else $fatal("Assertion redXOR_A_feature failed!");
    cover property(redXOR_A_feature);

    RedOR_B_feature: assert property (redOR_B_feature)
        else $fatal("Assertion redOR_B_feature failed!");
    cover property(redOR_B_feature);

    RedXOR_B_feature: assert property (redXOR_B_feature)
        else $fatal("Assertion redXOR_B_feature failed!");
    cover property(redXOR_B_feature);

    NormalOR_feature: assert property (normalOR_feature)
        else $fatal("Assertion normalOR_feature failed!");
    cover property(normalOR_feature);

    NormalXOR_feature: assert property (normalXOR_feature)
        else $fatal("Assertion normalXOR_feature failed!");
    cover property(normalXOR_feature);
    
    add_feature: assert property (ADD_feature)
        else $fatal("Assertion ADD_feature failed!");
    cover property(ADD_feature);

    multiply_feature: assert property (Multiply_feature)
        else $fatal("Assertion Multiply_feature failed!");
    cover property(Multiply_feature);

    shift_Left_feature: assert property (Shift_Left_feature)
    $display("Shift passed ,Time:%0t",$time);
        else $fatal("Assertion Shift_Left_feature failed!");
    cover property(Shift_Left_feature);

    shift_Right_feature: assert property (Shift_Right_feature)
        else $error("Assertion Shift_Right_feature failed!");
    cover property(Shift_Right_feature);
    
    rotate_Left_feature: assert property (Rotate_Left_feature)
        else $fatal("Assertion Rotate_Left_feature failed!");
    cover property(Rotate_Left_feature);
    
    rotate_Right_feature: assert property (Rotate_Right_feature)
        else $error("Assertion Rotate_Right_feature failed!");
    cover property(Rotate_Right_feature);
    
endmodule


// module rtl (
// 	input logic clk, reset, request, ack, 
// 	input logic[7:0] data_in, 
// 	output logic[7:0] data_out);
// 	timeunit 1ns;   timeprecision 100ps;
// 	logic done;  // done is to test_rtl 
// 	// .. 
// endmodule : rtl

// checker handshake_chk (input logic clk, reset_n, request, ack, done);
// 	timeunit 1ns;   timeprecision 100ps;
// 	//..
//   	property p_req_ack (clk, a, b, c);
// 		@ (posedge clk) $rose(a) |-> ##[1:2] b ##1 c; 
// 	endproperty : p_req_ack
	
// 	ap_req_ack : assert property  (p_req_ack(clk, request, ack, done)) else 
// 		$display ("%m 1 Request-acknowledge failure");
// endchecker : handshake_chk

// interface req2send_if (input bit clk, reset_n);
//   timeunit 1ns; timeprecision 100ps;
//   logic request, ack, done; // signals belonging to interface
//   logic [7:0] source_data, data_out; // signals belonging to interface
//   // Define a clocking for the properties and IO ports
//   clocking reqclk @(posedge clk);
//     input ack, data_out, done;
//     output request, source_data;
//   endclocking : reqclk
//   // Define port direction for a module that sends data
//   modport sendmode_if (output ack, data_out, done,
//             input request, source_data);

// endinterface : req2send_if

        
// module test3_tb;
// 	timeunit 1ns;   timeprecision 100ps;
// 	logic clk, reset_n, request, ack; // signals local to testbench 
// 	logic[7:0] data_in, data_out;
//     req2send_if req2send_if1 (.*);
    
//     	// perform 2 instantiations of test_rtl, using 2 styles 
// 	rtl rtl_1(clk, reset, request, ack, data_in, data_out);
// 	rtl rtl_2(.*);
  
// 	bind req2send_if // interface 
// 	  handshake_chk     // cheker containing the properties
// 	  handshake_chk_1(.*); // instance of handshake_chk that contains the properties.
// endmodule : test3_tb

