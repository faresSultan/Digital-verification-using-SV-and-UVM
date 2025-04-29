////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Vending machine example
// 
////////////////////////////////////////////////////////////////////////////////
module vending_machine_sva(vending_machine_if v_if);
// 1. Add the modport above
// 2. Add the following 3 properties, then use assert property and cover property on each property
//// First Assertion: At each positive edge of the clock, if the D_in is high then at the same clock cycle, the dispense and the change outputs are high
//// Second Assertion: At each positive edge of the clock, If there is a rising edge for the input Q_in then after 2 clock cycles the dispense output is high
//// Third Assertion: At each positive edge of the clock, if the Q_in is high then at the same clock cycle, the change must be low


    property First_assertion;
        @(posedge clk) D_in |-> (dispense&&change);
    endproperty

    P1: assert property (First_assertion);

    property Second_assertion;
        @(posedge clk) $rose(Qin) |-> ##2 dispense;
    endproperty

    p2: assert property (Second_assertion);

endmodule








    property First_assertion;
        @(posedge clk) $rose(ٍSignal_a) |-> ##1 (Signal_b==0);
    endproperty

     P1: assert property (First_assertion);


property Second_Assertion;
    @(posedge clk) $rose(valid) |=> (wr_ack throughout done[->1])
endproperty

P2: assert property (Second_Assertion);




property ThirdAssertion_1;
    @(posedge clk) $rose(req) |=> ack;  
endproperty

property ThirdAssertion_2;
    @(posedge clk) ThirdAssertion_1 |=> 
endproperty