`timescale 1ns / 1ps
/*
*** Standard Display Decoder used in class
*** ELEC 3500 Lab 9 --Alarm Clock--
*** Caleb Gryfe && Chantel Lepage
*** Code Submission Date: 03/12/18
*/


module displaydecoder(reset, bcd_in, displayOutput);
  input reset;
  input [3:0]bcd_in;
  output reg [6:0]displayOutput;
  always @(posedge reset, bcd_in)

  begin
    if(reset==1)
      displayOutput = 7'b0000001;
    else
      case(bcd_in)
        4'd0: displayOutput = 7'b1111110;
        4'd1: displayOutput = 7'b0110000;
        4'd2: displayOutput = 7'b1101101;
        4'd3: displayOutput = 7'b1111001;
        4'd4: displayOutput = 7'b0110011;
        4'd5: displayOutput = 7'b1011011;
        4'd6: displayOutput = 7'b1011111;
        4'd7: displayOutput = 7'b1110000;
        4'd8: displayOutput = 7'b1111111;
        4'd9: displayOutput = 7'b1111011;
        default: displayOutput = 7'b0000001;
      endcase
    end
  endmodule
