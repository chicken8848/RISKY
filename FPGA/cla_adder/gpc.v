module gpc (
  input gh,
  input ph,
  input gl,
  input pl,
  input cin,
  output ghl,
  output phl,
  output ch,
  output cl
);

  assign ghl = gh | (ph & gl);
  assign phl = ph & pl;
  assign ch = gl | (pl &cin);
  assign cl = cin;
endmodule
