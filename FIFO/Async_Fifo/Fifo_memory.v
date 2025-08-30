/*storage element of fifo that can store data where data can be written in and read out*/

module fifo_mem #(parameter WIDTH=8, PTR_WIDTH=3, DEPTH=8)(
	input wclk,rclk,
	input wr_en,rd_en,
	input [WIDTH-1:0] din,
	input [PTR_WIDTH:0] b_wptr, b_rptr,
	input full,empty,
	output reg [WIDTH-1:0] dout);
	reg [WIDTH-1:0] mem_fifo [0:DEPTH];
	always @(posedge wclk) begin
		if(wr_en &!full)
			mem_fifo[b_wptr [PTR_WIDTH:0]] <= din;
	end
	always @(posedge rclk) begin
		if(rd_en &!empty)
			dout <= mem_fifo[b_rptr [PTR_WIDTH:0]];
	end
endmodule 
	