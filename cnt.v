module cnt #(
    parameter DATA_WIDTH = 4,
    parameter MAX_VAL    = 4'd9
)(
    input                    clk,
    input                    rst_n,
    input                    sft_rst,
    // increment    
    input                    pulse_incr_in,
    output                   pulse_incr_out,
    // decrement    
    input                    pulse_decr_in,
    output                   pulse_decr_out,
    // cnt data
    output [DATA_WIDTH-1:0]  data_o

);

reg  [DATA_WIDTH-1:0] cnt_ff;
wire [DATA_WIDTH-1:0] cnt_incr;
wire [DATA_WIDTH-1:0] cnt_decr;

wire                  cnt_full;
wire                  cnt_empty;

wire                  incr_en;
wire                  decr_en;

assign cnt_incr = cnt_full  ? 4'b0     : (cnt_ff + 1'b1);
assign cnt_decr = cnt_empty ? MAX_VAL  : (cnt_ff - 1'b1);

assign cnt_full  = (cnt_ff == MAX_VAL);
assign cnt_empty = (cnt_ff == 4'b0);

assign incr_en = pulse_incr_in;
assign decr_en = pulse_decr_in;

always @(posedge clk or negedge rst_n)
if(~rst_n)       cnt_ff <= 4'b0;
else if(sft_rst) cnt_ff <= 4'b0;
else if(incr_en) cnt_ff <= cnt_incr;
else if(decr_en) cnt_ff <= cnt_decr;

assign data_o = cnt_ff;

assign pulse_incr_out = pulse_incr_in & cnt_full;
assign pulse_decr_out = pulse_decr_in & cnt_empty;

endmodule
