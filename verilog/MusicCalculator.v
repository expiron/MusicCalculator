module MusicCalculator(
	input            clk,
	input            reset,
	input      [3:0] row,
	output     [3:0] col,
	output     [3:0] com,
	output     [7:0] seg
);

	wire[3:0]num;
	wire     keyPressed;

	Keyboard # (.kbdFreq(50)) keyboard(
		.clk(clk),
		.reset(reset),
		.row(row),
		.col(col),
		.num(num),
		.keyPressed(keyPressed)
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
