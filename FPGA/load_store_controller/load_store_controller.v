module load_store_controller (
  input [31:0] aluin,
  input [31:0] mrdin,
  input [31:0] inst,
  output [31:0] out,
  output [31:0] addr_out,
  output reg wr,
  output reg werf
);

wire [6:0] opcode;
reg [1:0] control;
reg load_store_immediate_select;

wire [31:0] addr_out;

assign opcode = inst[6:0];

x_bit_mux_4 #(.WIDTH(32)) control_unit (
  .a({inst[31:12], {12{0}}}), .b(), .c(), .d(aluin), .s0(control[0]), .s1(control[1]), .out(out)
);

always @ (opcode) begin
  case (opcode) 
    7'b0110111: begin
      werf <= 1;
      wr <= 0;
      control <= 2'b00;
    end
    7'b0000011: begin
      werf <= 1;
      wr <= 0;
      control <= 2'b01;
    end
    7'b0100011: begin
      werf <= 0;
      wr <= 1;
      control <= 2'b10;
    end
    7'b0010011: begin
      werf <= 1;
      wr <= 0;
      control <= 2'b11;
    end
    7'b0110011: begin
      werf <= 1;
      wr <= 0;
      control <= 2'b11;
    end
    default: begin
      werf <= 0;
      wr <= 0;
      control <= 2'b00;
  endcase
end

endmodule
