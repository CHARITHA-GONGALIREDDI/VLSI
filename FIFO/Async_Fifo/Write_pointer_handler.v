/*Due to metasatbility the wptr and rptr might be different so we use gray code conversion for less parity prone*/

module wptr_handler # (parameter PTR_WIDTH=3)(
	input wclk,wrst_n,wr_en,
	input [PTR_WIDTH:0] g_rptr_sync,
	output reg [PTR_WIDTH:0] b_wptr,g_wptr,
	output reg full);
	
	wire [PTR_WIDTH:0] b_wptr_nxt,g_wptr_nxt;
	wire wfull;
	
	assign b_wptr_nxt = b_wptr+(wr_en & !full);
	assign g_wptr_nxt = (b_wptr_nxt >> 1) ^ (b_wptr_nxt);
	
	always @ (posedge wclk or negedge wrst_n) begin
		if(!wrst_n) begin
			b_wptr <= 0;
			g_wptr <= 0;
		end else begin
			b_wptr <= b_wptr_nxt;
			g_wptr <= g_wptr_nxt;
		end
	end
	
	always @ (posedge wclk or negedge wrst_n) begin
		if(!wrst_n) begin
			full <=0;
		end
		else begin
			full <= wfull;
		end
	end
	
	assign wfull = (g_wptr_nxt == {~g_rptr_sync[PTR_WIDTH : PTR_WIDTH-1],g_rptr_sync[PTR_WIDTH-2:0]});
endmodule