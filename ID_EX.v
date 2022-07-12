module ID_EX (
    input wire clk,
    input wire rst,
    input wire branch,

    input wire runningin,
    input wire [2:1] NPCopin,
    input wire WEnin,
    input wire [3:0] ALUopin,
    input wire RFWrin,
    input wire [1:0] WDSelin,
    input wire [31:0] PCin,
    input wire [31:0] Ain,
    input wire ASel,
    input wire [31:0] rR1in,
    input wire [31:0] rD2in,
    input wire [31:0] Bin,
    input wire BSel,
    input wire [31:0] rR2in,
    input wire [31:0] wRin,
    input wire [31:0] extin,

    output reg running,
    output reg [2:1] NPCop,
    output reg WEn,
    output reg [3:0] ALUop,
    output reg RFWr,
    output reg [1:0] WDSel,
    output reg [31:0] PC,
    output reg [31:0] A,
    output reg [31:0] rR1,
    output reg [31:0] rD2,
    output reg [31:0] B,
    output reg [31:0] rR2,
    output reg [31:0] wR,
    output reg [31:0] ext
);
    always @(posedge clk) begin
        if (rst||branch) begin
            running<=0;
            NPCop<=0;
            WEn<=0;
            ALUop<=0;
            RFWr<=0;
            WDSel<=0;
            PC<=0;
            A<=0;
            rR1<=0;
            rD2<=0;
            B<=0;
            rR2<=0;
            wR<=0;
            ext<=0;
        end else begin
            if (runningin) begin
                NPCop<=NPCopin;
                WEn<=WEnin;
                ALUop<=ALUopin;
                RFWr<=RFWrin;
                WDSel<=WDSelin;
                PC<=PCin;
                A<=Ain;
                case (ASel)
                    0: rR1<=rR1in;
                    default: rR1<=-1;
                endcase
                
                rD2<=rD2in;
                B<=Bin;
                case (BSel)
                    0: rR2<=rR2in;
                    default: rR2<=-1;
                endcase
                
                wR<=wRin;
                ext<=extin;
            end
            running<=runningin;
        end
        
    end
    
endmodule