`include "../"

module cpu (
  input [31:0] id,
  input [31:0] mrd,
  input irq,
  input clk,
  output [31:0] ia,
  output wr,
  output [31:0] data_out,
  output reg_data_2,


)
