`timescale 1 ns/ 1 ps
module InputRegister_tst();

	parameter period = 10;

	reg       reset;
	reg       erase;
	reg [3:0] num;
	reg       numPressed;
	wire[3:0] num1;
	wire[3:0] num2;
	wire[3:0] num3;
	wire[15:0]value;

	InputRegister inst1 (
		.reset(reset),
		.erase(erase),
		.num(num),
		.numPressed(numPressed),
		.num1(num1),
		.num2(num2),
		.num3(num3),
		.value(value)
	);

	initial begin
		reset = 0;
		erase = 1;
		num   = 0;
		numPressed = 0;
		# period;
		reset = 1; erase = 0;
		# period;
		num = 5;
		numPressed = 1;
		# period;
		num = 0;
		numPressed = 0;
		# period;
		num = 9;
		numPressed = 1;
		# period;
		num = 0;
		numPressed = 0;
		# period;
		num = 8;
		numPressed = 1;
		# period;
		num = 0;
		numPressed = 0;
		# period;
		num = 3;
		numPressed = 1;
		# period;
		num = 0;
		numPressed = 0;
	end

endmodule
