module multiplier #(
  BITS = 8
) (
  input [BITS-1:0] a,
  input [BITS-1:0] b,
  output [BITS-1:0] out
);

wire final_b = b[BITS-1] ? 
