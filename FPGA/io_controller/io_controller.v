module io_controller (
  input [31:0] addr_in,
  input [31:0] data_in,
  input [31:0] ia,
  input wr,
  input [15:0] wr_mask,
  input clk,
  input reset,
  output irq
);
