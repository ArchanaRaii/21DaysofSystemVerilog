// Parallel to serial with valid and empty

module day11 (
  input     wire      clk,
  input     wire      reset,

  output    wire      empty_o,
  input     wire[3:0] parallel_i,
  
  output    wire      serial_o,
  output    wire      valid_o
);

  logic [2:0] count;
  
  always_ff @(posedge clk or posedge reset)
    if(reset)
      count <= 3'h0;
  else
    count <= (count == 3'h4) ? 3'h0 : count + 3'h1;
  
  assign empty_o = (count == 3'h0);
  assign valid_o = (count != 3'h0);
  
  logic [3:0] shift;
  
  always_ff @(posedge clk or posedge reset)
    if(reset)
      shift <= 0;
  	else
      shift <= empty_o ? parallel_i : shift >> 1;
  
  assign serial_o = shift[0];
endmodule

//tb
module day11_tb ();

  logic      clk;
  logic      reset;

  logic      empty_o;
  logic[3:0] parallel_i;
  logic      serial_o;
  logic      valid_o;

  day11 DAY11 (.*);

  initial begin
    clk <= 1'b0;
    reset <= 1'b1;
    parallel_i <= 4'h0;
    @(negedge clk);
    reset <= 1'b0;
    @(posedge clk);
    for (int i=0; i<32; i=i+1) begin
      parallel_i <= $urandom_range(0, 4'hF);
      @(posedge clk);
    end
    $finish();
  end

  always #5 clk = ~clk;
  
endmodule
