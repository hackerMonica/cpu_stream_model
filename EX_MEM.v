module EX_MEM (
    input clk,
    input rst,

    input wire runningin,
    input wire WEnin,
    input wire RFWrin,
    input wire [1:0] WDSelin,
    input wire [31:0] pcin,
    input wire [31:0] pc4in,
    input wire [31:0] Cin,
    input wire [31:0] rD2in,
    input wire [31:0] wRin,
    input wire [31:0] extin,

    output reg running,
    output reg WEn,
    output reg RFWr,
    output reg [1:0] WDSel,
    output reg [31:0] pc,
    output reg [31:0] pc4,
    output reg [31:0] C,
    output reg [31:0] rD2,
    output reg [31:0] wR,
    output reg [31:0] ext

);

    always @(posedge clk) begin
        if (rst) begin
            running<=0;
            WEn<=0;
            RFWr<=0;
            WDSel<=0;
            pc<=0;
            pc4<=0;
            C<=0;
            rD2<=0;
            wR<=0;
            ext<=0;
        end else begin
            if (runningin) begin
                WEn<=WEnin;
                RFWr<=RFWrin;
                WDSel<=WDSelin;
                pc<=pcin;
                pc4<=pc4in;
                C<=Cin;
                rD2<=rD2in;
                wR<=wRin;
                ext<=extin;
            end
            running<=runningin;
        end
        
    end
    
endmodule