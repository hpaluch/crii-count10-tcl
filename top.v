`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer:  Henryk Paluch
// 
// Create Date:    11/08/2024
// Design Name:    4 digit Display decimal counter using flexible "uptime" module
// Module Name:    top
// Project Name:   crii-count10
// Target Devices: xc2c256-6TQ144
// Tool versions:  ISE 14.7
// Description: 
// * displays 4 digit Up decimal counter and also on LEDs
// * BTN0 (right button) to RESET counter
// * BTN1 (left button) to HOLD counter
//
// Revision  0.01 - cloned from my hexadecimal counter project
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
    input PCLK,       // on-board 8MHz clock, connected to GCK2 pin 
    input [1:0] BTN,  // on-board buttons
    output [3:0] LD,  // on-board LEDs
	 output [3:0] ANO,  // 4-digit display, common anodes
	 output [7:0] CAT   // 4-digit display, invidiual segments (catodes)
    );

reg [3:0] disp_mux;
assign ANO = disp_mux;

wire reset; // reset, active 1
assign reset = ~ BTN[0]; // BTN0 is RESET, but it is active 0 - using "~" operator

wire ce; // counter enable, active 1
assign ce = BTN[1]; // inverted logic: when BTN0 is pressed => ce=0 (counter stopped = HOLD)

wire clk; // 0.5 MHz clock

// we use integrated ClockDivider on XC2C256 chip
// to divide input 8MHz (from GCK2 pin) by 16 to 0.5Mhz
CLK_DIV16 U1 ( .CLKIN(PCLK), .CLKDV(clk) ); 

// counter used as timebase
reg [17:0] counter = 0;
reg tick = 0; // tick for displayed counter2

always @(posedge clk)
begin
	counter <= counter + 1;
	if ( counter == 0 )
		tick <= 1;
	else
		tick <= 0;
end


// BCD counter that will be displayed
parameter P_DIGITS = 4; // number of counted BCD digits (each takes 4 bits)
localparam TOTAL_BITS = P_DIGITS*4;
wire [TOTAL_BITS-1:0] digits;

wire tick_en;
assign tick_en = ce && tick;

uptime #( P_DIGITS ) inst1 ( .rst (reset), .clk (clk), .tick_en (tick_en),
                .digits (digits));

// display MUX handling
wire [1:0] muxin;
assign muxin = counter[12:11];

reg [3:0] muxed_counter2;

always @(muxin or digits)
begin
	case ( muxin )
		2'd0: begin disp_mux = 4'b1110; muxed_counter2 = digits[3:0]; end
		2'd1: begin disp_mux = 4'b1101; muxed_counter2 = digits[7:4]; end
		2'd2: begin disp_mux = 4'b1011; muxed_counter2 = digits[11:8]; end
		2'd3: begin disp_mux = 4'b0111; muxed_counter2 = digits[15:12]; end
	endcase
end

NUM_TO_DISP U2( .num( muxed_counter2 ), .segments( CAT ) );

// LED LD0-3 are "inverted": when grounded they are On. So using "~" operator:
assign LD[3:0] = ~ digits[3:0];

endmodule
// end of top module

// decode 4-bit number (0 to 15) to 7-segment display on CoolRunner II
//    A
//   F  B
//    G
//   E  C
//     D   DP
module NUM_TO_DISP(num, segments);
 input  [3:0] num;
 output [7:0] segments;
 reg [7:0] segments;

 always @( num )
 begin
  case ( num )       // PGFEDCBA
    4'h0: segments = 8'b11000000;
    4'h1: segments = 8'b11111001;
    4'h2: segments = 8'b10100100;
    4'h3: segments = 8'b10110000;
    4'h4: segments = 8'b10011001;
    4'h5: segments = 8'b10010010;
    4'h6: segments = 8'b10000010;
    4'h7: segments = 8'b11111000;
    4'h8: segments = 8'b10000000;
    4'h9: segments = 8'b10010000;
	 // values below unused for this decimal counter, but they can be
	 // someday useful
    4'ha: segments = 8'b10001000;
    4'hb: segments = 8'b10000011;
    4'hc: segments = 8'b11000110;
    4'hd: segments = 8'b10100001;
    4'he: segments = 8'b10000110;
    4'hf: segments = 8'b10001110;
  endcase
 end
endmodule
