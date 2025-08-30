/*Due to metasatbility the wptr and rptr might be different so we use gray code conversion for less parity prone*/

module rptr_handler # (parameter PTR_WIDTH=3)(
	input rclk,rrst_n,rd_en,
	input [PTR_WIDTH:0] g_wptr_sync,
	output reg [PTR_WIDTH:0] b_rptr,g_rptr,
	output reg empty);
	
	wire [PTR_WIDTH:0] b_rptr_nxt,g_rptr_nxt;
	wire rempty;
	
	assign b_rptr_nxt = b_rptr+(rd_en & !empty);
	assign g_rptr_nxt = (b_rptr_nxt >> 1) ^ (b_rptr_nxt);
	
	always @ (posedge rclk or negedge rrst_n) begin
		if(!rrst_n) begin
			b_rptr <= 0;
			g_rptr <= 0;
		end else begin
			b_rptr <= b_rptr_nxt;
			g_rptr <= g_rptr_nxt;
		end
	end
	
	always @ (posedge rclk or negedge rrst_n) begin
		if(!rrst_n) begin
			empty <=1;
		end
		else begin
			empty <= rempty;
		end
	end
	
	assign rempty = (g_wptr_sync==g_rptr_nxt);
endmodule