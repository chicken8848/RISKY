module jumper (
  input [31:0] pc,
  input [31:0] inst,
  input [31:0] reg1_data,
  output [31:0] addr_out
);

wire [6:0] opcode;

wire [31:0] imm;
reg imm_sel;
reg reg_sel;
wire [31:0] reg_orpc;

wire [19:0] jal_imm;
wire [11:0] jalr_imm;
wire [31:0] se_jal_imm;
wire [31:0] se_jalr_imm;

assign jal_imm = {inst[31], inst[19:12], inst[20], inst[30:21]};
assign jalr_imm = inst[31:20];

// sign extenders
sign_extender #(.WIDTH(32), .EXTENSION(12)) jal_extender (.imm(jal_imm), .se_out(se_jal_imm));
sign_extender #(.WIDTH(32), .EXTENSION(20)) jalr_extender (.imm(jalr_imm), .se_out(se_jalr_imm));

x_bit_mux_2 #(.WIDTH(32)) imm_mux (.a(se_jalr_imm), .b(se_jal_imm), .s(imm_sel),.out(imm));
x_bit_mux_2 #(.WIDTH(32)) regpc_sel (.a(reg1_data), .b(pc), .s(reg_sel), .out(reg_orpc));

assign addr_out = imm + reg_orpc;

always @(opcode) begin
  case(opcode)
    7'b1100111: begin
      imm_sel <= 0;
      reg_sel <= 0;
    end
    7'b1101111: begin
      imm_sel <= 1;
      reg_sel <= 1;
    end
  endcase
end

endmodule
