module keyboard_module (
  input clk,
  input reset,
  input ps2c,
  input ps2d,
  output [7:0] ascii_code 
);

wire casing;
wire [7:0] scan_code;
wire scan_code_ready;
wire [7:0] ascii;

keyboard kb0 (
  .clk(clk),
  .reset(reset),
  .ps2d(ps2d),
  .ps2c(ps2c),
  .scan_code(scan_code),
  .scan_code_ready(scan_code_ready),
  .letter_case_out(casing)
);

key2ascii ascii (
  .letter_case(casing),
  .scan_code(scan_code),
  .ascii_code(ascii)
);

