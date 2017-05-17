`timescale 1ns / 1ps
module ALU(
input [3:0] A, 
input [3:0] B, 
input [3:0] ALUop, 
output reg [3:0] C, 
output reg [3:0] Cond // Z,N,C,V
    );
//
//Write your code below
//

always @ (ALUop, A, B)
begin
	case(ALUop)
		(4'b0000): begin					// Zero_32
			C = 0;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b0001): begin					// A + B
			C = A + B;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
			//Check for C
			if (A + B > 15)
				Cond[1] = 1;
			else
				Cond[1] = 0;
			//Check for V
			if (((A[3] == 0) && (B[3] == 0) && (C[3] == 1)) || ((A[3] == 1) && (B[3] == 1) && (C[3] == 0)))
				Cond[0] = 1;
			else
				Cond[0] = 0;
		end
		(4'b0010): begin					// A - B
			C = A - B;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
			//Check for C
			if (A > B)
				Cond[1] = 1;
			else
				Cond[1] = 0;
			//Check for V
			if (((A[3] == 0) && (B[3] == 1) && (C[3] == 1)) || ((A[3] == 1) && (B[3] == 0) && (C[3] == 0)))
				Cond[0] = 1;
			else
				Cond[0] = 0;
		end
		(4'b0011): begin					// -B
			C = -B;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b0100): begin					// A and B
			C = A & B;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b0101): begin					// A or B
			C = A | B;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b0110): begin					// A xor B
			C = A ^ B;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b0111): begin					// not B
			C = ~ B;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b1000): begin					// Unused
			//Unused
		end
		(4'b1001): begin					// B
			C = B;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b1010): begin					// shiftl A
			C = A << 1;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b1011): begin					// shiftr A
			C = A >> 1;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b1100): begin					// rotl A
			C[0] <= A[0];
			C = A << 1;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b1101): begin					//rotr A
			C[3] <= A[3];
			C = A >> 1;
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b1110): begin					// A + 4
			C = A + (4'b0100);
			
			//Check for Z
			if (C == 0)
				Cond[3] = 1;
			else
				Cond[3] = 0;
			//Check for N
			if (C[3] == 1)
				Cond[2] = 1;
			else
				Cond[2] = 0;
		end
		(4'b1111): begin					// Unused
			//Unused
		end
	endcase
end
	
endmodule