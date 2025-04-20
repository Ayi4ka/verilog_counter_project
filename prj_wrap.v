module prj_wrap (
    input        clk,  
    input        rst_n,
    input  [7:0] keys, // sw
    output [7:0] leds,
    output [7:0] seg,
    output [3:0] dig
);

wire pulse [4:0]; 
wire [3:0] data[3:0]; 
wire [1:0] dig_sel; 
wire       fltr_p; 
wire	  inc; 
wire       kfp; 
wire pps; 
wire [7:0]  fltr_keys; 

assign fltr_keys = keys & {8{kfp}};

pulse_gen #(
	.FREQ(32'd25_000_000) //1 секунда
) pulse_inst(
    .clk(clk),
    .rst_n(rst_n),
    // 1 impulse per 1 sec
    .pulse_1s(pps), 
    // for display control
    .dig_sel(dig_sel),
    .dig_strb(dig),
    // for filter
    .pulse_fulter(kfp),
	.add_sig(fltr_p)

);

assign pulse[0] = keys[0] & pps;

genvar i;

generate
for(i = 0; i < 4; i = i + 1) begin : gen_renerate
cnt #(
    .DATA_WIDTH(4),
    .MAX_VAL    ((i % 2 == 0) ? 4'd9 : 4'h5)
) cnt0_inst(
    .clk(clk),
    .rst_n(rst_n),
	 .sft_rst(keys[1]),
    .pulse_incr_in (pulse[i]),
    .pulse_incr_out(pulse[i+1]),
    
    .data_o(data[i])
);
end
endgenerate

assign leds[7:1] = 7'b1111111;
					
my_segm mysegm_inst(
	.swi(data[dig_sel]),
	.seg(seg),
);

endmodule