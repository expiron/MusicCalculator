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
	wire[3:0] num1;
	wire[3:0] num2;
	wire[3:0] num3;
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

//	InputRegister inputRegister(
//		.reset(reset),
//		.erase(submit),
//		.num(num),
//		.numPressed(numPressed),
//		.num1(num1),
//		.num2(num2),
//		.num3(num3),
//	);

	DigitalLED # (.ledFreq(250)) digitalLED(
		.clk(clk),
		.reset(reset),
		.num1(num),
		.num2(num1),
		.num3(num2),
		.num4(num3),
		.com(com),
		.seg(seg)
	);

endmodule
