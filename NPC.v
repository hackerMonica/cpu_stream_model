module NPC (
    input wire [31:0]pc,
    input wire [31:0]imm,
    input wire [31:0]ra,
    input wire [2:1]NPCop,
    input wire branchin,
    output reg [31:0]pc4,
    output reg [31:0]npc,
    output reg branch
);
    always @(*) begin
        pc4=pc+4;
        case(NPCop[2:1])
            2'b00:  npc=pc+4;
            2'b01:  npc=imm+pc;
            2'b10:  npc=ra;
            2'b11:begin
                case(branchin)
                    1'b0:   npc=pc+4;
                    1'b1:   npc=pc+imm;
                endcase
            end
        endcase
    end

    always @(*) begin
        if (branchin) begin
            branch=1;
        end else begin
            case (NPCop[2:1])
                2'b10,2'b11,2'b01: branch=1;
                default: branch=0;
            endcase
        end
    end
endmodule