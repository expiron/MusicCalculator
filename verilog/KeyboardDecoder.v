module KeyboardDecoder(
	input            clk,
	input            reset,
	input      [3:0] row,
	output     [3:0] col,
	output     [3:0] num,
	output reg       numPressed,
	output reg [2:0] opt,
	output reg       optPressed,
	output reg       submit
);

/* Wires */
	wire     keyPressed;

/* Instance of Universal Keyboard */
	Keyboard # (.kbdFreq(50)) keyboard(
		.clk(clk),
		.reset(reset),
		.row(row),
		.col(col),
		.num(num),
		.keyPressed(keyPressed)
	);

/* Decode the code of the key */
	always @ (keyPressed) begin
		if (keyPressed)
			case (num)
			0,1,2,3,4,5,6,7,8,9: begin numPressed <= 1; opt <= 0; optPressed <= 0; submit <= 0; end
			10:                  begin numPressed <= 0; opt <= 1; optPressed <= 1; submit <= 0; end
			11:                  begin numPressed <= 0; opt <= 2; optPressed <= 1; submit <= 0; end
			12:                  begin numPressed <= 0; opt <= 3; optPressed <= 1; submit <= 0; end
			13:                  begin numPressed <= 0; opt <= 4; optPressed <= 1; submit <= 0; end
			14:                  begin numPressed <= 0; opt <= 5; optPressed <= 1; submit <= 0; end
			15:                  begin numPressed <= 0; opt <= 0; optPressed <= 0; submit <= 1; end
			endcase
		else begin
			numPressed <= 0;
			opt <= 0;
			optPressed <= 0;
			submit <= 0;
		end
	end

endmodule
