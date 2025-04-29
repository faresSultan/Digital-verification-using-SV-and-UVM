

//=============Q2-1================
property P1;
    @(posedge clk) a |-> ##2 b;
endproperty
A1: assert property (P1)
    else $error("Assertion A1 failed!");


//=============Q2-2================
property P2;
    @(posedge clk) (a&&b) |-> ##[1:3] c;
endproperty
A2: assert property (P2)
    else $error("Assertion A2 failed!");

//=============Q2-3================
sequence s11b
    ##2 (b==0);
endsequence

//=============Q2-4A================
sequence Y_exp
    Y == (8'b0000_0001 ||8'b0000_0010 ||8'b0000_0100 ||8'b0000_1000 ||
          8'b0001_0000 ||8'b0010_0000 ||8'b0100_0000 ||8'b1000_0000 );
endsequence
property Y;
    @(posedge clk) Y_exp;
endproperty
Check_Y: assert property (Y)
    else $error("Assertion Check_Y failed!");

//=============Q2-4B================

property valid_check;
    @(posedge clk) (~|D) => !valid; 
endproperty

Check_vaild: assert property (valid_check)
    else $error("Assertion Check_vaild failed!");