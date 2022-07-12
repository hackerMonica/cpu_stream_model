module IF_ID (
    input wire clk,
    input wire rst,
    input wire branch,
    input wire runningin,
    input wire [31:0] PCin,
    input wire [31:0] instin,
    output reg running,
    output reg [31:0] PC,
    output reg [31:0] inst
);
    always @(posedge clk) begin
        if (rst||branch) begin
            running<=0;
            PC<=0;
            inst<=0;
        end else begin
            if (runningin) begin
                PC<=PCin;
                inst<=instin;
            end
            running<=runningin;
        end
        
    end
endmodule