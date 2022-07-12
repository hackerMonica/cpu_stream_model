module DRAMStore (
    input wire clk,
    input wire WEn,
    input wire [31:0] wdin,
    input wire [31:0] adr,
    input wire [31:0] rd,
    output reg [31:0] rd_
);
    reg [31:0] adrReg;
    reg [31:0] wdinReg;
 always @(posedge clk) begin
    if (WEn) begin
        adrReg<=adr;
        wdinReg<=wdin;
    end
 end
    
always @(*) begin
    if ((WEn==0)&&(adr==adrReg)) begin
        rd_=wdinReg;
    end else begin
        rd_=rd;
    end
end
    
endmodule