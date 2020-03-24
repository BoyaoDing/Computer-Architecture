`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB (Embeded System Lab)
// Engineer: Haojun Xia
// Create Date: 2019/02/08
// Design Name: RISCV-Pipline CPU
// Module Name: ALU
// Target Devices: Nexys4
// Tool Versions: Vivado 2017.4.1
// Description: ALU unit of RISCV CPU
//////////////////////////////////////////////////////////////////////////////////
`include "Parameters.v"   
module ALU(
    input wire [31:0] Operand1,
    input wire [31:0] Operand2,
    input wire [3:0] AluContrl,
    output reg [31:0] AluOut
    );
    
    always@(*)
    begin
        case (AluContrl)
            `ADD:begin
                AluOut = Operand1 + Operand2;
            end 
            `SUB:begin
                AluOut = Operand1 - Operand2;
            end
            `XOR:begin
                AluOut = Operand1 ^ Operand2;
            end
            `OR:begin
                AluOut = Operand1 | Operand2;
            end
            `AND:begin
                AluOut = Operand1 & Operand2;
            end
            `SLT:begin
                if (Operand1 < Operand2)
                    AluOut = 32'd1;
                else
                    AluOut = 32'd0;
            end
            `SLTU:begin
                if ({0, Operand1} < {0, Operand2})
                    AluOut = 32'd1;
                else
                    AluOut = 32'd0;
            end
            `SLL:begin
                AluOut = Operand1 << Operand2;
            end
            `SRL:begin
                AluOut = Operand1 >> Operand2;
            end
            `SRA:begin
                AluOut = Oeprand1 >>> Operand2;
            end
            default: AluOut = 32'd0;
        endcase
    end

endmodule

//功能和接口说明
	//ALU接受两个操作数，根据AluContrl的不同，进行不同的计算操作，将计算结果输出到AluOut
	//AluContrl的类型定义在Parameters.v中
//推荐格式：
    //case()
    //    `ADD:        AluOut<=Operand1 + Operand2; 
    //   	.......
    //    default:    AluOut <= 32'hxxxxxxxx;                          
    //endcase
//实验要求  
    //实现ALU模块