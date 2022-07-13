module top (
    // input wire clk,
    // input wire rst_n,
    // output        debug_wb_have_inst,   // WB阶段是否有指�?? (对单周期CPU，此flag恒为1)
    // output [31:0] debug_wb_pc,          // WB阶段的PC (若wb_have_inst=0，此项可为任意�??)
    // output        debug_wb_ena,         // WB阶段的寄存器写使�?? (若wb_have_inst=0，此项可为任意�??)
    // output [4:0]  debug_wb_reg,         // WB阶段写入的寄存器�?? (若wb_ena或wb_have_inst=0，此项可为任意�??)
    // output [31:0] debug_wb_value        // WB阶段写入寄存器的�?? (若wb_ena或wb_have_inst=0，此项可为任意�??)
    input wire clk,
    input rst_i,
    input  [23:0] switch,
    output [23:0] led,
    output wire led0_en_o,
    output wire led1_en_o,
    output wire led2_en_o,
    output wire led3_en_o,
    output wire led4_en_o,
    output wire led5_en_o,
    output wire led6_en_o,
    output wire led7_en_o,
    output wire led_ca_o,
    output wire led_cb_o,
    output wire led_cc_o,
    output wire led_cd_o,
    output wire led_ce_o,
    output wire led_cf_o,
    output wire led_cg_o,
    output wire led_dp_o
);
    wire rst_n=rst_i;
    reg rst1;
    reg rst2;
    wire rst=rst_n&&~rst2;
    always @(posedge clk_g) begin
        rst2<=rst1;
        rst1<=rst_n;
    end

    assign debug_wb_have_inst=(WB_running==1)? 1:0;
    assign debug_wb_pc=WB_pc;
    assign debug_wb_ena=WB_RFWr;
    assign debug_wb_reg=WB_wR;
    assign debug_wb_value=WB_wD;

    //cpuclk
    // wire clk_g;

    //PC
    wire [31:0] pc;

    wire [31:0] din;
    //NPC
    wire [31:0] npc;
    wire [31:0] pc4;
    wire branch;
    //IROM
    wire [31:0] inst;
    //SEXT
    wire [31:0] ext;
    //CTRL
    wire [2:1] NPCop;
    wire WEn;
    wire [3:0] ALUop;
    wire ASel;
    wire BSel;
    wire [2:0] EXTop;
    wire RFWr;
    wire [1:0] WDSel;
    //RF
    wire [31:0] rD1;
    wire [31:0] rD2;
    
    wire [31:0] wD;
    //ALU
    wire [31:0] C;

    wire [31:0] A;
    wire [31:0] B;
    wire ALU_branch;
    //DRAM
    wire [31:0] rd;

    wire [31:0] wdin;
    //forwarding
    wire [31:0] rD1_;
    wire [31:0] rD2_;
    //forward_loaduse
    wire [31:0] A_;
    wire [31:0] B_;
    //DRAMStore
    wire [31:0] rd_;

    //IF
    wire IF_running;
    wire [31:0] IF_pc=pc;
    wire [31:0] IF_inst=inst;
    //ID
    wire ID_running;
    wire [31:0] ID_pc;
    wire [31:0] ID_inst;

    wire [2:1] ID_NPCop=NPCop;
    wire ID_WEn=WEn;
    wire [3:0] ID_ALUop=ALUop;
    wire ID_RFWr=RFWr;
    wire [1:0] ID_WDSel=WDSel;
    wire [31:0] ID_A=A;
    wire [31:0] ID_rD2=rD2_;
    wire [31:0] ID_B=B;
    wire [31:0] ID_wR=ID_inst[11:7];
    wire [31:0] ID_ext=ext;
    //EX
    wire EX_running;
    wire [31:0] EX_pc;
    wire [2:1] EX_NPCop;
    wire EX_WEn;
    wire [3:0] EX_ALUop;
    wire EX_RFWr;
    wire [1:0] EX_WDSel;
    wire [31:0] EX_A;
    wire [31:0] EX_rR1;
    wire [31:0] EX_rD2;
    wire [31:0] EX_B;
    wire [31:0] EX_rR2;
    wire [31:0] EX_wR;
    wire [31:0] EX_ext;

    wire [31:0] EX_pc4=pc4;
    wire [31:0] EX_C=C;
    //MEM
    wire MEM_running;
    wire MEM_WEn;
    wire MEM_RFWr;
    wire [1:0] MEM_WDSel;
    wire [31:0] MEM_pc;
    wire [31:0] MEM_pc4;
    wire [31:0] MEM_C;
    wire [31:0] MEM_rD2;
    wire [31:0] MEM_wR;
    wire [31:0] MEM_ext;

    wire [31:0] MEM_wD=wD;
    //WB
    wire WB_running;
    wire WB_RFWr;
    wire [31:0] WB_pc;
    wire [31:0] WB_wD;
    wire [31:0] WB_wR;

    //MUX
    assign din=(branch==0)? pc+4 :  npc;
    assign wD= (MEM_WDSel==0? MEM_C:(
        (MEM_WDSel==2'b01)? rd_ :(
            (MEM_WDSel==2'b10)? MEM_pc4 : MEM_ext
        )
    ));
    assign A=(ASel)? ID_pc : rD1_;
    assign B=(BSel)? ext : rD2_;
    assign wdin=MEM_rD2;

    //DRAMStore
    DRAMStore u_DRAMStore(
        .clk (clk_g),
        // .clk (clk),
        .WEn (MEM_WEn),
        .wdin (wdin),
        .adr (MEM_C),
        .rd (rd),
        .rd_ (rd_)
    );
    //forward_loaduse
    forward_loaduse u_forward_loaduse(
        .EX_rR1 (EX_rR1),
        .EX_rR2 (EX_rR2),
        .EX_A (EX_A),
        .EX_B (EX_B),
        .MEM_WDSel (MEM_WDSel),
        .MEM_wR (MEM_wR),
        .MEM_rd_ (rd_),
        .A_ (A_),
        .B_ (B_)
    );
    //forwarding
    forwarding u_forwarding(
        .rD1 (rD1),
        .rD2 (rD2),
        .rR1 (ID_inst[19:15]),
        .rR2 (ID_inst[24:20]),

        .EX_RFWr (EX_RFWr),
        .EX_running (EX_running),
        .EX_wR (EX_wR),
        .EX_C (EX_C),
        .EX_WDSel (EX_WDSel),
        .EX_pc4 (EX_pc4),
        .EX_ext (EX_ext),

        .MEM_RFWr (MEM_RFWr),
        .MEM_running (MEM_running),
        .MEM_wR (MEM_wR),
        .MEM_wD (MEM_wD),

        .WB_RFWr (WB_RFWr),
        .WB_running (WB_running),
        .WB_wR (WB_wR),
        .WB_wD (WB_wD),

        .rD1_ (rD1_),
        .rD2_ (rD2_)
    );
    //reg
    IF_ID u_IF_ID(
        // .clk (clk),
        .clk (clk_g),
        .rst (rst),
        .branch (branch),
        .runningin (IF_running),
        .PCin (IF_pc),
        .instin (IF_inst),
        .running (ID_running),
        .PC (ID_pc),
        .inst (ID_inst)
    );
    ID_EX u_ID_EX(
        // .clk (clk),
        .clk (clk_g),
        .rst (rst),
        .branch (branch),
        .runningin (ID_running),
        .NPCopin (ID_NPCop),
        .WEnin (ID_WEn),
        .ALUopin (ID_ALUop),
        .RFWrin (ID_RFWr),
        .WDSelin (ID_WDSel),
        .PCin (ID_pc),
        .Ain (ID_A),
        .ASel (ASel),
        .rR1in (ID_inst[19:15]),
        .rD2in (ID_rD2),
        .Bin (ID_B),
        .BSel (BSel),
        .rR2in (ID_inst[24:20]),
        .wRin (ID_wR),
        .extin (ID_ext),
        .running (EX_running),
        .NPCop (EX_NPCop),
        .WEn (EX_WEn),
        .ALUop (EX_ALUop),
        .RFWr (EX_RFWr),
        .WDSel (EX_WDSel),
        .PC (EX_pc),
        .A (EX_A),
        .rR1 (EX_rR1),
        .rD2 (EX_rD2),
        .B (EX_B),
        .rR2 (EX_rR2),
        .wR (EX_wR),
        .ext (EX_ext)
    );

    EX_MEM u_EX_MEM(
        // .clk (clk),
        .clk (clk_g),
        .rst (rst),
        .runningin (EX_running),
        .WEnin (EX_WEn),
        .RFWrin (EX_RFWr),
        .WDSelin (EX_WDSel),
        .pcin (EX_pc),
        .pc4in (EX_pc4),
        .Cin (EX_C),
        .rD2in (EX_rD2),
        .wRin (EX_wR),
        .extin (EX_ext),
        .running (MEM_running),
        .WEn (MEM_WEn),
        .RFWr (MEM_RFWr),
        .WDSel (MEM_WDSel),
        .pc (MEM_pc),
        .pc4 (MEM_pc4),
        .C (MEM_C),
        .rD2 (MEM_rD2),
        .wR (MEM_wR),
        .ext (MEM_ext)
    );

    MEM_WB u_MEM_WB(
        // .clk (clk),
        .clk (clk_g),
        .rst (rst),
        .runningin (MEM_running),
        .RFWrin (MEM_RFWr),
        .pcin (MEM_pc),
        .wDin (MEM_wD),
        .wRin (MEM_wR),
        .running (WB_running),
        .RFWr (WB_RFWr),
        .pc (WB_pc),
        .wD (WB_wD),
        .wR (WB_wR)
    );


    PC u_PC(
        .clk    (clk_g),
        // .clk    (clk),
        .rst    (rst),
        .din    (din),
        .pc     (pc),
        .running (IF_running)
    );

    cpuclk u_cpuclk(
        .clk_in1    (clk),
        .clk_out1   (clk_g),
        .locked ()
    );

    NPC u_NPC(
        .NPCop  (EX_NPCop),
        .ra     (C),
        .branchin (ALU_branch),
        .imm    (EX_ext),
        .pc     (EX_pc),
        .npc    (npc),
        .pc4    (pc4),
        .branch (branch)
    );

    SEXT u_SEXT(
        .EXTop  (EXTop),
        .din    (ID_inst[31:7]),
        .ext    (ext)
    );

    prgrom u_prgrom(
        .a      (pc[15:2]),
        .spo    (inst)
    );
//    inst_mem imem(
//        .a      (pc[15:2]),
//        .spo    (inst)
//    );

    RF u_RF(
        .clk    (clk_g),
        // .clk    (clk),
        .rst    (rst),
        .RFWr   (WB_RFWr),
        .rR1    (ID_inst[19:15]),
        .rR2    (ID_inst[24:20]),
        .wR     (WB_wR),
        .wD     (WB_wD),
        .rD1    (rD1),
        .rD2    (rD2),
        .result (digit)
    );

    CTRL u_CTRL(
        .opcode     (ID_inst[6:0]),
        .fun3       (ID_inst[14:12]),
        .fun7       (ID_inst[31:25]),
        .NPCop      (NPCop),
        .WEn        (WEn),
        .ALUop      (ALUop),
        .ASel       (ASel),
        .BSel       (BSel),
        .EXTop      (EXTop),
        .RFWr       (RFWr),
        .WDSel      (WDSel)
    );

    ALU u_ALU(
    .ALUop      (EX_ALUop),
    .A          (A_),
    .B          (B_),
    .branch     (ALU_branch),
    .C          (C)
    );

    wire [31:0] waddr_tmp = MEM_C - 16'h4000;
    // wire [31:0] waddr_tmp = MEM_C;
    dram U_dram(
        // .clk    (clk),
        .clk    (clk_g),
        .we    (MEM_WEn),
        .a      (waddr_tmp[15:2]),
        .d      (wdin),
        .spo    (rd)
    );
//    data_mem dmem(
//        .clk    (clk),
//        .we    (MEM_WEn),
//        .a      (MEM_C[15:2]),
//        .d      (wdin),
//        .spo    (rd)
//    );
  
    // IObus u_IObus(
    //     .rst    (rst),
    //     .clk    (clk_g),
    //     .we     (WEn),
    //     .adr    (C[15:2]),
    //     .wdata  (wdin),     
    //     .switch (switch),
    //     .spo    (rd),
    //     .led    (led),
    //     .digit  (digit)
    // );

    wire [31:0] digit;
    led_display_ctrl u_led_display(
        .clkg    (clk_g),
        .result (digit),
	    .led0_en_o (led0_en_o),
        .led1_en_o (led1_en_o),
        .led2_en_o (led2_en_o),
        .led3_en_o (led3_en_o),
        .led4_en_o (led4_en_o),
        .led5_en_o (led5_en_o),
        .led6_en_o (led6_en_o),
        .led7_en_o (led7_en_o),
	    .led_ca (led_ca_o),
	    .led_cb (led_cb_o),
        .led_cc (led_cc_o),
	    .led_cd (led_cd_o),
	    .led_ce (led_ce_o),
	    .led_cf (led_cf_o),
	    .led_cg (led_cg_o),
	    .led_dp (led_dp_o) 
    );
    

endmodule