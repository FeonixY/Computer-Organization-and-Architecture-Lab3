module mips
(
input logic clk, reset,
input logic [31:0] readData,
output logic memwrite,
output logic [31:0] writeData, adr
);
logic zero;
logic irwrite, regwrite, ALUsrca, iord, memtoreg, regdst, pcen;
logic [1:0] ALUsrcb, pcsrc;
logic [2:0] ALUcontrol;
logic [5:0] op, funct;

control_unit cu(clk, reset, op, funct, zero,
                memwrite, irwrite, regwrite, ALUsrca,
                iord, memtoreg, regdst, pcen,
                ALUsrcb, pcsrc, ALUcontrol);
datapath dp(clk, reset, irwrite, regwrite, ALUsrca, iord,
            memtoreg, regdst, pcen, ALUsrcb, pcsrc, ALUcontrol,
            readData, zero, op, funct, writeData, adr);

endmodule
