module day1 (
  input   wire [7:0]    a_i,
  input   wire [7:0]    b_i,
  input   wire          sel_i,
  output  wire [7:0]    y_o
);

assign y_o = sel_i ? b_i : a_i; 

endmodule

module day1_tb ();
  logic [7:0] a_i;
  logic [7:0] b_i;
  logic sel_i;
  logic [7:0] y_o;
  
  day1 dut(.a_i(a_i),
           .b_i(b_i), 
           .sel_i(sel_i), 
           .y_o(y_o)
          );
  
  initial begin
    sel_i = 0; a_i = 8'h0; b_i = 8'h0; #10;
    sel_i = 0; a_i = 8'h0; b_i = 8'h1; #10;
    sel_i = 0; a_i = 8'h1; b_i = 8'h0; #10;
    sel_i = 0; a_i = 8'h1; b_i = 8'h1; #10;
    sel_i = 1; a_i = 8'h0; b_i = 8'h0; #10;
    sel_i = 1; a_i = 8'h0; b_i = 8'h1; #10;
    sel_i = 1; a_i = 8'h1; b_i = 8'h0; #10;
    sel_i = 1; a_i = 8'h1; b_i = 8'h1 ;
    $finish;
  end
  
endmodule
