// APB Slave

module day18 (
  input         wire        clk,
  input         wire        reset,

  input         wire        psel_i,
  input         wire        penable_i,
  input         wire[9:0]   paddr_i,
  input         wire        pwrite_i,
  input         wire[31:0]  pwdata_i,
  output        wire[31:0]  prdata_o,
  output        wire        pready_o
);

  day17 DAY17 (
    .clk            (clk),
    .reset          (reset),
    .req_i          (apb_req),
    .req_rnw_i      (~pwrite_i),
    .req_addr_i     (paddr_i),
    .req_wdata_i    (pwdata_i),
    .req_ready_o    (pready_o),
    .req_rdata_o    (prdata_o)
  );
   
  logic apb_req;

  assign apb_req = psel_i & penable_i;


endmodule

module day17 (
  input       wire        clk,
  input       wire        reset,

  input       wire        req_i,
  input       wire        req_rnw_i,    // 1 - read, 0 - write
  input       wire[3:0]   req_addr_i,
  input       wire[31:0]  req_wdata_i,
  output      wire        req_ready_o,
  output      wire[31:0]  req_rdata_o
);

  
// Memory array
`ifdef FORMAL
  logic [31:0] mem[15:0];
`else
  logic [15:0][31:0] mem;
`endif

  logic mem_rd;
  logic mem_wr;

  logic req_rising_edge;

  logic [3:0] lfsr_val;
  logic [3:0] count;

  assign mem_rd = req_i &  req_rnw_i;
  assign mem_wr = req_i & ~req_rnw_i;

  // Detect a rising edge on the req_i
  day3 DAY3 (
    .clk            (clk),
    .reset          (reset),
    .a_i            (req_i),
    .rising_edge_o  (req_rising_edge),
    .falling_edge_o (/* Not needed */)
  );

  // Load a counter with random value on the rising edge
  logic[3:0] count_ff;
  logic[3:0] nxt_count;
  
  logic [3:0] lfsr_val;
  logic [3:0] count;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      count_ff <= 4'h0;
    else
      count_ff <= nxt_count;

  assign nxt_count = req_rising_edge ? lfsr_val:
                                       count_ff + 4'h1;

  assign count = count_ff;

  // Generate a random load value
  day7 DAY7 (
    .clk            (clk),
    .reset          (reset),
    .lfsr_o         (lfsr_val)
  );

  // Write into the mem when the counter is 0
  always_ff @(posedge clk)
    if (mem_wr & ~|count)
      mem[req_addr_i] <= req_wdata_i;

  // Read directly
  assign req_rdata_o = mem[req_addr_i] & {32{mem_rd}};

  // Assert ready only when counter is at 0
  // This will add random delays on when memory gives the ready
  assign req_ready_o = ~|count;

endmodule

module day3 (
  input     wire    clk,
  input     wire    reset,

  input     wire    a_i,

  output    wire    rising_edge_o,
  output    wire    falling_edge_o
);

  logic a_ff;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      a_ff <= 1'b0;
    else
      a_ff <= a_i;

  // Rising edge when delayed signal is 0 but current is 1
  assign rising_edge_o = ~a_ff & a_i;

  // Falling edge when delayed signal is 1 but current is 0
  assign falling_edge_o = a_ff & ~a_i;

endmodule

module day7 (
  input     wire      clk,
  input     wire      reset,

  output    wire[3:0] lfsr_o
);

  logic [3:0] lfsr_ff;
  logic [3:0] nxt_lfsr;

  always_ff @(posedge clk or posedge reset)
    if (reset)
      lfsr_ff <= 4'hE;
    else
      lfsr_ff <= nxt_lfsr;

  assign nxt_lfsr = {lfsr_ff[2:0], lfsr_ff[1] ^ lfsr_ff[3]};

  assign lfsr_o = lfsr_ff;

endmodule

// Simple APB TB

module day18_tb ();

  logic        clk;
  logic        reset;
  logic        psel_i;
  logic        penable_i;
  logic[9:0]   paddr_i;
  logic        pwrite_i;
  logic[31:0]  pwdata_i;
  logic[31:0]  prdata_o;
  logic        pready_o;
  logic [9:0] [9:0] rand_addr_list;


  day18 DAY18 (.*);
  
  initial begin
    clk <= 1'b0;
    reset     <= 1'b1;
    psel_i    <= 1'b0;
    penable_i <= 1'b0;
    @(posedge clk);
    reset     <= 1'b0;
    @(posedge clk);
    // Send 10 write transactions to random addresses
    for (int i=0; i<10; i++) begin
      psel_i  <= 1'b1;      // ST_SETUP
      @(posedge clk);
      penable_i <= 1'b1;    // ST_ACCESS
      paddr_i   <= $urandom_range(0, 10'h3FF);
      pwrite_i  <= 1'b1;    // Write
      pwdata_i  <= $urandom_range(0, 16'hFFFF);
      // Wait for PREADY
      while (~(psel_i & penable_i & pready_o)) @(posedge clk);
      psel_i    <= 1'b0;
      penable_i <= 1'b0;
      rand_addr_list[i] = paddr_i;
      @(posedge clk);
    end
    
    // Send 10 read transactions to the write addresses
    for (int i=0; i<10; i++) begin
      psel_i  <= 1'b1;      // ST_SETUP
      @(posedge clk);
      penable_i <= 1'b1;    // ST_ACCESS
      paddr_i   <= rand_addr_list[i];
      pwrite_i  <= 1'b0;    // READ
      pwdata_i  <= $urandom_range(0, 16'hFFFF);
      // Wait for PREADY
      while (~(psel_i & penable_i & pready_o)) @(posedge clk);
      psel_i    <= 1'b0;
      penable_i <= 1'b0;
      @(posedge clk);
    end
    $finish();
  end
  
  always #5 clk = ~clk;

endmodule
