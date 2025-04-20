module my_segm (
input [3:0] swi,
output reg [7:0] seg
);


always @*
case (swi) //      76543210
	4'h0	: seg = 8'b00111111;
	4'h1	: seg = 8'b00000110;
	4'h2	: seg = 8'b01011011;
	4'h3	: seg = 8'b01001111;
	4'h4	: seg = 8'b01100110;
	4'h5	: seg = 8'b01101101;
	4'h6	: seg = 8'b01111101;
	4'h7	: seg = 8'b00000111;
	4'h8	: seg = 8'b01111111;
	4'h9	: seg = 8'b01101111;
	//4'hA	: seg = 8'b01110111;
	//4'hB	: seg = 8'b01111100;
	//4'hC	: seg = 8'b00111001;
	//4'hD	: seg = 8'b01011110;
	//4'hE	: seg = 8'b01111001;
	//4'hF	: seg = 8'b01110001;

default: seg = 8'b0;
endcase

endmodule
