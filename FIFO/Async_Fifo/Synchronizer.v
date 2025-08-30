/*To calculate FIFO full and empty conditions it requires clock domain 
crossing as wptr and rptr operates on different clocks. 
So to reduce Metastability we need synchronizer*/


module synchronizer #(parameter WIDTH=3)(
	// Synchronizer signals
	input clk,rstn,
	input [WIDTH:0] din,
	output reg [WIDTH:0] dout);
	reg [WIDTH:0] d;
	
	//2-flop synchronizer
	always @ (posedge clk or negedge rstn) begin
		if(!rstn) begin
			d <= 0;
			dout <= 0;
		end
		else begin
			d <= din;
			dout <= d;
		end
	end
endmodule