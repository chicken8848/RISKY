module mux_2 (a, b, s, out);

output out;
input a, b, s;

assign out=(s)?b:a;

endmodule
