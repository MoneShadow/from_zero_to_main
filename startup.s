/*
    最小启动文件做的事情
    1，指定一些信息给编译器，比如cpu架构，指令集，浮点运算单元，统一汇编语言
    2，vectortable 的前两个32位放置 MSP 和 Reset_Handler
    3，复制data
    4，清零bss
    5，跳转SystemInit
    6，跳转main
*/

.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.global isr_vector
.global Default_Handler

.equ BootRAM, 0xF108F85F

.section .text.Reset_Handler
.weak Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    /* 复制data段 */
    ldr r1, =_sidata
    ldr r2, =_sdata
    ldr r3, =_edata
    b LoopCopyData
CopyData:
    ldr r0, [r1], #4
    str r0, [r2], #4
    b LoopCopyData
LoopCopyData:
    cmp r2, r3
    bcc CopyData
    /* 清零bss段 */
    mov r0, #0
    ldr r1, =_sbss
    ldr r2, =_ebss
    b LoopFillZeroBss    
FillZeroBss:
    str r0, [r1], #4
    b LoopFillZeroBss
LoopFillZeroBss:
    cmp r1, r2
    bcc FillZeroBss
    /* 跳转SystemInit main */
    bl SystemInit
    bl main
    b .

.section .text.Default_Handler
Default_Handler:
    b .

.section .isr_vector,"a"
isr_vector:
    .word _estack
    .word Reset_Handler