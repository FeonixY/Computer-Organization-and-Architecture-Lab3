module register_file
(
input logic clk,
input logic writeEnable,
input logic [4:0] writeAddress,
input logic [31:0] writeData,
input logic [4:0] ra1, ra2,
output logic [31:0] rd1, rd2
);
logic [31:0] rf[31:0];

always_ff @(posedge clk)
    if (writeEnable) rf[writeAddress] <= writeData;

assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
assign rd2 = (ra2 != 0) ? rf[ra2] : 0;

endmodule
