module MusicCalculator(
	input            clk,
	input            reset,
	input      [3:0] row,
	output     [3:0] col,
	output     [3:0] com,
	output     [7:0] seg,
	output     [2:0] opt,
	output           numPressed,
	output           optPressed,
	output           submit
);

	wire[3:0] num;
//	wire[2:0] opt;
//	wire      numPressed;
//	wire      optPressed;
//	wire      submit;


	KeyboardDecoder keyboard(
		.clk(clk),
		.reset(reset),
		.row(row),
		.col(col),
		.num(num),
		.numPressed(numPressed),
		.opt(opt),
		.optPressed(optPressed),
		.submit(submit)
	);

	DigitalLED # (.ledFreq(250)) digitalLED(
		.clk(clk),
		.reset(reset),
		.num1(num),
		.num2(num),
		.num3(num),
		.num4(num),
		.com(com),
		.seg(seg)
	);

endmodule
