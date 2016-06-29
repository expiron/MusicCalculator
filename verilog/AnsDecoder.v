module AnsDecoder(
	input      [15:0]ans,
	output reg       sign,
	output reg [3:0] num1,
	output reg [3:0] num2,
	output reg [3:0] num3,
	output reg [3:0] num4
);
/* Registers */
	reg [15:0]temp;

/* Not and add1 */
	always @ (*) begin
		if(ans[15])
			temp <= ~ans + 1;
		else
			temp <= ans;
	end

/* Calc sign, num1, num2, num3, num4 */
	always @ (temp) begin
		if(ans[15])
			sign <= 1;
		else
			sign <= 0;
		num1 = temp / 1000;
		num2 = (temp - num1 * 1000) / 100;
		num3 = (temp - num1 * 1000 - num2 * 100) / 10;
		num4 = temp % 10;
	end

endmodule
