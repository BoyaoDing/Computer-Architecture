## 1

#### a.

指令①和②之间存在关于R1的写后读相关
指令①和③之间存在关于R1的写后读相关
指令②和③之间存在关于R1的写后读相关
指令④和⑤之间存在关于R2的写后读相关
指令⑤和⑥之间存在关于R4的写后读相关

#### b.

该流水线的时序：$ins① \rightarrow bubble \rightarrow bubble \rightarrow bubble \rightarrow ins② \rightarrow bubble \rightarrow bubble \rightarrow bubble \rightarrow ins③ \\ \rightarrow ins④ \rightarrow bubble \rightarrow bubble \rightarrow bubble \rightarrow ins⑤ \rightarrow bubble \rightarrow bubble \rightarrow bubble \rightarrow ins⑥\\ \rightarrow bubble \rightarrow bubble \rightarrow ins①$

如果所有的存储器引用耗时一个周期，那么这一循环需要执行的周期数为：

首先，循环一次需要的周期数为24，显然循环会执行$396 \div 4=99$次，所以执行这一循环需要的周期总数为$24 \times 99 = 2376$

#### c.

对于拥有完整旁路定向路径的5级RISC流水线的时序为

$ins① \rightarrow stall \rightarrow ins② \rightarrow ins③ \rightarrow ins④  \rightarrow ins⑤ \rightarrow ins⑥\\ \rightarrow next\_ins⑥ \rightarrow next\_ins⑥+1 \rightarrow ins①$

此时循环一次需要的周期数为13，循环执行99次，那么执行这一循环需要的周期总数为$13 \times 99 = 1287$

#### d.

此时的时序为：

$ins① \rightarrow stall \rightarrow ins② \rightarrow ins③ \rightarrow ins④  \rightarrow ins⑤ \rightarrow ins⑥ \rightarrow ins①$

此时循环一次需要的周期数为11，循环执行99次，那么需要的周期总数为$11 \times 99 = 1089$

## 2

其时空图如下图所示。

吞吐率为：$\frac{7}{16\Delta t}$

加速比为：$\frac{5*4 + 3 * 3}{16} = \frac{29}{16}$

各段的效率为：1段为$\frac{7}{16}$，2段为$\frac{3}{16}$，3段为$\frac{8}{16} = \frac{1}{2}$，4段为$\frac{4}{16} = \frac{1}{4}$，5段为$\frac{7}{16}$







| add  | 1    | 3    |      | 4    | 5    |      |      |      |      |      |      |      |      |      |      |      |      |      |      |
| ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| add  |      |      | 1    | 3    |      | 4    | 5    |      |      |      |      |      |      |      |      |      |      |      |      |
| mul  |      |      |      |      |      | 1    | 2    | 5    |      |      |      |      |      |      |      |      |      |      |      |
| add  |      |      |      |      |      |      | 1    | 3    |      | 4    | 5    |      |      |      |      |      |      |      |      |
| mul  |      |      |      |      |      |      |      |      |      | 1    | 2    | 5    |      |      |      |      |      |      |      |
| add  |      |      |      |      |      |      |      |      |      |      | 1    | 3    |      | 4    | 5    |      |      |      |      |
| mul  |      |      |      |      |      |      |      |      |      |      |      |      |      | 1    | 2    | 5    |      |      |      |

## 3

#### a.

在仅考虑数据相关时，假设同样执行60条指令，12级流水线对5级流水线的加速比为：$[(60 * \frac{1}{5} + 60) * 1ns]/[(60 * \frac{3}{8} + 60) * 0.6ns] = \frac{16}{11}$

#### b.

第一种的CPI为：$(n * \frac{1}{5} + n + 20\% * n * 5\% * 2) / n = 1.22$

第二种的CPI为：$(n * \frac{3}{8} + n + 20\% * 5\% * n * 5) = 1.425$