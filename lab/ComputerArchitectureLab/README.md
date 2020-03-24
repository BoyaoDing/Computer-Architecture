Computer Architecture 2020 Lab
=====================
实验成绩占课程成绩的40%，实验验收方式主要为课堂当面验收和实验报告的提交。  
本学期计划实验时长为10周  

* Lab1（4-5周）【15%】： 熟悉RISC-V指令集，完成RV32I指令集流水线CPU的设计报告；
* Lab2 （第6周清明假期）（7-9周）【40%】： 配置和使用RISCV编译工具链；完成RV32I流水线CPU的Verilog代码；利用RISCV-test测试文件进行仿真和CPU功能验证
* Lab3（第10周五一假期）（第11-12周）【20%】： cache设计和实现
* Lab4（13-14周）【15%】： 分支预测设计与实现
* Lab5（第15周）【10%】：学习使用提供的Tomasulo软件模拟器和多Cache一致性软件模拟器，并完成实验报告

## 签到与补交

* 学生总数140人左右，每周开两次实验课，内容完全一样，**可二选一参加**  
* 验收和报告**补交**在**一周内扣除20%成绩**，介于**一周两周之内补交扣除40%成绩**，**超过两周不予验收**。  
* **为了照顾对流水线不熟悉的学生和鼓励实验课出勤，每堂课设置签到。**（每次实验课开始15分钟后停止签到，实验课结束半小时前可以签离，每周两个实验时间段任选其一参加，有签到和签离就算当周满勤）。  
* **上周和本周连续两次满勤可以申请本周实验晚交一周不做扣分处理。**（比如Lab2阶段一验收是第6周，如果到了第6周实验课结束了实验还没做完，如果你第5周和第6周都满勤，可以在第6周签离时向助教申请晚交一周同时不扣分。）希望对流水线和verilog不熟悉的同学可以积极参与实验课，届时有问题多查阅资料，和同学沟通。
* **签到记录不以其他方式影响成绩**


## 实验发布、验收和报告
老师发布后两周内完成，上交。

提交格式：LabX-学号-姓名-n.pdf 要求包括一份pdf格式实验报告,X第几次实验。n代表提交版本号，从0开始，以最大版本提交文件为准。

## 实验课安排

  提前一周通知，计算机体系结构QQ群（966158118）同步通知

## 文件夹目录
>**1_VerilogSourceCode** Verilog源代码  
>
>>**1_CPUCore_src CPU** CPU core的verilog代码  
>>**2_Simulation** 仿真用testBench代码  
>
>**2_BRAMInputFileGenerator** 脚本文件，利用汇编文件生成对应的16进制指令流文件
>
>**3_CacheLab** Lab3所需的verilog代码和单元测试文件，详情见文件夹readme 
>
>**4_ProjectDesignFiles** 包含CPU的流水线模块设计图  
>**5_DetailDocuments** 包含每次实验的具体实验要求  
>
>**6_branch_prediction** 包含Lab4所需要的代码

## Quickstart
* 新实验发布时会在群里面统一公告。  
* 动手做新实验时，请先进入**5_DetailDocuments**目录下，**查找本次实验对应的文档，并根据文档完成实验和试验报告。**  


* 完善2_BRAMInputFileGenerator脚本文件，调用Utils文件夹中编译好的**Ubuntu64bit**的riscv工具链，**makefile将不需要用户自己安装riscv-tools**；同时删除多余的.S文件
* 1_VerilogSourceCode/2_Simulation/中增加利用2_BRAMInputFileGenerator处理好的**testAll测试二进制文件(.inst 和 .data)以及对应的反汇编代码(.txt)**
*release Lab3代码和Lab3实验要求**，代码见新增**3_CacheLab**文件夹，实验要求见更新后的**5_DetailedDoucuents**
*release Lab4代码和Lab4实验要求**，代码见新增**6_branch_prediction**文件夹，实验要求见更新后的**5_DetailedDoucuents**
*release Lab5实验要求**（**5_DetailedDoucuents/Lab5-多Cache一致性与Tomasulo模拟器使用.docx**），需要用到的软件模拟器请自行获取

