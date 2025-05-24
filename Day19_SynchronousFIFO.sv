// Parameterized fifo

module day19 #(
  parameter DEPTH   = 4,
  parameter DATA_W  = 1
)(
  input         wire              clk,
  input         wire              reset,

  input         wire              push_i,
  input         wire[DATA_W-1:0]  push_data_i,

  input         wire              pop_i,
  output        wire[DATA_W-1:0]  pop_data_o,

  output        wire              full_o,
  output        wire              empty_o
);

  
  logic [DATA_W-1:0] fifo_pop_data;
  
  parameter PTR_W = $clog2(DEPTH);
  logic [PTR_W:0] nxt_rd_ptr,rd_ptr_q, nxt_wr_ptr,wr_ptr_q;
  
  always_ff @(posedge clk or posedge reset)
    if (reset) begin
      rd_ptr_q <= {PTR_W+1{1'b0}};
      wr_ptr_q <= {PTR_W+1{1'b0}};
    end else begin
      rd_ptr_q <= nxt_rd_ptr;
      wr_ptr_q <= nxt_wr_ptr;
    end
  
  
  typedef enum logic[1:0] {ST_PUSH = 2'b01,
                           ST_POP  = 2'b10,
                           ST_BOTH = 2'b11} fifo_state_t;
  
   always_comb begin
    nxt_rd_ptr = rd_ptr_q;
    nxt_wr_ptr = wr_ptr_q;
    fifo_pop_data = fifo_mem[rd_ptr_q[PTR_W-1:0]];
    case ({pop_i, push_i})
      ST_PUSH: begin
        nxt_wr_ptr = wr_ptr_q + {{PTR_W{1'b0}}, 1'b1};
      end
      ST_POP: begin
        nxt_rd_ptr = rd_ptr_q + {{PTR_W{1'b0}}, 1'b1};
        fifo_pop_data = fifo_mem[rd_ptr_q[PTR_W-1:0]];
      end
      ST_BOTH: begin
        nxt_wr_ptr = wr_ptr_q + {{PTR_W{1'b0}}, 1'b1};
        nxt_rd_ptr = rd_ptr_q + {{PTR_W{1'b0}}, 1'b1};
      end
    endcase
  end

  
  // 2D array representing the FIFO
  logic [DEPTH-1:0] [DATA_W-1:0] fifo_mem;
  
   always_ff @(posedge clk)
    if (push_i)
      fifo_mem[wr_ptr_q[PTR_W-1:0]] <= push_data_i;

  assign full_o = (rd_ptr_q[PTR_W] != wr_ptr_q[PTR_W]) &
                  (rd_ptr_q[PTR_W-1:0] == wr_ptr_q[PTR_W-1:0]);

  assign empty_o = (rd_ptr_q[PTR_W:0] == wr_ptr_q[PTR_W:0]);

endmodule

// Fifo TB

module day19_tb ();

  parameter DATA_W = 16;
  parameter DEPTH  = 8;

  logic              clk;
  logic              reset;

  logic              push_i;
  logic[DATA_W-1:0]  push_data_i;

  logic              pop_i;
  logic[DATA_W-1:0]  pop_data_o;

  logic              full_o;
  logic              empty_o;


  day19 #(.DEPTH(DEPTH), .DATA_W(DATA_W)) DAY19 (.*);
  
  initial begin
    reset   <= 1'b1;
    push_i  <= 1'b0;
    pop_i   <= 1'b0;
    @(posedge clk);
    reset   <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i=0; i<DEPTH; i++) begin
      push_i      <= 1'b1;
      push_data_i <= $urandom_range(0, 2**DATA_W-1);
      @(posedge clk);
    end
    push_i <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    for (int i=0; i<DEPTH; i++) begin
      pop_i      <= 1'b1;
      @(posedge clk);
    end
    pop_i <= 1'b0;
    @(posedge clk);
    @(posedge clk);
    push_i      <= 1'b1;
    push_data_i <= $urandom_range(0, 2**DATA_W-1);
    @(posedge clk);
    push_i      <= 1'b0;
    for (int i=0; i<DEPTH; i++) begin
      push_i      <= 1'b1;
      pop_i       <= 1'b1;
      push_data_i <= $urandom_range(0, 2**DATA_W-1);
      @(posedge clk);
    end
    pop_i <= 1'b0;
    push_i<= 1'b0;
    @(posedge clk);
    @(posedge clk);
    $finish();
  end

  always #5 clk = ~clk;

endmodule
