//--------------------------------------------------------------------------------------------------------
// Module  : fxp_zoom
// Type    : synthesizable
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: bit width conversion for fixed-point
//           combinational logic
//--------------------------------------------------------------------------------------------------------

module fxp_zoom #(
    parameter WII  = 8,
    parameter WIF  = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter ROUND= 1
)(
    input  wire [WII+WIF-1:0] in,
    output wire [WOI+WOF-1:0] out,
    output reg                overflow
);

initial overflow = 1'b0;

reg [WII+WOF-1:0] inr = 0;
reg [WII-1:0] ini = 0;
reg [WOI-1:0] outi = 0;
reg [WOF-1:0] outf = 0;

generate if(WOF<WIF) begin
    if(ROUND==0) begin
        always @ (*) inr = in[WII+WIF-1:WIF-WOF];
    end else if(WII+WOF>=2) begin
        always @ (*) begin
            inr = in[WII+WIF-1:WIF-WOF];
            if(in[WIF-WOF-1] & ~(~inr[WII+WOF-1] & (&inr[WII+WOF-2:0]))) inr=inr+1;
        end
    end else begin
        always @ (*) begin
            inr = in[WII+WIF-1:WIF-WOF];
            if(in[WIF-WOF-1] & inr[WII+WOF-1]) inr=inr+1;
        end
    end
end else if(WOF==WIF) begin
    always @ (*) inr[WII+WOF-1:WOF-WIF] = in;
end else begin
    always @ (*) begin
        inr[WII+WOF-1:WOF-WIF] = in;
        inr[WOF-WIF-1:0] = 0;
    end
end endgenerate


generate if(WOI<WII) begin
    always @ (*) begin
        {ini, outf} = inr;
        if         ( ~ini[WII-1] & |ini[WII-2:WOI-1] ) begin
            overflow = 1'b1;
            outi = {WOI{1'b1}};
            outi[WOI-1] = 1'b0;
            outf = {WOF{1'b1}};
        end else if(  ini[WII-1] & ~(&ini[WII-2:WOI-1]) ) begin
            overflow = 1'b1;
            outi = 0;
            outi[WOI-1] = 1'b1;
            outf = 0;
        end else begin
            overflow = 1'b0;
            outi = ini[WOI-1:0];
        end
    end
end else begin
    always @ (*) begin
        {ini, outf} = inr;
        overflow = 1'b0;
        outi = ini[WII-1] ? {WOI{1'b1}} : 0;
        outi[WII-1:0] = ini;
    end
end endgenerate

assign out = {outi, outf};

endmodule







//--------------------------------------------------------------------------------------------------------
// Module  : fxp_add
// Type    : synthesizable
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: addition
//           combinational logic
//--------------------------------------------------------------------------------------------------------

module fxp_add # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter ROUND= 1
)(
    input  wire [WIIA+WIFA-1:0] ina,
    input  wire [WIIB+WIFB-1:0] inb,
    output wire [WOI +WOF -1:0] out,
    output wire                 overflow
);

localparam WII = WIIA>WIIB ? WIIA : WIIB;
localparam WIF = WIFA>WIFB ? WIFA : WIFB;
localparam WRI = WII + 1;
localparam WRF = WIF;

wire [WII+WIF-1:0] inaz, inbz;

wire signed [WRI+WRF-1:0] res = $signed(inaz) + $signed(inbz);

fxp_zoom # (
    .WII      ( WIIA     ),
    .WIF      ( WIFA     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) ina_zoom (
    .in       ( ina      ),
    .out      ( inaz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WIIB     ),
    .WIF      ( WIFB     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) inb_zoom (
    .in       ( inb      ),
    .out      ( inbz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule


//--------------------------------------------------------------------------------------------------------
// Module  : fxp_mul
// Type    : synthesizable
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: multiplication
//           combinational logic
//--------------------------------------------------------------------------------------------------------

module fxp_mul # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter ROUND= 1
)(
    input  wire [WIIA+WIFA-1:0] ina,
    input  wire [WIIB+WIFB-1:0] inb,
    output wire [WOI +WOF -1:0] out,
    output wire                 overflow
);

localparam WRI = WIIA + WIIB;
localparam WRF = WIFA + WIFB;

wire signed [WRI+WRF-1:0] res = $signed(ina) * $signed(inb);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule

//--------------------------------------------------------------------------------------------------------
// Module  : fxp_addsub
// Type    : synthesizable
// Standard: Verilog 2001 (IEEE1364-2001)
// Function: addition and subtraction
//           combinational logic
//--------------------------------------------------------------------------------------------------------

module fxp_addsub # (
    parameter WIIA = 8,
    parameter WIFA = 8,
    parameter WIIB = 8,
    parameter WIFB = 8,
    parameter WOI  = 8,
    parameter WOF  = 8,
    parameter ROUND= 1
)(
    input  wire [WIIA+WIFA-1:0] ina,
    input  wire [WIIB+WIFB-1:0] inb,
    input  wire                 sub, // 0=add, 1=sub
    output wire [WOI +WOF -1:0] out,
    output wire                 overflow
);

localparam WIIBE = WIIB + 1;
localparam   WII = WIIA>WIIBE ? WIIA : WIIBE;
localparam   WIF = WIFA>WIFB  ? WIFA : WIFB;
localparam   WRI = WII + 1;
localparam   WRF = WIF;

localparam [WIIBE+WIFB-1:0] ONE = 1;
wire [WIIBE+WIFB-1:0] inbe;
wire [   WII+WIF-1:0] inaz, inbz;
wire [WIIBE+WIFB-1:0] inbv = sub ? (~inbe)+ONE : inbe;
wire signed [WRI+WRF-1:0] res = $signed(inaz) + $signed(inbz);

fxp_zoom # (
    .WII      ( WIIB     ),
    .WIF      ( WIFB     ),
    .WOI      ( WIIBE    ),
    .WOF      ( WIFB     ),
    .ROUND    ( 0        )
) inb_extend (
    .in       ( inb      ),
    .out      ( inbe     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WIIA     ),
    .WIF      ( WIFA     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) ina_zoom (
    .in       ( ina      ),
    .out      ( inaz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WIIBE    ),
    .WIF      ( WIFB     ),
    .WOI      ( WII      ),
    .WOF      ( WIF      ),
    .ROUND    ( 0        )
) inb_zoom (
    .in       ( inbv     ),
    .out      ( inbz     ),
    .overflow (          )
);

fxp_zoom # (
    .WII      ( WRI            ),
    .WIF      ( WRF            ),
    .WOI      ( WOI            ),
    .WOF      ( WOF            ),
    .ROUND    ( ROUND          )
) res_zoom (
    .in       ( $unsigned(res) ),
    .out      ( out            ),
    .overflow ( overflow       )
);

endmodule