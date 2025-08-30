/*Synchronous FIFO is a data buffer that operates under a single clock 
  domain means both read and write operations occur using the same clock signal*/


module sync_fifo #(parameter DEPTH=8, parameter WIDTH=8)(
	input clk,rstn, //global signals
	input wr_en,rd_en, // to enable the read and write operations
	input [WIDTH-1:0] wdata, // data that need to be write in
	output reg [WIDTH-1:0] rdata, // data that need to be read out
	output reg full,empty);   // status flags of FIFO
	reg [$clog2 (DEPTH)-1:0] wptr;   // to hold the write address in fifo
	reg [$clog2 (DEPTH)-1:0] rptr;   // to hold read address in fifo
	reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];  //fifo memory that can store the data
	
	//Writing to FIFO 
	always @(posedge clk) begin
		if (!rstn) wptr<=0;
		else begin
			if (wr_en & !full) begin
				fifo_mem[wptr] <= wdata;
				wptr <= wptr+1;
			end
		end
	end
	
	//Reading from FIFO
	always @(posedge clk) begin
		if (!rstn) rptr<=0;
		else begin
			if (rd_en & !empty) begin
				rdata <= fifo_mem[rptr];
				rptr <= rptr+1;
			end
		end
	end
	//assigning the status flags indicating the fifo space
	assign full = (wptr+1 == rptr);
	assign empty = (wptr == rptr);
endmodule