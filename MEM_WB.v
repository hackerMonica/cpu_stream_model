module MEM_WB (
    input wire clk,
    input wire rst,
    
    input wire runningin,
    input wire RFWrin,
    input wire [31:0] pcin,
    input wire [31:0] wDin,
    input wire [31:0] wRin,

    output reg running,
    output reg RFWr,
    output reg [31:0] pc,
    output reg [31:0] wD,
    output reg [31:0] wR
);

    always @(posedge clk) begin
        if (rst) begin
            running<=0;
            // RFWr<=0;
            pc<=0;
            // wD=0;
            // wR=0;
        end else begin
            if (runningin) begin
                RFWr<=RFWrin;
                pc<=pcin;
                wD<=wDin;
                wR<=wRin;
            end
            running<=runningin;
        end
        
    end
    
endmodule