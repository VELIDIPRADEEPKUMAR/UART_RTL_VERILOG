

  module UART(input D,cry_clk,send,
              output [3:0] LED,
              output wire  [7:0] dig,
              output wire [3:0] sel,
				  output wire t_x);
				  
		 parameter E_P = 0;
		 parameter O_P = 1;
		 parameter P_1 = 2;
		 parameter P_0 = 3;
  
       wire [17:0] DATA;
		 wire L,clk;
		 
		 reg [3:0] 	BIN; 
		 reg [10:0] counter;
		 reg send_reg;
		 
		 ////////////////////////////////
		 clk clk1(cry_clk,clk);        // 5 MHz 
		 TX #(115200,P_1,8) TX1(DATA,send_reg,clk,t_x,LED[3:2]);
		 RX #(115200) RX1 (D,clk,DATA,L,LED[1:0]);
		 decoder D1(sel,counter[10:9]);
		 BCD_SSD S1(dig[6:0],BIN);
		 /////////////////////////////////
		 assign dig[7] = 1'b1;
       
       always@(posedge clk) counter <= counter + 1'b1;
		 always@(posedge counter[10]) send_reg <= send;
		 
		 /////////////// Select The 7-segment Display ///////////////
  always@(*)
  begin
    case(counter[10:9])
      2'b00    :
        BIN = DATA[3:0];
      2'b01    :
        BIN = DATA[7:4];
      2'b10    :
        BIN = DATA[12:9];
      2'b11    :
        BIN = DATA[16:13];
    endcase
  end
       
  
  
  endmodule 
  
  
  
  
  
  /// BCD TO SEVEN SEGMENT DISPLAY

module BCD_SSD( seg , bcd );

  //Declare inputs,outputs and internal variables.
  input [3:0] bcd;
  output reg [6:0] seg;

  //always block for converting bcd digit into 7 segment format
  always @(bcd)
  begin
    case (bcd) //case statement
      0 :
        seg = 7'b1000000;//7'gfedcba
      1 :
        seg = 7'b1111001;
      2 :
        seg = 7'b0100100;
      3 :
        seg = 7'b0110000;
      4 :
        seg = 7'b0011001;
      5 :
        seg = 7'b0010010;
      6 :
        seg = 7'b0000010;
      7 :
        seg = 7'b1111000;
      8 :
        seg = 7'b0000000;
      9 :
        seg = 7'b0010000;
      10:
        seg = 7'b0001000;//A
      11:
        seg = 7'b0000011;//b
      12:
        seg = 7'b1000110;//C
      13:
        seg = 7'b0100001;//D
      14:
        seg = 7'b0000100;//E
      15:
        seg = 7'b0001110;//F

    endcase
  end

endmodule


/// decoder
module decoder(output reg [3:0] out,
                 input [1:0] in    );

  always@(*)
  begin

    case(in)

      2'b00    :
        out = 4'b1110;
      2'b01    :
        out = 4'b1101;
      2'b10    :
        out = 4'b1011;
      2'b11    :
        out = 4'b0111;
    endcase
  end
endmodule
