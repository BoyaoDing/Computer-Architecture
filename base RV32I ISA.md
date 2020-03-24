# base RV32I ISA

### 寄存器

<img src="C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310111952286.png" alt="image-20200310111952286" style="zoom:67%;" />

XLEN = 32，其中x0寄存器被从硬件上将32位都置为0；PC用来存储下一条指令的地址。

在这个指令集中并没有专用的堆栈指针或子例程返回地址的寄存器，所有的x寄存器都可以被使用。

### 基本指令格式

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

#### ![image-20200310170256420](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310170256420.png)

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

##### NOP指令

![image-20200310173204920](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200310173204920.png)

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

#### Memory Ordering Instructions

![image-20200311152812843](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200311152812843.png)


FENCE指令用于对设备的I / O和内存访问进行排序，这由其他RISCV harts和外部设备或协处理器查看

#### 环境调用和断点

![image-20200311153025757](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200311153025757.png)

#### HINT instructions

![image-20200311153000756](C:\Users\44758\AppData\Roaming\Typora\typora-user-images\image-20200311153000756.png)