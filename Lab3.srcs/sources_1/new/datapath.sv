module datapath
(
input logic clk, reset,
input logic irwrite, regwrite, alusrca, iord, memtoreg, regdst, pcen,
input logic [1:0] alusrcb, pcsrc,
input logic [2:0] alucontrol,
input logic [31:0] readData,
output logic zero,
output logic [5:0] op, funct,
output logic [31:0] B, adr
);
logic [27:0] jpc;
logic [31:0] writeData, aluout, pc, pcnext, data, a3;
logic [31:0] immext, immextsl;
logic [31:0] rd1, rd2;
logic [31:0] A;
logic [31:0] srca, srcb;
logic [31:0] aluresult;
logic [31:0] instr;

flopenr #(32) pcreg(clk, reset, pcen, pcnext, pc);
mux2 #(32) pcmux(pc, aluout, iord, adr);
flopenr #(32) irreg(clk, reset, irwrite, readData, instr);
flopenr #(32) wdreg(clk, reset, 1'b1, readData, data);

assign op = instr[31:26];
assign funct = instr[5:0];
mux2 #(32) regdstmux(instr[20:16], instr[15:11], regdst, a3);
mux2 #(32) wdmux(aluout, data, memtoreg, writeData);

register_file rf(clk, regwrite, a3, writeData, instr[25:21], instr[20:16], rd1, rd2);
flopenr #(32) rd1reg(clk, reset, 1'b1, rd1, A);
flopenr #(32) rd2reg(clk, reset, 1'b1, rd2, B);

sign_extend signext(instr[15:0], immext);
mux2 #(32) srcamux(pc, A, alusrca, srca);
shift_left2 immextsl2(immext, immextsl);
mux4 #(32) srcbmux(B, 32'b100, immext, immextsl, alusrcb, srcb);
alu alu(srca, srcb, alucontrol, aluresult, zero);

flopenr #(32) alureg(clk, reset, 1'b1, aluresult, aluout);
shift_left2 jsl2(instr[25:0], jpc);
mux4 #(32) nextpcmux(aluresult, aluout, {4'b0000, jpc}, 32'b0, pcsrc, pcnext);

endmodule
