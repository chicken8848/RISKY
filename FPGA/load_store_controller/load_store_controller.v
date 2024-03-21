`include "../sign_extender/sign_extender.v"
`include "../muxes/x_bit_mux_2.v"
`include "../muxes/x_bit_mux_4.v"
`include "../muxes/x_bit_mux_8.v"

`include "../muxes/mux_2.v"
`include "../muxes/mux_4.v"
module load_store_controller (
  input [31:0] aluin,
  input [31:0] mrdin,
  input [31:0] inst,
  input [31:0] reg1_data, // mem addr
  input [31:0] reg2_data, // content to store
  input [31:0] pc,
  output [31:0] w_out,
  output [15:0] h_out,
  output [7:0] b_out,
  output [31:0] addr_out,
  output reg wr,
  output reg werf,
  output reg b_e,
  output reg h_e,
  output reg w_e
);

// declare load signals
wire [31:0] se_lb;
wire [31:0] se_lh;
wire [31:0] lw;
wire [31:0] load_out;
wire [31:0] w_imm;

wire [6:0] opcode;
wire [11:0] imm;
wire [2:0] funct3;
reg [1:0] control;
reg load_store_immediate_select;
reg jal_sel;

wire [31:0] se_imm;
wire [31:0] addr_out;

assign opcode = inst[6:0];
assign funct3 = inst[14:12];
assign lw = mrdin;
assign h_out = reg2_data[15:0];
assign b_out = reg2_data[7:0];


// Select immediate from the instruction
x_bit_mux_2 #(.WIDTH(12)) mux0 (.a(inst[31:20]), .b({inst[31:25], inst[11:7]}),
  .s(load_store_immediate_select), .out(imm));

// sign extend the immediate
sign_extender #(.WIDTH(32), .EXTENSION(20)) se0 (.imm(imm), .se_out(se_imm));

// sign extend LB
sign_extender #(.WIDTH(32), .EXTENSION(24)) se1 (.imm(mrdin[7:0]), .se_out(se_lb));
// sign extend LH
sign_extender #(.WIDTH(32), .EXTENSION(16)) se2 (.imm(mrdin[15:0]), .se_out(se_lh));

assign addr_out = se_imm + reg1_data;

// choose word out
x_bit_mux_4 #(.WIDTH(32)) control_unit (
  .a({inst[31:12], {12{1'b0}}}), .b(load_out), .c(reg1_data), .d(aluin), 
  .s0(control[0]), .s1(control[1]), .out(w_imm)
);
// implement JAL
x_bit_mux_2 #(.WIDTH(32)) jsel (.a(w_imm), .b(pc + d4), .s(jal_sel), .out(w_out));

// choose the load out
x_bit_mux_8 #(.WIDTH(32)) load_select (.a(se_lb), .b(se_lh), .c(lw), .d({32{1'b0}}), 
  .e({{24{1'b0}}, mrdin[7:0]}), .f({{16{1'b0}}, mrdin[15:0]}), .g({32{1'b0}}), 
  .h({32{1'b0}}), .s0(funct3[0]), .s1(funct3[1]), .s2(funct3[2]), .out(load_out));


always @ (opcode) begin
  case (opcode) 
    // LUI
    7'b0110111: begin
      jal_sel <= 0;
      werf <= 1;
      wr <= 0;
      control <= 2'b00;
      load_store_immediate_select <= 1'b0;
    end
    // L
    7'b0000011: begin
      jal_sel <= 0;
      werf <= 1;
      wr <= 0;
      control <= 2'b01;
      load_store_immediate_select <= 1'b0;
    end
    // S
    7'b0100011: begin
      jal_sel <= 0;
      werf <= 0;
      wr <= 1;
      control <= 2'b10;
      load_store_immediate_select <= 1'b1;
    end
    // ALUI
    7'b0010011: begin
      jal_sel <= 0;
      werf <= 1;
      wr <= 0;
      control <= 2'b11;
      load_store_immediate_select <= 1'b0;
    end
    // ALU
    7'b0110011: begin
      jal_sel <= 0;
      werf <= 1;
      wr <= 0;
      control <= 2'b11;
      load_store_immediate_select <= 1'b0;
    end
    7'b1101111: begin
      jal_sel <= 1'b1;
      werf <= 1'b1;
      wr <= 0;
      control <= 2'b00;
      load_store_immediate_select <= 1'b0;
    end
    7'b1100111: begin
      jal_sel <= 1'b1;
      werf <= 1'b1;
      wr <= 0;
      control <= 2'b00;
      load_store_immediate_select <= 1'b0;
    end
    default: begin
      jal_sel <= 0;
      werf <= 0;
      wr <= 0;
      control <= 2'b00;
      load_store_immediate_select <= 1'b0;
    end
  endcase

end

always @(funct3) begin
  case (funct3)
    3'b000: begin
      b_e <= 1;
      w_e <= 0;
      h_e <= 0;
    end
    3'b001: begin
      h_e <= 1;
      b_e <= 0;
      w_e <= 0;
    end
    3'b010: begin
      w_e <= 1;
      b_e <= 0;
      h_e <= 0;
    end
    3'b100: begin
      b_e <= 1;
      w_e <= 0;
      h_e <= 0;
    end
    3'b101: begin
      h_e <= 1;
      w_e <= 0;
      b_e <= 0;
    end
    default: begin
      h_e <= 0;
      w_e <= 0;
      b_e <= 0;
    end
  endcase
end



endmodule
