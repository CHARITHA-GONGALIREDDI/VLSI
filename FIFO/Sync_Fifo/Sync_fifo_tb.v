module sync_fifo_tb;
	//Testbench signals
	reg clk,rstn;
	reg wr_en,rd_en;
	reg [7:0] wdata;
	wire [7:0] rdata;
	wire full,empty;
	
	//DUT Instantiation
	sync_fifo dut (clk,rstn,wr_en,rd_en,wdata,rdata,full,empty);
	
	//Clock Generation
	initial clk=0;
	always #5 clk=~clk;
	// Test procedure
    initial begin
		$dumpfile ("dump.vcd");
		$dumpvars();
        // Initializing signals
        rstn = 0;   // Reset the FIFO initially
        wr_en = 0;
        rd_en = 0;
        wdata = 8'b0;

        // Apply reset
        #10 rstn = 1;  // Release reset
        #10;

        // Write data to FIFO
        wr_en = 1;
        wdata = 8'hA5; // Writing 0xA5
        #10;
        wdata = 8'h5A; // Writing 0x5A
        #10;

        // Read data from FIFO
        wr_en = 0;    // Disable write
        rd_en = 1;    // Enable read
        #10;

        // Check FIFO status after read
        rd_en = 0;    // Disable read
        #10;
        
        // Test FIFO when it's full
        wr_en = 1;
        wdata = 8'hFF; // Writing 0xFF
        #10;
        wdata = 8'h00; // Writing 0x00
        #10;

        // Disable write and read
        wr_en = 0;
        rd_en = 1;    // Enable read when full
        #10;
        rd_en = 0;
        #10;

        // Final check
        $finish;
    end

    // Monitor the signals
    initial begin
        $monitor("At time %t, wr_en=%b, rd_en=%b, wdata=%h, rdata=%h, full=%b, empty=%b", 
                 $time, wr_en, rd_en, wdata, rdata, full, empty);
    end

endmodule