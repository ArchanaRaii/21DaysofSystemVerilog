// LFSR
module day7 (
  input     wire      clk,
  input     wire      reset,

  output    wire[3:0] lfsr_o
);
  
  logic [3:0] lfsr;
  logic [3:0] next_lfsr;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      lfsr <= 4'b1111;
    else
      lfsr <= next_lfsr;

  assign next_lfsr = {lfsr[2:0], lfsr[1] ^ lfsr[3]};

  assign lfsr_o = lfsr;

endmodule

//tb
module day7_tb ();

  logic clk;
  logic reset;

  logic [3:0] lfsr_o;

  day7 DAY7 (.*);
  
  initial begin
    clk = 1'b0; reset = 1'b1; #10;
    reset = 1'b0; #20;
    $finish();
  end

  always #5 clk = ~clk;
  
endmodule
