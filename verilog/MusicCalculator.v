module MusicCalculator(
	input            clk,
	input            reset,
	input      [3:0] row,
	output     [3:0] col,
	output     [3:0] com,
	output     [7:0] seg,
	output           sign,
	output           cmpSign,
	output           clcZero,
	output           clcCo
);

	wire[3:0] num;
	wire[3:0] num1;
	wire[3:0] num2;
	wire[3:0] num3;
	wire[3:0] num4;
	wire[2:0] opt;
	wire      numPressed;
	wire      optPressed;
	wire      submit;


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

		CU # (.workFreq(2500)) controlUnit (
		.clk(clk),
		.reset(reset),
		.num(num),
		.numPressed(numPressed),
		.opt(opt),
		.optPressed(optPressed),
		.submit(submit),
		.num1(num1),
		.num2(num2),
		.num3(num3),
		.num4(num4),
		.sign(sign),
		.cmpSign(cmpSign),
		.clcCo(clcCo),
		.clcZero(clcZero)
	);

	DigitalLED # (.ledFreq(250)) digitalLED(
		.clk(clk),
		.reset(reset),
		.num1(num1),
		.num2(num2),
		.num3(num3),
		.num4(num4),
		.com(com),
		.seg(seg)
	);

endmodule
