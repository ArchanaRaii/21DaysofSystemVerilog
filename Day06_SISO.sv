module day6 (
  input     wire        clk,
  input     wire        reset,
  input     wire        x_i,      // Serial input

  output    wire[3:0]   sr_o
);

  logic [3:0] sr;
  logic [3:0] next_sr;
 
  
  always_ff @(posedge clk or posedge reset) begin
    if(reset)
      sr <= 4'h0;
  else 
    sr <= next_sr;
  end
  
  assign next_sr = {x_i,sr[3:1]};
  assign sr_o = sr;    

endmodule

module day6_tb ();

  logic         clk;
  logic         reset;
  logic         x_i;
  logic [3:0]   sr_o;
  
  day6 DAY6 (.*);
  
  initial begin
    clk = 1'b0; reset = 1'b1; x_i = 1'b0; #10;
    reset = 1'b0; x_i = 1'b1; #10;
    x_i = 1'b0; #10;
    x_i = 1'b1; #10;
    reset = 1'b1; #10;
    reset = 1'b0; #10;
    x_i = 1'b0; #10;
    x_i = 1'b1; #10;
    x_i = 1'b0; #10;
    x_i = 1'b1;
    $finish();
  end
  
  always #5 clk = ~clk;

endmodule
