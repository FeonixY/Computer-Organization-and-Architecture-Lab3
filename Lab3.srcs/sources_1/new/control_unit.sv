module control_unit
(
input logic clk, reset,
input logic [5:0] op, funct,
input logic zero,
output logic memwrite, irwrite, regwrite, ALUsrca, iord, memtoreg, regdst, pcen,
output logic [1:0] ALUsrcb, pcsrc,
output logic [2:0] alucontrol
);
logic pcwrite, branch, branchbne;
logic [2:0] aluop;

main_decoder maindec(clk, reset, op, pcwrite, memwrite, irwrite, regwrite,
                    ALUsrca, branch, branchbne, iord, memtoreg, regdst,
                    ALUsrcb, pcsrc, aluop);
alu_decoder aludec(funct, aluop, alucontrol);

assign pcen = (zero & branch) | pcwrite | (~zero & branchbne);
endmodule
