  
  module  TX #(parameter BAUD_RATE = 115200,PARITY = 0,DATA_LEN = 8)
  
                       ( input wire [DATA_LEN-1:0] DATA,
                           input send,clk,
					            output wire t_x,
									output [1:0] LED); 
																	
		      parameter RESET = 1'b0;
				parameter T  = 1'b1;
				parameter integer Delay = (5000000/BAUD_RATE); // (Delay*2) is the time in which we will wait, to read next 
				parameter  Bits  = $clog2(Delay); // data after a read operation. 
				parameter P_0 = 1'b0, P_1 = 1'b1;
				
				reg [3:0] cnt;
				reg [Bits-1:0] timer;
            reg state;
				reg T_send;
            reg [DATA_LEN + 1:0] message;
		
            wire E_P,O_P;       		
				assign LED = {!state,state};
			
		      assign t_x = state ? message[0] : 1'b1;   // output TX  buffer
																	
									
				always@(posedge clk)
				begin 
				
				case(state)
				RESET :begin 
				       if(!send)
						 begin
						  
						  if(T_send) 
						  begin
						   T_send <= 1'b0;
					      state <= T; 
							timer <= 'b0;
							cnt <= 'b0;
							message[0] <= 1'b0;            // load start condition
							message[DATA_LEN:1] <= DATA;   // read message 
							case(PARITY)                   // caliculate parity bit
							0: message[DATA_LEN+1] <= E_P; // even parity
					   	1: message[DATA_LEN+1] <= O_P; // odd parity
					      2: message[DATA_LEN+1] <= P_1; // bit 0
					      3: message[DATA_LEN+1] <= P_0; // bit 1
						   endcase
						  end
						  else 
						  begin
						   T_send <= 1'b0;
						   state <= RESET; 
							timer <= 'b0;
							cnt <= 'b0;
							message <= 'b0;
					     end		
						  
						 end
						 else 
						 begin 
						   T_send <= 1'b1;
                     state <= RESET; 
							timer <= 'b0;
							cnt <= 'b0;
							message <= 1'b0;  
						  end
						end
			T   : begin 
			        if(timer > Delay)
					      if(cnt==DATA_LEN+1)
							begin 
							state <= RESET;
							timer <= 'b0;
                     cnt <= cnt + 1'b1;
							end
							else 
							begin
					      message <= {1'b0,message[DATA_LEN+1:1]}; cnt <= cnt + 1'b1; timer <= 'b0; state <= T; 
							end
					  else 
					      begin
					      state <= T; timer <= timer + 1;
					      end
					end
				
				endcase
				
				end
				
endmodule
				