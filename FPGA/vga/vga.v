module vga(
	input clk,
	input rst,
	output[9:0] x,
	output[9:0] y,
	output hsync,
	output vsync);

localparam H_RES = 640;
localparam H_FPORCH_LEN = 16;
localparam H_BPORCH_LEN = 48;
localparam H_SYNC_LEN = 96;
localparam H_ACT_BEGIN = 0;
localparam H_ACT_END = H_RES - 1;
localparam H_SYNC_BEGIN = H_ACT_END + H_FPORCH_LEN;
localparam H_SYNC_END = H_SYNC_BEGIN + H_SYNC_LEN;
localparam H_LAST_PIXEL = H_RES + H_FPORCH_LEN + H_BPORCH_LEN + H_SYNC_LEN - 1;

localparam V_RES = 480;
localparam V_FPORCH_LEN = 10;
localparam V_BPORCH_LEN = 33;
localparam V_SYNC_LEN = 2;
localparam V_ACT_BEGIN = 0;
localparam V_ACT_END = V_RES - 1;
localparam V_SYNC_BEGIN = V_ACT_END + V_FPORCH_LEN;
localparam V_SYNC_END = V_SYNC_BEGIN + V_SYNC_LEN;
localparam V_LAST_LINE = V_RES + V_FPORCH_LEN + V_BPORCH_LEN + V_SYNC_LEN - 1;

// Negative polarity
assign hsync = ~(x >= H_SYNC_BEGIN && x < H_SYNC_END);
assign vsync = ~(y >= V_SYNC_BEGIN && y < V_SYNC_END);

reg[9:0] x;
reg[9:0] y;
always @(negedge clk, posedge rst) begin
	if (rst) begin
		x <= 0;
		y <= 0;
	end else begin
		if (x == H_LAST_PIXEL) begin
			x <= 0;
			y <= (y == V_LAST_LINE) ? 0 : y + 1;
		end else begin
			x <= x + 1;
		end
	end
end

endmodule

