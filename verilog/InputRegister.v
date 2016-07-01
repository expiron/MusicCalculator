module InputRegister(
	input            reset,
	input            erase,
	input      [3:0] num,
	input            numPressed,
	output     [3:0] num1,
	output     [3:0] num2,
	output     [3:0] num3,
	output reg [15:0]value
);

/* Registers */
	reg [3:0] temp [1:3];
	reg [1:0] nbit;
/* Wires */
	wire      Reset;

/* Reset signal define */
	assign Reset = ((reset) & (~erase));

/* Output for seg */
	assign num1 = temp[1];
	assign num2 = temp[2];
	assign num3 = temp[3];

/* Input Shift */
	always @ (posedge numPressed or negedge Reset) begin
		if (!Reset) begin
			temp[1] <= 0;
			temp[2] <= 0;
			temp[3] <= 0;
			nbit <= 0;
		end
		else if ((nbit < 3) && (num < 10)) begin
			temp[1] <= (numPressed ? num2 : num1);
			temp[2] <= (numPressed ? num3 : num2);
			temp[3] <= (numPressed ? num  : num3);
			nbit <= nbit + 1;
		end
	end

/* Output value Calculate */
	always @ (temp) begin
		value <= num1 * 100 + num2 * 10 + num3;
		//value <= (num1<<3 + num1<<1)<<3 + (num1<<3 + num1<<1)<<1 + num2<<3 + num2<<1 + num3;  //why cannot work
	end

endmodule
