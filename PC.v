module PC (
    input wire clk,
    input wire rst,
    input wire [31:0]din,
    output wire [31:0]pc,
    output reg running
);
    reg [31:0] pcReg=0;
    assign pc=pcReg;
    always @(posedge clk) begin
        if (rst) begin
            pcReg<=0;
        end else begin
            pcReg<=din;
        end
        
    end

    always @(*) begin
        running=1;
    end
endmodule