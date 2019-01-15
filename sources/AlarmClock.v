`timescale 1ns / 1ps
/*
*** ELEC 3500 Lab 9 --Alarm Clock--
*** Caleb Gryfe && Chantel Lepage
*** Code Submission Date: 03/12/18
*/

module bcd(
input [3:0] A,
output CA,
output CB,
output CC,
output CD,
output CE,
output CF,
output CG);
reg [6:0] T;

assign CA = T[0];
assign CB = T[1];
assign CC = T[2];
assign CD = T[3];
assign CE = T[4];
assign CF = T[5];
assign CG = T[6];

always@(*)
    begin
        case(A)
            4'd0: T = 7'b1000000;
            4'd1: T = 7'b1111001;
            4'd2: T = 7'b0100100;
            4'd3: T = 7'b0110000;
            4'd4: T = 7'b0011001;
            4'd5: T = 7'b0010010;
            4'd6: T = 7'b0000010;
            4'd7: T = 7'b1111000;
            4'd8: T = 7'b0000000;
            4'd9: T = 7'b0010000;
        endcase
    end
endmodule



module alarmClock(
input CLK100MHZ,
input reset,
input fastCount,
input hourIncrement,
input minuteIncrement,
input alarmTimeSet,
input alarmSet,
input timeSet,
output [7:0] sevenSegment,
output [7:0] AN,
output [2:0] LED
);


reg [26:0] clock;
reg [26:0] clock2; // f=10Hz
reg [26:0] clock3; // f=5Mhz
reg [16:0] counter; // f=1Hz
reg [16:0] displayCounter;
reg [16:0] alarmCounter;
reg [16:0] tempCounter;
reg [3:0] LED_ON;

wire [5:0] seconds,minutes,hour;


wire [3:0] D0;
wire [3:0] D1;
wire [3:0] D2;
wire [3:0] D3;
wire [3:0] D4;
wire [3:0] D5;
wire [3:0] D6;
wire [3:0] D7;

wire CA;
wire CB;
wire CC;
wire CD;
wire CE;
wire CF;
wire CG;
assign sevenSegment[0]=CA;
assign sevenSegment[1]=CB;
assign sevenSegment[2]=CC;
assign sevenSegment[3]=CD;
assign sevenSegment[4]=CE;
assign sevenSegment[5]=CF;
assign sevenSegment[6]=CG;
assign sevenSegment[7]=0;

initial
        begin
            displayCounter <= 17'd3600;
            alarmCounter <= 17'd3600;
        end

always@(posedge CLK100MHZ) // 1Hz from 100MHz
    begin
        if(clock == 27'd99999999)
            clock <= 27'd0;
        else
            clock <= clock + 27'd1;
end

always@(posedge CLK100MHZ) // 100Hz from 100MHz
    begin
        if(clock2 == 27'd999999)
            clock2 <= 27'd0;
        else
            clock2 <= clock2 + 27'd1;
end

always@(posedge CLK100MHZ) // 5MHz from 100MHz
  begin
    if(clock3 == 27'd19) // 100M/20 = 5M
      clock3 <= 27'd0;
    else
      clock3 <= clock3 + 27'd1;
end

always @(posedge CLK100MHZ)

    begin
        if(reset)
            alarmCounter <= 17'd3600;
        begin
            if(clock == 27'd1)
                if(alarmCounter == 17'd86399)
                  begin
                    alarmCounter <= 17'd3600;

                  end
            else if(alarmTimeSet && hourIncrement)
        // Set alarm time -----------------------------------------------
           begin
             if((alarmCounter/3600)%60<24)
                   begin
                    if(alarmCounter >= 17'd43199)
                        alarmCounter <= alarmCounter - 17'd39600;
                    else
                        alarmCounter <= alarmCounter + 17'd3600;
                   end
           end

           else if(alarmTimeSet && minuteIncrement)
                  begin
                    if((alarmCounter % 17'd3540 == 0) && (alarmCounter != 17'd3600))
                        alarmCounter <= alarmCounter - 17'd3540;
                    else
                        alarmCounter <= alarmCounter + 17'd60;
                  end
          // End of Set alarm time ----------------------------------------
           else
                alarmCounter <= alarmCounter;

           end
    end



always @(posedge CLK100MHZ)
    begin

        if(reset)
        begin
            counter <= 17'd0;
            displayCounter <= 17'd3600;
            LED_ON[0] = 0;
            LED_ON[1] = 0;
            LED_ON[2] = 0;
         end

        else if(fastCount && timeSet)
            begin
           if (clock2 == 27'd1)
            if (counter == 17'd86399)
               begin
                counter <= 17'd0;
                displayCounter <= 17'd3600;
               end
            else
                begin
                 counter <= counter + 17'd1;
                 displayCounter = displayCounter + 17'd1;
                end

            else
                begin
                 counter <= counter;
                 displayCounter <= displayCounter;
                end
            end
           else

        begin

        if (clock == 27'd1)
            if (counter == 17'd86399)
                begin
                    counter <= 17'd0;
                    displayCounter <= 17'd3600;
                    tempCounter <= 17'd3600;
                    LED_ON[0] = 0;
                end

            else if(displayCounter == 17'd46799)
                begin
                    displayCounter <= 17'd3600;
                    LED_ON[0] = 1;
                end

         //if counter reacher 43199 (43199+1 / 60/60 = 12) set LED to on i.e. PM

        //Increment Minutes ----------------------------------------
         else if(timeSet && minuteIncrement)
            begin
                counter <= counter + 17'd60;
                displayCounter <= displayCounter + 17'd60;
                if((counter % 17'd3540 == 0) || (counter % 17'd3541 == 0) || (counter % 17'd3542 == 0)|| (counter % 17'd3543 == 0)|| (counter % 17'd3544 == 0)|| (counter % 17'd3545 == 0)|| (counter % 17'd3546 == 0)|| (counter % 17'd3547 == 0)|| (counter % 17'd3548 == 0)|| (counter % 17'd3549 == 0)|| (counter % 17'd3550 == 0)|| (counter % 17'd3551 == 0)|| (counter % 17'd3552 == 0)|| (counter % 17'd3553 == 0)|| (counter % 17'd3554 == 0)|| (counter % 17'd3555 == 0)|| (counter % 17'd3556 == 0)|| (counter % 17'd3557 == 0)|| (counter % 17'd3558 == 0)|| (counter % 17'd3559 == 0)|| (counter % 17'd3560 == 0)|| (counter % 17'd3561 == 0) || (counter % 17'd3562 == 0)|| (counter % 17'd3563 == 0)|| (counter % 17'd3564 == 0)|| (counter % 17'd3565 == 0)|| (counter % 17'd3566 == 0)|| (counter % 17'd3567 == 0)|| (counter % 17'd3568 == 0)|| (counter % 17'd3569 == 0)|| (counter % 17'd3570 == 0)|| (counter % 17'd3571 == 0)|| (counter % 17'd3572 == 0)|| (counter % 17'd3573 == 0)|| (counter % 17'd3574 == 0)|| (counter % 17'd3575 == 0)|| (counter % 17'd3576 == 0)|| (counter % 17'd3577 == 0)|| (counter % 17'd3578 == 0)|| (counter % 17'd3579 == 0)|| (counter % 17'd3580 == 0) || (counter % 17'd3581 == 0) || (counter % 17'd3582 == 0)|| (counter % 17'd3583 == 0)|| (counter % 17'd3584 == 0)|| (counter % 17'd3585 == 0)|| (counter % 17'd3586 == 0)|| (counter % 17'd3587 == 0)|| (counter % 17'd3588 == 0)|| (counter % 17'd3589 == 0)|| (counter % 17'd3590 == 0)|| (counter % 17'd3591 == 0)|| (counter % 17'd3592 == 0)|| (counter % 17'd3593 == 0)|| (counter % 17'd3594 == 0)|| (counter % 17'd3595 == 0)|| (counter % 17'd3596 == 0)|| (counter % 17'd3597 == 0)|| (counter % 17'd3598 == 0)|| (counter % 17'd3599 == 0)|| (counter % 17'd3600 == 0)&& (counter != 17'd0))
                    begin
                    counter <= counter - 17'd3540;
                    displayCounter <= displayCounter - 17'd3540;
                    end

            end

         //Increment Hours ----------------------------------------
         else if(timeSet && hourIncrement)
            if((counter/3600)%60<24)
                begin
                    counter <= counter + 17'd3600;
                    displayCounter <= displayCounter + 17'd3600;
                    if(counter >= 17'd39599)
                        begin
                            counter <= counter - 17'd39600;
                            displayCounter <= displayCounter - 17'd39600;
                            LED_ON[0] = !LED_ON[0];
                         end
                end

            else
                begin
                counter <= counter;
                displayCounter <= displayCounter;
                end

         //Increment at every clock edge
        else
            begin
             counter <= counter + 17'd1;
             displayCounter <= displayCounter + 17'd1;
            end

    end
        if(alarmSet && (alarmCounter == displayCounter))
                          begin
                            LED_ON[3] = 1;
                          end

         if(alarmSet)//if alarmSet switch on turn on LED 0
           LED_ON[1] = 1;
         else if(!alarmSet) //if alarmSet switch off disable alarm and lights
             begin
                 LED_ON[1] = 0;
                 LED_ON[2] = 0;
                 LED_ON[3] = 0;
             end

         //Toggle the alarm light when condition is met
         if(alarmSet && LED_ON[3]==1)
              LED_ON[2] = !LED_ON[2]; //Set LED_ON[2] = 1 for more consistent results
        // Toggle alarm end -------------------------------------

        if(alarmTimeSet) //If Alarm set is pressed the alarm time will display
           tempCounter <= alarmCounter;
         else
           tempCounter <= displayCounter;

end


assign seconds = tempCounter % 60;
assign minutes = (tempCounter/60) % 60;
assign hour = (tempCounter / 3600) % 60;

assign D0 = seconds % 10;
assign D1 = seconds / 10;
assign D2 = minutes % 10;
assign D3 = minutes / 10;
assign D4 = hour % 10;
assign D5 = hour / 10;
assign D6 = 4'd0;
assign D7 = 4'd0;
assign LED[0] = LED_ON[0];
assign LED[1] = LED_ON[1];
assign LED[2] = LED_ON[2];

display_driver d_d1(CLK100MHZ,reset,D7,D6,D5,D4,D3,D2,D1,D0,CA,CB,CC,CD,CE,CF,CG,AN);

endmodule
