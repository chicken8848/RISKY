module FrameBuffer #(
    parameter HEIGHT = 480,
    parameter WIDTH = 640
)(
    input wire clk,            // Clock input
    input wire vga_clk,
    input wire rst,            // Reset input
    input wire [31:0] game_data, // Game data input (pixel information)
    input wire [31:0] byte_mask,
    input wire [18:0] address,
    input wire [9:0] x,
    input wire [9:0] y,
    input wire r_en,
    input wire w_en,
    output reg [7:0] display_data // Data output to display
);


// Define memory size
localparam MEM_SIZE = WIDTH * HEIGHT; // VGA resolution

// Memory to store game graphics
reg [7:0] frame_buffer [MEM_SIZE - 1:0];

// writing to frame_buffer
always @(posedge clk) begin
    if (w_en) begin
    case(byte_mask)
        32'hFFFFFFFC: begin
        frame_buffer[address] <= game_data[7:0];
        frame_buffer[address + 1] <= game_data[15:8];
      end
        32'hFFFFFFF0: begin
        {frame_buffer[address + 3], frame_buffer[address + 2], frame_buffer[address + 1], frame_buffer[address]} <= game_data;
      end
        32'hFFFFFFFE: begin
        frame_buffer[address] <= game_data[7:0];
      end
    endcase
    end
end


// Read data from memory for display
always @(posedge vga_clk) begin
    if (rst) begin
        display_data <= 8'b00000000;
    end else if (r_en) begin
        display_data <= frame_buffer[y * WIDTH + x];
    end else begin
        display_data <= 8'b11111111;
    end
end
endmodule
