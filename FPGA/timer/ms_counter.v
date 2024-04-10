module ms_counter (
  input clk,
  output reg tick_out // tick_out on ms
);

reg [14:0] tick_counter;

always @(posedge clk) begin
  if (rst) begin
    tick_counter = 0;
    tick_out <= 0;
  end
  else if (tick_counter == 10000) begin
    tick_out <= 1'b1;
    tick_counter <= 0;
  end
  else begin
    tick_out <= 1'b0;
    tick_counter <= tick_counter + 1;
  end
end
endmodule

