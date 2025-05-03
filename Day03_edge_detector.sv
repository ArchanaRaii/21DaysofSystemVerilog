//edge detector module
module day3 (
  input     wire    clk,
  input     wire    reset,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);
  
  logic a_out;
  
  always_ff @(posedge clk or posedge reset)
    begin
    	if(reset)
      	a_out <= 1'b0;
      else
        a_out <= a_i;
    end
  
  assign rising_edge_o = a_i & ~a_out;
  
  assign falling_edge_o = ~a_i & a_out;

endmodule

//edge detector tb module
module day3_tb ();

	logic    clk;
  logic    reset;

  logic    a_i;

  logic    rising_edge_o;
  logic    falling_edge_o;
  
  day3 dut(.clk(clk),
           .reset(reset),
           .a_i(a_i),
           .rising_edge_o(rising_edge_o),
           .falling_edge_o(falling_edge_o)
          );
  
  initial begin
    clk = 1'b0; reset = 1'b1; a_i = 2'b00; #10;
    reset = 1'b0; a_i = 2'b01; #10;
    a_i = 2'b10; #10;
    a_i = 2'b11; #10;
    a_i = 2'b00; #10;
    $finish();
  end
  
  always #5 clk = ~clk;

endmodule
