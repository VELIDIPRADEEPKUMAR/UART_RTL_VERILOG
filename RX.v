/********************************************************
Auther       :-  velidi pradeep kumar 
date         :-  03/10/2021 
organization :-  IIITDM KANCHIPURAM
description  :-  This is the reciever code for UART communication 
**********************************************************/

  module RX #(parameter BAUT_RATE = 115200) (input D,clk,
                                             output reg [17:0] RX_DATA,
				                                 output L ,
				                                 output [1:0] LED);
				
				
				parameter RESET = 1'b0;
				parameter DATA  = 1'b1;
				parameter integer Delay = (5000000/BAUT_RATE); // (Delay*2) is the time in which we will wait, to read next 
				parameter  Bits  = $clog2(Delay);                                                       //                        data after a read operation. 
				
				reg [3:0] cnt;
				reg [Bits-1:0] timer;
				reg state;
				
				assign L = ~state;
				assign LED = {!state,state};
				
////////////// state meachine ///////////////////

          always@(posedge clk)
			 begin 
			 
			 case(state) 
			 
			 RESET   : begin 
			           cnt <= 4'b0;
			           if(D) begin state <= RESET; timer <= 'b0;end
						  else if(timer > Delay/2) begin state <= DATA; timer <= 'b0;end
						  else begin state <= RESET; timer <= timer + 1'b1;end
						  end
			 
			 DATA    : begin 
			           if(timer > Delay) 
						  begin 
						  if(cnt == 4'b1001) begin  state <= RESET; cnt <= 4'b0; timer <= 'b0; end
						  else begin RX_DATA <= {D,RX_DATA[17:1]}; state <= DATA; cnt <= cnt + 1'b1; timer <= 'b0; end
						  end
						  else begin state <= DATA; timer <= timer + 1'b1;end
						  end 
			 
			 endcase 
			 
			 end
			 
			 
endmodule 
			 