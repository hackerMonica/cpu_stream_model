module forward_loaduse (
    input wire [31:0] EX_rR1,
    input wire [31:0] EX_rR2,
    input wire [31:0] EX_A,
    input wire [31:0] EX_B,

    input wire [1:0] MEM_WDSel,
    input wire [31:0] MEM_wR,
    input wire [31:0] MEM_rd_,

    output reg [31:0] A_,
    output reg [31:0] B_
);
 always @(*) begin
    if (MEM_WDSel==2'b01&&EX_rR1==MEM_wR) begin
        A_=MEM_rd_;
    end else begin
        A_=EX_A;
    end
 end
 always @(*) begin
    if (MEM_WDSel==2'b01&&EX_rR2==MEM_wR) begin
        B_=MEM_rd_;
    end else begin
        B_=EX_B;
    end
 end
    
endmodule