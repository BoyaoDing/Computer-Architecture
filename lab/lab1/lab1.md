# Lab1-CPU设计报告

## 基本指令格式

#### 指令类型

所有指令都是32位长，在内存中是四字节对齐的。

所有指令的*rs1、rs2、rd*都是在相同的位置，立即数都是有符号的位扩展(signed-extended)，立即数的符号位总是在指令的第31位。

![image-20200310163017754](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310163017754.png)

共6种指令格式，R/I/S/B/U/J

S和B类型的区别是立即数的位数的位置不同，B类中的立即数是乘以2以后的数据，并且保持了符号位和imm[10:1]的位置不变，只需要处理imm[11]

在U-type中，立即数是左移了12位的，在J-type中立即数是左移了1位的，并且保持了符号位的位置

下图显示了各类指令中的imm所扩展成的32位的立即数：

![image-20200310170148981](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310170148981.png)

#### 整数计算指令指令

##### I类指令

![image-20200310170256420](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310170256420.png)

* ADDI: rd = rs1 + imm
* SLTI[U]: if(rs1 < imm) rd = 1;else rd = 0;（SLTI是有符号数，SLTIU是无符号数）
* ANDI: rd = rs1 and imm
* ORI: rd = rs1 or imm
* XORI: rd = rs1 xor imm

![image-20200310170744361](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310170744361.png)

* 移位指令将rs1中的数移位imm[4:0]位（最多32位，所以只用5位立即数）存到rd中。

##### U类指令

![image-20200310171807132](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310171807132.png)

* LUI(load upper immediate)：存放立即数到rd，其中高20位是imm[31:12]，低12位为0
* AUIPC(add upper immediate to pc)：创建PC的相对地址，rd = imm + PC

##### R类指令

![image-20200310172238605](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310172238605.png)

#### 控制转换指令

##### 无条件跳转指令

![image-20200311150148280](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200311150148280.png)

* JAL(jmp and link)：将当前指令的下一条指令地址(pc + 4)存入rd寄存器，可以跳转到$\pm1MiB$范围的地址，使用J类指令格式

![image-20200311150923933](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200311150923933.png)

* JALR：使用I类指令格式，跳转到rs1 + offest的位置，将pc + 4存入rd

##### 条件跳转指令

![image-20200311151141600](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200311151141600.png)

* BEQ\BNE\BLT\BGE：使用B类指令格式，offset的寻址范围是$\pm4KiB$，当rs1和rs2寄存器满足关系时跳转

#### 访存指令

![image-20200311151519012](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200311151519012.png)

* Load：使用I类指令，将rs1 + offset地址的width大小的值取出存入rd中。LW(32位)、LH(16位，sign-extend)、LHU(16位，unsign-extend)、LB(8位)、LBU
* Store：使用S类指令，将rs2中width大小的数据存入rs1 + offset的地址中。SW、SH、SB

#### 控制和状态寄存器指令

![image-20200320155412679](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200320155412679.png)

* CSRRW：CSRRW 指令读取在 CSR 中的旧值，将其**零扩展**到 XLEN 位，然后写入整数寄存器 rd 中。rs1 寄存器 中的值将被写入 CSR 中。
* CSRRS：该指令读取 CSR 的值，将其**零扩展**到 XLEN 位，然 后写入整数寄存器 rd 中。整数寄存器 rs1 中的初始值被当做按位掩码指明了哪些 CSR 中的 位被置为 1。rs1 中的任何为 1 的位，将导致 CSR 中对应位被置为 1，如果 CSR 中该位是可 以写的话。
* CSRRC：该指令读取 CSR 的值，将其**零扩展**到 XLEN 位， 然后写入整数寄存器 rd 中。整数寄存器 rs1 中的初始值被当做按位掩码指明了哪些 CSR 中 的位被置为 0。
* CSRRWI 指令、CSRRSI 指令、CSRRCI 指令分别于 CSRRW 指令、CSRRS 指令、CSRRC 指令 相似，除了它们是使用一个处于 rs1 字段的、零扩展到 XLEN 位的 5 位立即数（zimm[4:0]） 而不是使用 rs1 整数寄存器的值。对于 CSRRSI 指令和CSRRCI 指令，如果 zimm[4:0]字段是零， 那么这些指令将不会写 CSR

## 重要模块设计思路

#### ALU

##### 接口

ALU有两个32位操作数的输入Oprend1、Oprend2，一个32位的输出AluOut和一个4位的控制信号AluContrl

##### 功能与实现

| AluContrl | Function               |
| --------- | ---------------------- |
| 0000      | Shift Left Logical     |
| 0001      | Shift Right Logical    |
| 0010      | Shift Right Arithmetic |
| 0011      | ADD                    |
| 0100      | SUB                    |
| 0101      | XOR                    |
| 0110      | OR                     |
| 0111      | AND                    |
| 1000      | Set Less Than          |
| 1001      | Set Less Than Unsign   |
| 1010      | LUI                    |

#### BranchDecision

##### 接口

一个3位输入BranchTypeE，两个32位输入Operand1、Operand2和一个1位的输出BranchE。

##### 功能与实现

该模块用来产生Branch的信号。

| BranchTypeE | Function                          |
| ----------- | --------------------------------- |
| 000         | BranchE = 0                       |
| 001         | BranchE = (Operand1 == Operand2)  |
| 010         | BranchE = (Operand1 != Operand2)  |
| 011         | BranchE = (Operand1 < Operand2)   |
| 100         | BranchE = (uOperand1 < uOperand2) |
| 101         | BranchE = (Operand1 > Operand2)   |
| 110         | BranchE = (uOperand1 > uOperand2) |

#### ControlUnit

##### 接口

| 名称        | 位数 | 描述                                                         |
| ----------- | ---- | ------------------------------------------------------------ |
| Op          | 7    | 输入，接ins[6:0]                                             |
| fn3         | 3    | 输入，接ins[14:12]                                           |
| fn7         | 7    | 输入，接ins[31:25]                                           |
| JalD        | 1    | 输出，表示Jal指令到达ID译码阶段                              |
| JalrD       | 1    | 输出，表示Jalr指令到达ID译码阶段                             |
| RegWriteD   | 3    | 输出，表示ID阶段的指令对应的寄存器写入模式                   |
| MemToRegD   | 1    | 输出，表示当前指令需要将内存读出的数据写到寄存器             |
| MemWriteD   | 4    | 输出，表示当前指令需要写入内存                               |
| LoadNpcD    | 1    | 输出，表示将NextPC输出到ResultM                              |
| RegReadD    | 2    | 输出，RegReadD[1] == 1表示寄存器堆中A1寄存器的值被用到了；RegReadD[0] == 1表示A2寄存器的值被用到了 |
| BranchTypeD | 3    | 输出，用来表示分支的类型                                     |
| AluContrlD  | 4    | 输出，用来控制ALU不同的计算功能                              |
| AluSrc2D    | 2    | 输出，表示Alu输入源2的选择                                   |
| AluSrc1D    | 1    | 输出，表示Alu输入源1的选择                                   |
| ImmType     | 3    | 输出，表示指令立即数的格式                                   |

##### 功能与实现

该模块用来产生控制信号。

* JalD：判断op是否是1101111（Jal指令）
* JalrD：判断op是否是1100111（Jalr指令）
* RegWriteD：当指令是R类、U类、J类和I类指令（除去Load指令）时，RegWriteD = LW；当指令是Load指令时，RegWriteD根据fn3的值来赋值
* MemToRegD：当指令时Load指令时为1，否则为0
* MemWriteD：当指令为store指令时，它采用独热码格式，对于data memory的32bit字按byte进行写入，MemWriteD=0001表示只写入最低1个byte，根据fn3来赋值；否则MemWriteD = 0
* LoadNpcD：当指令为J类指令时为1，否则为0
* RegReadD：当指令为R类、S类或B类指令时，A1和A2都被用到，RegReadD = 2'b11；当指令为I类指令时，只有A1被用到，RegReadD = 2'b10；其余情况下A1和A2都没被用到，RegReadD = 2'b00
* BranchTypeD：当指令为B类指令时，BranchType根据fn3来赋值；否则BranchType = NOBRANCH
* AluContrlD：当指令为数值计算类指令时（R类和I类中除去Load），根据fn3、fn7来赋值。
* AluSrc2D：当指令为SLLI、SRLI、SRAI时，AluSrc2 = 2'b01；当指令为R类、B类指令时，AluSrc2 = 2'b00；当指令是I类、S类指令和LUI指令时，AluSrc2 = 2'b10
* AluSrc1D：当指令时AUIPC时，AluSrc1 = 1；否则AluSrc1 = 0
* ImmType：根据op来判断不同的指令类型，从而得到ImmType的值

#### RegisterFiles

##### 接口

输入包括时钟输入clk，1个写使能信号we，一个reset信号rst，3个五位的地址输入（分别是2个读寄存器的地址addr1、addr2和1个写寄存器的地址addr3）和1个32位的写寄存器的数据输入wd3；输出包括两个32位的读寄存器输出out1、out2。

##### 功能与实现

在时钟周期的上升沿，如果写使能输入指示可以写入，那么将wd3写入到地址addr3所代表的寄存器中；在时钟周期的下降沿，输出out1为addr1地址对应的寄存器的值，out2为addr2对应的寄存器的值。

#### ImmediateExtend

##### 接口

25位的立即数输入In[31:7]，3位的输入Type用来表示立即数类型，32位的扩展后的立即数输出Out。

##### 功能与实现

该模块用来生成指令中的立即数。

不同指令类型对应的立即数格式如下：

![image-20200310170148981](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310170148981.png)

则根据输入Type确定的指令类型就可得到输出的立即数Out。

#### NPCGenerator

##### 接口

4个32位的地址输入PCF、JalrTarget、BranchTarget、JalTarget，三个跳转标志位输入Jalr、Jal、Branch和一个32位的输出NPC。

##### 功能与实现

该模块用来产生下一条指令的地址。

| 跳转类型 | NPC                |
| -------- | ------------------ |
| Branch   | NPC = BranchTarget |
| Jalr     | NPC = JalrTarget   |
| Jal      | NPC = JalTarget    |
| 无       | NPC = PCF + 4      |

## 问题回答

##### 1. 描述一条ADDI指令的执行过程

1. 取指得到ADDI指令
2. 译码，ControlUnit产生控制信号：RegWriteD = LW，RegReadD = 2'b10，AluContrlD = ADD，AluSrc2D = 2'b10，AluSrc1D = 0，ImmType = I
3. RegisterFiles读出ins[19:15]表示的寄存器的值到RegOut1中，ImmediateExtend将int[31:20]扩展为32位立即数。
4. ALU接到控制信号进行加法
5. 加法得到的结果写回ins[11:7]表示的寄存器中

#### 2. 描述一条Jalr指令执行的过程

1. 取指得到Jalr指令
2. 译码，ControlUnit产生控制信号：JalrD = 1，RegReadD = 2'b10，AluContrlD = ADD，AluSrc2D = 2'b10，AluSrc1D = 0，ImmType = I
3. RegisterFiles读出ins[19:15]表示的寄存器的值到RegOut1中，ImmediateExtend将int[31:20]扩展为32位立即数。
4. ALU进行加法运算得到JalrTarget
5. NPCGenerator接到Jalr的信号将NPC赋值为JalrTarget

#### 3. 描述一条LW指令执行的过程

1. 取指得到LW指令
2. 译码，ControlUnit产生控制信号：RegReadD = 2'b10，AluContrlD = ADD，AluSrc2D = 2'b10，AluSrc1D = 0，ImmType = I，MemToRegD = 1，RegWriteD = LW
3. RegisterFiles读出ins[19:15]表示的寄存器的值到RegOut1中，ImmediateExtend将int[31:20]扩展为32位立即数。
4. ALU进行加法得到需要读取的地址
5. 从存储器中读出对应地址的数据
6. 经过DataExtend进行位扩展
7. 读取到的数据写回ins[11:7]表示的寄存器中

#### 4. 如果要实现CSR指令需要增加什么部件和数据通路

需要增加CSR状态寄存器；需要增加一个立即数扩展单元用来对CSR进行扩展，因为如CSRRWI指令需要同时对两个数字进行扩展；需要增加Immediate unit到CSR的数据通路，用来实现对CSR的改写

#### 5. 那些指令分别采用了五类立即数，请各举至少一例；Verilog如何将立即数扩展为32位的

* 使用I类立即数的指令：一系列Load指令如LW等、各种I类整数计算指令如ADDI等、Jalr
* 使用J类立即数的指令：Jal
* 使用U类立即数的指令：LUI、AUIPC
* 使用S类立即数的指令：一系列Store指令如SW等
* 使用B类立即数的指令：一系列Branch指令如Beq等

Verilog对各类立即数的扩展：

* I类：Out = {21{ins[31]}, ins[30:20]}
* J类：Out = {12{ins[31]}, ins[19:12], ins[20], ins[30:21], 0}
* U类：Out = {ins[31: 12], 12'b0}
* S类：Out = {21{ins[31]}, ins[30:25], ins[11:8], ins[7]}
* B类：Out = {20{ins[31]}ins[7], ins[30:25], ins[11:8], 0}

#### 6. 如何实现DataCache的非字节对齐的Load和Store

Data Extention单元将内存地址的最低两位和RegWrite作为输入，用来判断Load和Store的字节对齐情况。随后根据地址的低两位和RegWrite从DataMem输出的一个字中选取需要的字节或字，然后进行位扩展到32位后输出。

#### 7. ALU模块中，默认的wire变量是有符号数还是无符号数

有符号数

#### 8. 哪条指令的执行过程中LoadNPC = 1

Jal指令

#### 9. NPC Generator中对于不同target的跳转是否有优先级

JalrTarget、JalTarget、BranchTarget跳转的优先级高于PCF的优先级

#### 10. Hazard模块中有哪几类冲突需要加入气泡

* load指令后紧跟的数据读取需要加入气泡
* J类指令的控制流冲突
* B类指令的控制冲突

#### 11. 遇到Branch指令时，如何控制flush和stall信号

在没有分支预测的情况下，会先产生两个stall信号，让流水线等待Branch的判断结果；如果不发生跳转，那么不产生flush，否则产生flush信号。

#### 12. 0号寄存器始终为0，是否会对forward的处理产生影响

会，在一些指令中如果把0号寄存器当作rd来写回，那么不用把它进行转发。