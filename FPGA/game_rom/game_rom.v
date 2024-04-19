module game_rom(
    input clk,
    input [31:0] ia,
    output reg [31:0] game_data
  );
  
  always@(posedge clk) begin
    case(ia)
      

32'h0: game_data <= 32'hfe010113;
32'h4: game_data <= 32'h00812e23;
32'h8: game_data <= 32'h02010413;
32'hc: game_data <= 32'hfe042623;
32'h10: game_data <= 32'h0240006f;
32'h14: game_data <= 32'hfec42703;
32'h18: game_data <= 32'h100007b7;
32'h1c: game_data <= 32'h00f707b3;
32'h20: game_data <= 32'hfff00713;
32'h24: game_data <= 32'h00e78023;
32'h28: game_data <= 32'hfec42783;
32'h2c: game_data <= 32'h00178793;
32'h30: game_data <= 32'hfef42623;
32'h34: game_data <= 32'hfec42703;
32'h38: game_data <= 32'h000137b7;
32'h3c: game_data <= 32'hbff78793;
32'h40: game_data <= 32'hfce7dae3;
32'h44: game_data <= 32'h00000793;
32'h48: game_data <= 32'h00078513;
32'h4c: game_data <= 32'h01c12403;
32'h50: game_data <= 32'h02010113;
32'h54: game_data <= 32'h00008067;



      default: game_data <= 32'h0;
    endcase
  end
endmodule
