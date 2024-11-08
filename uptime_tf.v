//  uptime_tf.v Uptime test fixture (TF) for module uptime.v
//
// fist number (1ns) is resolution of "#X". 2nd number simulation resolution
// Xilinx recommends uniform values below
`timescale 1ns / 1ps

module uptime_tf;
// Inputs (from view of uptime.v module!)
  reg rst;
  reg clk;
  wire tick_en;
  reg [3:0]ticks;

  parameter P_DIGITS = 3;

  wire [P_DIGITS*4-1:0]digits;

  assign tick_en = ( ticks >=3 && ticks <= 4 );

  // Instantiate the Unit Under Test (UUT)
  uptime #( P_DIGITS ) uut ( .rst (rst), .clk (clk), .tick_en (tick_en),
		.digits (digits));

  initial begin
    // Initialize Inputs
    rst = 0;
    clk = 0;
    ticks = 0;

    // Assert and release reset
    #4;
    rst = 1;
    #4;
    rst = 0;
    // Add stimulus here
    #20000;
    $finish;
  end

  always
    #1 ticks = ticks + 1;
  always
    #4 clk = ~ clk;
endmodule

