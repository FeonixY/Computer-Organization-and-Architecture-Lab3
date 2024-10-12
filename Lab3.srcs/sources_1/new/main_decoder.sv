module main_decoder
(
input logic clk, reset,
input logic [5:0] op,
output logic pcwrite, memwrite, irwrite, regwrite, ALUsrca, branch, branchbne, iord, memtoreg, regdst,
output logic [1:0] ALUsrcb, pcsrc,
output logic [2:0] aluop
);
localparam FETCH   = 4'b0000;
localparam DECODE  = 4'b0001;
localparam MEMADR  = 4'b0010;
localparam MEMRD   = 4'b0011;
localparam MEMWB   = 4'b0100;
localparam MEMWR   = 4'b0101;
localparam RTYPEEX = 4'b0110;
localparam RTYPEWB = 4'b0111;
localparam BEQEX   = 4'b1000;
localparam ADDIEX  = 4'b1001;
localparam ADDIWB  = 4'b1010;
localparam JEX     = 4'b1011;
localparam BNEEX   = 4'b1100;
localparam ANDIEX  = 4'b1101;
localparam ORIEX   = 4'b1110;

localparam LW      = 6'b100011;
localparam SW      = 6'b101011;
localparam RTYPE   = 6'b000000;
localparam BEQ     = 6'b000100;
localparam BNE     = 6'b000101;
localparam ADDI    = 6'b001000;
localparam ANDI    = 6'b001100;
localparam ORI     = 6'b001101;
localparam J       = 6'b000010;

logic [3:0] state, nextstate;
logic [16:0] controls;

always_ff @(posedge clk or posedge reset)
    if(reset) state <= FETCH;
    else state <= nextstate;

always_comb
    case (state)
        FETCH:   nextstate = DECODE;
        DECODE:  case (op)
                LW:      nextstate = MEMADR;
                SW:      nextstate = MEMADR;
                RTYPE:   nextstate = RTYPEEX;
                BEQ:     nextstate = BEQEX;
                BNE:     nextstate = BNEEX;
                ADDI:    nextstate = ADDIEX;
                ANDI:    nextstate = ANDIEX;
                ORI:     nextstate = ORIEX;
                J:       nextstate = JEX;
                default: nextstate = 4'bxxxx;
            endcase
        MEMADR:  case (op)
                LW:      nextstate = MEMRD;
                SW:      nextstate = MEMWR;
                default: nextstate = 4'bxxxx;
            endcase
        MEMRD:   nextstate = MEMWB;
        MEMWB:   nextstate = FETCH;
        MEMWR:   nextstate = FETCH;
        RTYPEEX: nextstate = RTYPEWB;
        RTYPEWB: nextstate = FETCH;
        BEQEX:   nextstate = FETCH;
        BNEEX:   nextstate = FETCH;
        ADDIEX:  nextstate = ADDIWB;
        ANDIEX:  nextstate = ADDIWB;
        ORIEX:   nextstate = ADDIWB;
        ADDIWB:  nextstate = FETCH;
        JEX:     nextstate = FETCH;
        default: nextstate = 4'bxxxx;
    endcase

assign {pcwrite, memwrite, irwrite, regwrite,
        ALUsrca, branch, branchbne, iord, memtoreg, regdst,
        ALUsrcb, pcsrc, aluop} = controls;

always_comb
    case (state)
        FETCH:   controls = 17'b10100000000100000;
        DECODE:  controls = 17'b00000000001100000;
        MEMADR:  controls = 17'b00001000001000000;
        MEMRD:   controls = 17'b00000001000000000;
        MEMWB:   controls = 17'b00010000100000000;
        MEMWR:   controls = 17'b01000001000000000;
        RTYPEEX: controls = 17'b00001000000000100;
        RTYPEWB: controls = 17'b00010000010000000;
        BEQEX:   controls = 17'b00001100000001001;
        BNEEX:   controls = 17'b00001110000001001;
        ADDIEX:  controls = 17'b00001000001000000;
        ANDIEX:  controls = 17'b00001000001000010;
        ORIEX:   controls = 17'b00001000001000011;
        ADDIWB:  controls = 17'b00010000000000000;
        JEX:     controls = 17'b10000000000010000;
        default: controls = 17'bxxxxxxxxxxxxxxxxx;
    endcase

endmodule
