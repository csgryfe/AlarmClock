`timescale 1ns / 1ps
/*
*** Standard Display Driver used in class
*** ELEC 3500 Lab 9 --Alarm Clock--
*** Caleb Gryfe && Chantel Lepage
*** Code Submission Date: 03/12/18
*/


module display_driver(
input CLK100MHZ,
input reset,
input [3:0] D7,
input [3:0] D6,
input [3:0] D5,
input [3:0] D4,
input [3:0] D3,
input [3:0] D2,
input [3:0] D1,
input [3:0] D0,
output CA,
output CB,
output CC,
output CD,
output CE,
output CF,
output CG,
output reg [7:0] AN);

reg [3:0] position;
reg [19:0] counter ;

always@(posedge CLK100MHZ)
    begin
        if(reset)
            counter <= 20'd0;
        else

        if(counter <= 20'd999999)
            counter <= counter + 20'd1;
        else
            counter <= 20'd0;
    end

always@(*)
    begin
        case(counter[19:17])
            3'd0: position = D0;
            3'd1: position = D1;
            3'd2: position = D2;
            3'd3: position = D3;
            3'd4: position = D4;
            3'd5: position = D5;
            3'd4: position = D6;
            3'd5: position = D7;
            default: position = 4'h0;
        endcase
end

always@(*)
    begin
        case(counter[19:17])
            3'd0: AN = 8'b11111110;
            3'd1: AN = 8'b11111101;
            3'd2: AN = 8'b11111011;
            3'd3: AN = 8'b11110111;
            3'd4: AN = 8'b11101111;
            3'd5: AN = 8'b11011111;
            3'd6: AN = 8'b10111111;
            3'd7: AN = 8'b01111111;

            default: AN = 8'b11111111;
        endcase
end

bcd BCD1(position,CA,CB,CC,CD,CE,CF,CG);

endmodule
