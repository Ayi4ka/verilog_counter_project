module pulse_gen #(
    parameter CNT_WIDTH = 32,
    parameter FREQ      = 32'd25_000_000,
    parameter MUX_SEL   = 15, 
    parameter FLTR_SEL  = 22 
)(
    input        clk,
    input        rst_n,
    // 1 impulse per 1 sec
    output       pulse_1s,
    // for display control
    output [1:0] dig_sel,
    output [3:0] dig_strb,
    // for filter
    output       pulse_fulter,
    output       add_sig

);

localparam MAX_VAL = FREQ - 32'b1;

reg  [CNT_WIDTH-1:0] cnt_ff;
wire [CNT_WIDTH-1:0] cnt_next;
wire                 cnt_full;
reg                  pulse_ff;

wire          [1:0]  sel;
reg                  fltr_ff;

assign cnt_full = (cnt_ff == MAX_VAL);

assign cnt_next = cnt_full ? 32'b0 : (cnt_ff + 1'b1);

always @(posedge clk or negedge rst_n)
if(~rst_n)  cnt_ff <= 32'b0;
else        cnt_ff <= cnt_next;

always @(posedge clk or negedge rst_n)
if(~rst_n)  pulse_ff <= 1'b0;
else        pulse_ff <= cnt_full;

assign sel = cnt_ff[MUX_SEL+1:MUX_SEL];

always @(posedge clk or negedge rst_n)
if(~rst_n)  fltr_ff <= 1'b0;
else        fltr_ff <= cnt_ff[FLTR_SEL];

assign pulse_fulter = ~fltr_ff & cnt_ff[FLTR_SEL];

assign pulse_1s = pulse_ff;


assign dig_sel = sel;
assign dig_strb[0] = (sel == 2'd0);
assign dig_strb[1] = (sel == 2'd1);
assign dig_strb[2] = (sel == 2'd2);
assign dig_strb[3] = (sel == 2'd3);

assign add_sig = cnt_ff[23]; 

endmodule
