// APB Master

// TB should drive a cmd_i input decoded as:
//  - 2'b00 - No-op
//  - 2'b01 - Read from address 0xDEAD_CAFE
//  - 2'b10 - Increment the previously read data and store it to 0xDEAD_CAFE

module day16 (
  input       wire        clk,
  input       wire        reset,

  input       wire[1:0]   cmd_i,

  output      wire        psel_o,
  output      wire        penable_o,
  output      wire[31:0]  paddr_o,
  output      wire        pwrite_o,
  output      wire[31:0]  pwdata_o,
  input       wire        pready_i,
  input       wire[31:0]  prdata_i
);

  //finite state machine
  typedef enum logic[1:0] {
  ST_IDLE   = 2'b00,
  ST_SETUP  = 2'b01,
  ST_ACCESS = 2'b10
	} apb_state_t;
  
  apb_state_t next_state, state_q;
  
  always_ff @(posedge clk or posedge reset)
    if(reset)
      state_q <= ST_IDLE;
  	else
    	state_q <= next_state;
  
  //logic
  always_comb begin
    next_state = state_q;
    case(state_q)
      ST_IDLE: next_state = (|cmd_i) ? ST_SETUP : ST_IDLE;
      ST_SETUP: next_state = ST_ACCESS;
      ST_ACCESS: next_state = (pready_i) ? ST_IDLE : ST_ACCESS;
      default: next_state = state_q;
    endcase
  end
  
  assign psel_o     = (state_q == ST_SETUP) | (state_q == ST_ACCESS);
  assign penable_o  = (state_q == ST_ACCESS);
  assign pwrite_o   = cmd_i[1];
  assign paddr_o    = 32'hDEAD_CAFE;
  assign pwdata_o   = rdata_q + 32'h1;
  
  
  //read data handling
  logic [31:0] rdata_q;
  
  always_ff @(posedge clk or posedge reset)
    if (reset)
      rdata_q <= 32'h0;
    else if (penable_o && pready_i)
      rdata_q <= prdata_i;
  

endmodule

// APB Master TB

module day16_tb ();

  logic        clk;
  logic        reset;

  logic[1:0]   cmd_i;

  logic        psel_o;
  logic        penable_o;
  logic[31:0]  paddr_o;
  logic        pwrite_o;
  logic[31:0]  pwdata_o;
  logic        pready_i;
  logic[31:0]  prdata_i;
  
  day16 DAY16 (.*);
  
  //to generate pready
  int wait_cycles;
  always begin
    pready_i = 1'b0;
    wait_cycles = $urandom_range (1, 10);
    while (wait_cycles) begin
      @(posedge clk);
      wait_cycles--;
    end
    pready_i = 1'b1;
    @(posedge clk);
  end
  
  initial begin
    clk <= 1'b0;
    reset <= 1'b1;
    cmd_i <= 2'b00;
    prdata_i <= 32'h0;
    @(posedge clk);
    reset <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i=0; i<10; i++) begin
      cmd_i <= i%2 ? 2'b10 : 2'b01;
      prdata_i <= $urandom_range(0, 4'hF);
      // Wait for pready to be asserted
      while (~pready_i | ~psel_o) @(posedge clk);
      @(posedge clk);
    end
    $finish();
  end
  
  always #10 clk = ~clk;

endmodule
