//dff module
module day2 (
  input     logic      clk,
  input     logic      reset_sync,
  input			logic 		 reset_async,
  input     logic      d_i,
  output    logic      q_norst_o,
  output    logic      q_syncrst_o,
  output    logic      q_asyncrst_o
);

  //no reset
  always_ff @(posedge clk)
    begin
      q_norst_o <= d_i;
    end

  //synchronous reset 
  always_ff @(posedge clk)
    begin
      if(reset_sync)
        q_syncrst_o <= 1'b0;
      else
        q_syncrst_o <= d_i;
    end

  //asynchronous reset
  always_ff @(posedge clk or posedge reset_async)
    begin
      if(reset_async)
        q_asyncrst_o <= 1'b0;
      else
        q_asyncrst_o <= d_i;
    end

endmodule

//dff tb module
module day2_tb ();
	logic      clk;
  logic      reset_sync;
  logic      reset_async;
  logic      d_i;
  logic      q_norst_o;
  logic      q_syncrst_o;
  logic      q_asyncrst_o;
  
  day2 dut(.clk(clk),
           .reset_sync(reset_sync),
           .reset_async(reset_async),
           .d_i(d_i),
           .q_norst_o(q_norst_o),
           .q_syncrst_o(q_syncrst_o),
           .q_asyncrst_o(q_asyncrst_o)
          );
  
  
  initial begin
    d_i = 1'b0; clk = 1'b0; reset_sync = 1'b0; reset_async = 1'b0; #10;
    d_i = 1'b0; clk = 1'b0; reset_sync = 1'b1; reset_async = 1'b1; #10;
    d_i = 1'b0; clk = 1'b1; reset_sync = 1'b0; reset_async = 1'b0; #10;
    d_i = 1'b0; clk = 1'b1; reset_sync = 1'b1; reset_async = 1'b1; #10;
    d_i = 1'b1; clk = 1'b0; reset_sync = 1'b0; reset_async = 1'b0; #10;
    d_i = 1'b1; clk = 1'b0; reset_sync = 1'b1; reset_async = 1'b1; #10;
    d_i = 1'b1; clk = 1'b1; reset_sync = 1'b0; reset_async = 1'b0; #10;
    d_i = 1'b1; clk = 1'b1; reset_sync = 1'b1; reset_async = 1'b1;
    $finish();
  end
  
endmodule
