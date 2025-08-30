module async_fifo_TB;

  parameter DATA_WIDTH = 8;

  reg wclk,rclk;
  reg wrst_n,rrst_n;
  reg wr_en,rd_en;
  reg [DATA_WIDTH-1:0] din;
  wire full,empty;
  wire [DATA_WIDTH-1:0] dout;

  async_fifo_top uut (wclk,rclk,wrst_n,rrst_n,wr_en,rd_en,din,full,empty,dout);
  
  // Clock generation
  always #5 wclk = ~wclk;  // Write clock period of 10
  always #7 rclk = ~rclk;  // Read clock period of 14

  // Write process
  initial begin
    wclk = 0;
    wrst_n = 0;
    wr_en = 0;
    din = 0;

    // Release reset after 10 clock cycles
    repeat(10) @(posedge wclk);
    wrst_n = 1;
    
    // Write 30 data values, alternating wr_en
    repeat(2) begin
      for (int i = 0; i < 30; i++) begin
        @(posedge wclk);  // Wait for a write clock edge
        
        wr_en = (i % 2 == 0) ? 1'b1 : 1'b0;  // Toggle write enable every other cycle
        if (wr_en) begin
          din = din + 1;  // Increment the data to be written
        end
      end
      #50;  // Wait for 50 time units before next iteration
    end
  end

  // Read process
  initial begin
    rclk = 0;
    rrst_n = 0;
    rd_en = 0;

    // Release read reset after 10 clock cycles
    repeat(10) @(posedge rclk);
    rrst_n = 1;
    
    // Read 30 data values, alternating rd_en
    repeat(2) begin
      for (int i = 0; i < 30; i++) begin
        @(posedge rclk);  // Wait for a read clock edge
        
        rd_en = (i % 2 == 0) ? 1'b1 : 1'b0;  // Toggle read enable every other cycle
      end
      #50;  // Wait for 50 time units before next iteration
    end
    $finish;  // End the simulation
  end

  // Dump waveform for debugging
  initial begin 
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end

  // Real-time monitoring (optional)
  initial begin
    $monitor("Time=%0t | wr_en=%b | rd_en=%b | din=%h | dout=%h | full=%b | empty=%b", 
             $time, wr_en, rd_en, din, dout, full, empty);
  end

endmodule