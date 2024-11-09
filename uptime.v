`timescale 1ns / 1ps
// uptime.v - simple module to track system uptime (decimal counter) as BCD
// digits (for easy printing on Display or on UART).
// Used in both Simulation and Implementation mode.
// SPDX-License-Identifier: MIT

// Tested environments:
// 1. Xilinx ISE WebPack 14.7, XC2C256-7-TQ144, Digilent CoolRunner II
// 2. Vivado 2015.1 Standard, xc7a200tfbg676-2, AC701 Eval Kit

module uptime(rst, clk, tick_en, digits);
// customizable parameter - number of BCD digits for uptime
parameter P_DIGITS = 3;
// non customizable parameter
localparam BITS_PER_DIGIT = 4;
localparam TOTAL_BITS = P_DIGITS * BITS_PER_DIGIT;
// input parameters
input rst; // RESET - Active=1
input clk; // Clock - Active Positive Edge
input tick_en; // Uptime tick (related to clk), Active=
// output parameters
// uptime ticks as BCD digits (4-bit per digit)
output [TOTAL_BITS-1:0] digits;
// variables
reg [TOTAL_BITS-1:0] digits = {TOTAL_BITS{1'b0}};

genvar ii;
// "carry" when specific BCD digit overflows and needs adjustemnt
// using bits to prepare for generate code
wire [P_DIGITS-1:0]c;
assign c[0] = ( digits[3:0] == 4'h9 );

// we will generate following expressions
//   assign c[1] = c[0] && ( digits[7:4] == 4'h9 );
//   assign c[2] = c[1] && ( digits[11:8] == 4'h9 );
//   ...
generate
  begin: assign_carry
    for (ii = 1; ii<P_DIGITS; ii=ii+1) begin: gen_dec_carry
        assign c[ii] = c[ii-1] && ( digits[ (ii*BITS_PER_DIGIT+3) : ii*BITS_PER_DIGIT ] == 4'h9 );
    end
  end
endgenerate


// increment BCD counter with overflow corrections
function [TOTAL_BITS-1:0] fn_inc_bcd;
input [TOTAL_BITS-1:0] digits; // all BCD digits
input [P_DIGITS-1:0]c;  // BCD overlofw (carry)
begin
      fn_inc_bcd = digits + 1;
      begin : INC_BCD_FUNCTION
         integer i;
         for(i = 0; i< P_DIGITS; i = i + 1)
         begin
            // function below basically unrolls this expression (example for P_DIGIT = 3):
            //  digits <= digits + 1 + c[0] * 6 + c[1] * (6 << 4) + c[2] * ( 6 << 8);
            fn_inc_bcd = fn_inc_bcd + c[i] * (6 <<  ((i) * BITS_PER_DIGIT)) ;
         end
      end
   end
endfunction

always @(posedge clk) begin
    if (rst) begin
        digits <= {TOTAL_BITS{1'b0}};
    end
    else if (tick_en) begin
        // We have to make BCD corrections, instead of +1 ( 0x9 => 0xa ) we need +7 (0x9 => 0x10)
        // function below basically unrolls this expression (example for P_DIGIT = 3):
        //  digits <= digits + 1 + c[0] * 6 + c[1] * (6 << 4) + c[2] * ( 6 << 8);
        digits <= fn_inc_bcd( digits, c );
    end
end

endmodule // uptime

