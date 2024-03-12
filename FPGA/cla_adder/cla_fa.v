module cla_fa (
  input a,
  input b,
  input cin,
  output s,
  output p,
  output g
);

 assign s = a^b^cin;
 assign p = a^b;
 assign g = a&b;

endmodule
