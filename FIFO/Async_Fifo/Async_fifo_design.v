/*Top module for async fifo which can use instantiations of all required modules*/

'include "Synchronizer.v"
'include "Write_pointer_handler.v"
'include "Read_pointer_handler.v"
'include "Fifo_memory.v"

module async_fifo_top #(parameter WIDTH=8, PTR_WIDTH=3,DEPTH=8)(
	input wclk,rclk,
	input wrst_n,rrst_n,
	input wr_en,rd_en,
	input [WIDTH-1:0] din,
	output reg full,empty,
	output reg [WIDTH-1:0] dout);
	
	reg [PTR_WIDTH:0] b_wptr,g_wptr,b_rptr,g_rptr,g_rptr_sync,g_wptr_sync;
	
	//module instantiations
	
	synchronizer #(PTR_WIDTH) w_sync (rclk,rrst_n,g_wptr,g_wptr_sync);
	synchronizer #(PTR_WIDTH) r_sync (wclk,wrst_n,g_rptr,g_rptr_sync);
	wptr_handler #(PTR_WIDTH) wptr_inst (wclk,wrst_n,wr_en,g_rptr_sync,b_wptr,g_wptr,full);
	rptr_handler #(PTR_WIDTH) rptr_inst (rclk,rrst_n, rd_en,g_wptr_sync,b_rptr,g_rptr,empty);
	fifo_mem #(WIDTH,PTR_WIDTH,DEPTH) mem_inst (wclk,rclk,wr_en,rd_en,din,b_wptr,b_rptr,full,empty,dout);
	
	
endmodule