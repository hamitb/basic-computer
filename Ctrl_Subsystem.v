`timescale 1ns / 1ps
module Ctrl_Subsystem(
	input [31:0] Instr,
	input ZE, NG, CY, OV ,
	output reg [4:0] AddrA, AddrB, AddrC,
	output reg [3:0] ALUOp,
	output reg WrC, WrPC, WrCR, WrIR,
	output reg Mem_ALU, PC_RA, IR_RB,
	output reg ALU_PC, ZE_SE, Sin_Sout,
	output reg MemRd,MemWr,
	output reg MemLength,
	output reg MemEnable,
	input MemRdy,
	output reg [2:0] Status, // 0:p_reset, 1:fetch, 2:execute, 3:memop
	input Clk, Reset
    );
	
	localparam p_reset = 3'b000;
	localparam fetch   = 3'b001;
	localparam execute = 3'b010;
	localparam memop   = 3'b011;
	
	localparam Ctrl_delay= 0.5; //500 ps
	localparam Reset_delay= 0.5; //500 ps
	localparam Dec_delay= 3; //3 ns
	localparam MemRd_delay= 2.5; //2500 ps
	localparam MemRd_pulse= MemRd_delay + 3 ; //5500 ps
	localparam MemWr_delay= 2.5; //2500 ps
	localparam MemWr_pulse= MemWr_delay + 3 ; //5500 ps

	reg[5:0] Opcode;
	reg[15:0] Imm;
	reg[15:0] D;
	reg[10:0] PN;
	reg WrMem;
	reg Wr_C;

//
//Write your code below
//

always @(posedge Clk or Reset) begin
	if(Reset) begin
		Status <= #Ctrl_delay fetch;
	end

	if(Clk) begin
		if(Status == p_reset) begin
			Status <= #Ctrl_delay fetch;
		end else if (Status == fetch) begin
			Status <= #Ctrl_delay execute;
		end else if (Status == execute) begin

			if(Opcode == 6'b100000 || Opcode == 6'b100001) begin
				Status <= #Ctrl_delay memop;
			end else if(Opcode == 6'b100010 || Opcode == 6'b100011) begin
				Status <= #Ctrl_delay memop;
			end else begin
				Status <= #Ctrl_delay fetch;
			end
		end else if (Status == memop) begin
				Status <= #Ctrl_delay fetch;
		end
	end
end

always @(Status) begin
	if(Status == p_reset) begin
			ALUOp <= 4'b0000;
			MemRd <= 1'b0;
			MemWr <= 1'b0;
			MemEnable <= 1'b0;
			MemLength <= 1'b0;
		end else if(Status == fetch) begin
			WrCR  <= #Ctrl_delay 1'b0;
			WrC <= #Ctrl_delay 1'b0;

			ALU_PC <= #Ctrl_delay 1'b1;
			MemLength <= #Ctrl_delay 1'b1;
			MemEnable <= #Ctrl_delay 1'b1;
			MemRd <= #MemRd_delay 1'b1;
			MemRd <= #MemRd_pulse 1'b0;
			Sin_Sout <= #Ctrl_delay 1'b0;

			PC_RA <= #Ctrl_delay 1'b0;
			ALUOp <= #Ctrl_delay 4'b1110;
			WrIR  <= #Ctrl_delay 1'b1;
			WrPC  <= #Ctrl_delay 1'b1;
		end else if(Status == execute) begin
			WrIR  <= #Ctrl_delay 1'b0;
			WrPC  <= #Ctrl_delay 1'b0;
			MemEnable <= #Ctrl_delay 1'b0;
		end else if(Status == memop) begin
			ALU_PC <= #Ctrl_delay 1'b0;
			MemEnable <= #Ctrl_delay 1'b1;
			MemLength <= #Ctrl_delay Opcode[0];
			WrC <= #Ctrl_delay Wr_C;

			if(WrMem == 0) begin
				MemRd <= #MemRd_delay 1;
				MemRd <= #Ctrl_delay 0;

				Mem_ALU <= #Ctrl_delay 0;
			end else begin
				MemRd <= #MemRd_delay 1;
				MemRd <= #Ctrl_delay 0;

				Sin_Sout <= #Ctrl_delay 1;
			end
		end
end

always @(Instr) begin
	Opcode[5:0] <= Instr[31:26];
	Imm[15:0] <= Instr[15:0];
	D[15:0] <= Instr[15:0];
	PN[10:0] <= Instr[10:0];

	AddrA <= #Dec_delay Instr[20:16];
	AddrC <= #Dec_delay Instr[25:21];
	if(Opcode == 6'b010001) begin
		PC_RA <= #Ctrl_delay 1;
		ZE_SE <= #Ctrl_delay 1;
		IR_RB <= #Ctrl_delay 0;
		ALUOp <= #Ctrl_delay 4'b0001;
		WrPC  <= #Ctrl_delay 0;
		WrCR  <= #Ctrl_delay 1;
		AddrB <= #Dec_delay Instr[21:15];
		WrMem <= 0;		
	end else if(Opcode == 6'b011000) begin
		PC_RA <= #Ctrl_delay 1;
		ZE_SE <= #Ctrl_delay 0;
		IR_RB <= #Ctrl_delay 1;
		ALUOp <= #Ctrl_delay 4'b0110;
		WrPC  <= #Ctrl_delay 0;
		WrCR  <= #Ctrl_delay 1;
		AddrB <= #Dec_delay Instr[21:15];			
		WrMem <= 0;		
	end else if(Opcode == 6'b100001) begin
		PC_RA <= #Ctrl_delay 1;
		ZE_SE <= #Ctrl_delay 1;
		IR_RB <= #Ctrl_delay 0;
		ALUOp <= #Ctrl_delay 4'b0001;
		WrPC  <= #Ctrl_delay 0;
		WrCR  <= #Ctrl_delay 0;
		AddrB <= #Dec_delay Instr[25:21];	
		WrC 	<= #Ctrl_delay 1;
		Wr_C  <= WrC;
		Mem_ALU <= #Ctrl_delay 1;
		WrMem <= 0;		
	end else if(Opcode == 6'b100010) begin
		PC_RA <= #Ctrl_delay 1;
		ZE_SE <= #Ctrl_delay 1;
		IR_RB <= #Ctrl_delay 0;
		ALUOp <= #Ctrl_delay 4'b0001;
		WrPC  <= #Ctrl_delay 0;
		WrCR  <= #Ctrl_delay 0;
		AddrB <= #Dec_delay Instr[25:21];
		WrC 	<= #Ctrl_delay 0;
		Wr_C  <= WrC;
		Mem_ALU <= #Ctrl_delay 1;
		WrMem <= 1;		
	end
end

always @(MemRdy) begin
	if(MemRdy) begin
		if(Status == memop) begin
			if(WrMem) begin
				Sin_Sout <= #Ctrl_delay 0;
			end
		end
	end
end
endmodule
