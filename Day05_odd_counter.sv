// Odd counter

module day5 (
  input     wire        clk,
  input     wire        reset,

  output    logic[7:0]  cnt_o
);

  logic [7:0]inc_cnt;
  
  always_ff @(posedge clk or posedge reset)
    begin
      if(reset)
      	cnt_o <= 8'h1;
  		else
    		cnt_o <= inc_cnt;
    end
    
  
  assign inc_cnt = cnt_o + 8'h2;

endmodule

// Simple TB

module day5_tb ();

  logic clk;
  logic reset;
  logic [7:0] cnt_o;
  
  day5 dut(.clk(clk),
           .reset(reset),
           .cnt_o(cnt_o)
          );
  
  initial begin
    clk = 1'b0; reset = 1'b1; #10;
    reset = 1'b0; #10;
    #20;
    $finish();
  end
  
  always #5 clk = ~clk;

endmodule

// Simple TB

module day5_tb ();

  logic clk;
  logic reset;
  logic [7:0] cnt_o;
  
  day5 dut(.clk(clk),
           .reset(reset),
           .cnt_o(cnt_o)
          );
  
  initial begin
    clk = 1'b0; reset = 1'b1; #10;
    reset = 1'b0; #10;
    #20;
    $finish();
  end
  
  always #5 clk = ~clk;

endmodule
