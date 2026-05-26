/*
    最小启动文件做的事情
    1，指定一些信息给编译器，比如cpu架构，指令集，浮点运算单元，统一汇编语言
    2，vectortable 的前两个32位放置 MSP 和 Reset_Handler
    3，复制data
    4，清零bss
    5，跳转SystemInit
    6，跳转main
*/

.unique xxx
.cpu cortex-m3
.fpu softfvp
.thumb