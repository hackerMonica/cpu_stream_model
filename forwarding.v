module forwarding (
    input wire [31:0] rD1,
    input wire [31:0] rD2,
    input wire [31:0] rR1,
    input wire [31:0] rR2,

    input wire EX_RFWr,
    input wire EX_running,
    input wire [31:0] EX_wR,
    input wire [31:0] EX_C,
    input wire [1:0] EX_WDSel,
    input wire [31:0] EX_pc4,
    input wire [31:0] EX_ext,

    input wire MEM_RFWr,
    input wire MEM_running,
    input wire [31:0] MEM_wR,
    input wire [31:0] MEM_wD,

    input wire WB_RFWr,
    input wire WB_running,
    input wire [31:0] WB_wR,
    input wire [31:0] WB_wD,

    output reg [31:0] rD1_,
    output reg [31:0] rD2_
);
    always @(*) begin
        if (EX_running&&EX_RFWr&&(EX_wR!=0)&&(rR1==EX_wR)) begin
            case (EX_WDSel)
                0: rD1_=EX_C;
                2: rD1_=EX_pc4;
                3: rD1_=EX_ext; 
                default: rD1_=rD1;
            endcase
        end else if (MEM_running&&MEM_RFWr&&(MEM_wR!=0)&&(rR1==MEM_wR)) begin
            rD1_=MEM_wD;
        end else if (WB_running&&WB_RFWr&&(WB_wR!=0)&&(rR1==WB_wR)) begin
            rD1_=WB_wD;
        end else begin
            rD1_=rD1;
        end

    end

    always @(*) begin
        if (EX_running&&EX_RFWr&&(EX_wR!=0)&&(rR2==EX_wR)) begin
            case (EX_WDSel)
                0: rD2_=EX_C;
                2: rD2_=EX_pc4;
                3: rD2_=EX_ext; 
                default: rD2_=rD2;
            endcase
        end else if (MEM_running&&MEM_RFWr&&(MEM_wR!=0)&&(rR2==MEM_wR)) begin
            rD2_=MEM_wD;
        end else if (WB_running&&WB_RFWr&&(WB_wR!=0)&&(rR2==WB_wR)) begin
            rD2_=WB_wD;
        end else begin
            rD2_=rD2;
        end
    end
    
endmodule