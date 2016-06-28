`timescale 1 ns/ 1 ps
module CU_tst();
parameter clk_period = 10;
reg clk;
reg [3:0] num;
reg numPressed;
reg [2:0] opt;
reg optPressed;
reg reset;
reg submit;
wire [7:0]  byteNum;
wire [1:0] nTimes;

CU  inst (
	.byteNum(byteNum),
	.clk(clk),
	.num(num),
	.numPressed(numPressed),
	.opt(opt),
	.optPressed(optPressed),
	.reset(reset),
	.nTimes(nTimes),
	.submit(submit)
);

initial begin
	reset = 0;
	clk = 0;
	num = 0;
	numPressed = 0;
	opt = 0;
	optPressed = 0;
	submit = 0;
	#clk_period reset = 1;
	#clk_period num = 2;
	numPressed = 1;
	#clk_period num = 0;
	numPressed = 0;
	#clk_period num = 3;
	numPressed = 1;
	#clk_period num = 0;
	numPressed = 0;
	#clk_period num = 1;
	numPressed = 1;
	#clk_period num = 0;
	numPressed = 0;
end
always #(clk_period / 2) clk = ~clk;
endmodule

