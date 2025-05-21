// Round robin arbiter

module day15 (
  input     wire        clk,
  input     wire        reset,

  input     wire[3:0]   req_i,
  output    logic[3:0]  gnt_o
);
  
  logic [3:0] mask_q, next_mask_req;
  always_ff @(posedge clk or posedge reset)
    if(reset)
      mask_q <= 4'hF;
    else
      mask_q <= next_mask_req;
  
  always_comb begin
    next_mask_req = mask_q;
    case(gnt_o)
      4'b0001: next_mask_req = 4'b1110;
      4'b0010: next_mask_req = 4'b1100;
      4'b0100: next_mask_req = 4'b1000;
      4'b1000: next_mask_req = 4'b0000;
      default: next_mask_req = 4'bz;
    endcase
  end
      
  logic [3:0] mask_req;

  assign mask_req = req_i & mask_q;

  logic [3:0] mask_gnt;
  logic [3:0] raw_gnt;
  
  day14 #(4) inst0 (.req_i (mask_req), .gnt_o (mask_gnt)); //masked grant
  day14 #(4) inst1 (.req_i (req_i),    .gnt_o (raw_gnt)); //raw grant
      
  // Final grant based on mask req
  assign gnt_o = |mask_req ? mask_gnt : raw_gnt;

endmodule
  
  module day14 #(
  parameter NUM_PORTS = 4
)(
    input       wire[NUM_PORTS-1:0] req_i,
    output      wire[NUM_PORTS-1:0] gnt_o   // One-hot grant signal
);
  // Port[0] has highest priority
  assign gnt_o[0] = req_i[0];

  genvar i;
  for (i=1; i<NUM_PORTS; i=i+1) begin
    assign gnt_o[i] = req_i[i] & ~(|gnt_o[i-1:0]);
  end

endmodule

// TB for round robin

module day15_tb ();

  logic         clk;
  logic         reset;

  logic [3:0]   req_i;
  logic [3:0]   gnt_o;

  // Instatiate the module
  day15 DAY15 (.*);
  
  initial begin
    clk = 1'b0; reset = 1'b1; 
    #10; reset = 1'b0;
    #10;
    for (int i =0; i<32; i++) begin
      req_i <= $urandom_range(0, 4'hF);
      #5;
    end
    #20 $finish();
  end

  always #5 clk = ~clk;
endmodule
