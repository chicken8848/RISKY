module brancher (
  input [31:0] inst,
  input [31:0] pc,
  input [31:0] pc_4,
  input cmp_in,
  output [31:0] addr_out
);

wire [11:0] imm;
wire [31:0] offset;

assign imm[11] = inst[31];
assign imm[10] = inst[7];
assign imm[9:4] = inst[30:25];
assign imm[3:0] = inst[11:8];

sign_extender #(.WIDTH(32), .EXTENSION(20)) se0 (.imm(imm), .se_out(offset));

x_bit_mux_2 #(.WIDTH(32)) sel0 (
  .a(pc_4), .b(offset + pc), .s(cmp_in), .out(addr_out)
);
endmodule
