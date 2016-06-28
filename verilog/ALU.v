module ALU(
	input      [2:0] opt,
	input      [7:0] numa,
	input      [7:0] numb,
	input      [7:0] ci,
	output reg [7:0] s,
	output           zero,
	output reg       co
);

/* Registers */
	parameter OPT_NULL = 0, OPT_ADD = 1, OPT_SUB = 2, OPT_AND = 3, OPT_ORR = 4, OPT_CMP = 5;
/* Wires */
	wire[7:0] s1;
	wire[7:0] ct1;
	wire[7:0] s2;
	wire[7:0] ct2;

/* Instances of the full adder */
	ALU_Adder ia0(.a(numa[0]), .b(numb[0]), .ci(ci),     .s(s1[0]), .co(ct1[0]));
	ALU_Adder ia1(.a(numa[1]), .b(numb[1]), .ci(ct1[0]), .s(s1[1]), .co(ct1[1]));
	ALU_Adder ia2(.a(numa[2]), .b(numb[2]), .ci(ct1[1]), .s(s1[2]), .co(ct1[2]));
	ALU_Adder ia3(.a(numa[3]), .b(numb[3]), .ci(ct1[2]), .s(s1[3]), .co(ct1[3]));
	ALU_Adder ia4(.a(numa[4]), .b(numb[4]), .ci(ct1[3]), .s(s1[4]), .co(ct1[4]));
	ALU_Adder ia5(.a(numa[5]), .b(numb[5]), .ci(ct1[4]), .s(s1[5]), .co(ct1[5]));
	ALU_Adder ia6(.a(numa[6]), .b(numb[6]), .ci(ct1[5]), .s(s1[6]), .co(ct1[6]));
	ALU_Adder ia7(.a(numa[7]), .b(numb[7]), .ci(ct1[6]), .s(s1[7]), .co(ct1[7]));

/* Instances of the full subtracter */
	ALU_Subtracter is0(.a(numa[0]), .b(numb[0]), .ci(ci),     .s(s2[0]), .co(ct2[0]));
	ALU_Subtracter is1(.a(numa[1]), .b(numb[1]), .ci(ct2[0]), .s(s2[1]), .co(ct2[1]));
	ALU_Subtracter is2(.a(numa[2]), .b(numb[2]), .ci(ct2[1]), .s(s2[2]), .co(ct2[2]));
	ALU_Subtracter is3(.a(numa[3]), .b(numb[3]), .ci(ct2[2]), .s(s2[3]), .co(ct2[3]));
	ALU_Subtracter is4(.a(numa[4]), .b(numb[4]), .ci(ct2[3]), .s(s2[4]), .co(ct2[4]));
	ALU_Subtracter is5(.a(numa[5]), .b(numb[5]), .ci(ct2[4]), .s(s2[5]), .co(ct2[5]));
	ALU_Subtracter is6(.a(numa[6]), .b(numb[6]), .ci(ct2[5]), .s(s2[6]), .co(ct2[6]));
	ALU_Subtracter is7(.a(numa[7]), .b(numb[7]), .ci(ct2[6]), .s(s2[7]), .co(ct2[7]));

/* Output */
	always @ ( * ) begin
		case (opt)
			OPT_ADD: begin s <= s1;     co <= ct1[7]; end
			OPT_SUB: begin s <= s2;     co <= ct2[7]; end
			OPT_AND: begin s <= numa & numb; co <= 0; end
			OPT_ORR: begin s <= numa | numb; co <= 0; end
			OPT_CMP: begin s <= s2;     co <= ct2[7]; end
			default: begin s <= 0;            co <=0; end
		endcase
	end

/* Zero Check */
	assign zero = (~s[0] & ~s[1] & ~s[2] & ~s[3] & ~s[4] & ~s[5] & ~s[6] & ~s[7]);

endmodule

/* Module of Adder and Subtracter */
module ALU_Adder(
	input  a, b, ci,
	output s, co
);
	assign s = a ^ b ^ ci;
	assign co = ((a & b) | (a & ci) | (b & ci));
endmodule
module ALU_Subtracter(
	input  a, b, ci,
	output s, co
);
	assign s = ((~a & ~b & ci) | (~a & b & ~ci) | (a & ~b & ~ci) | (a & b & ci));
	assign co = ((~a & b) | (~a & ci) | (b & ci));
endmodule
