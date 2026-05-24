# STM32 裸机点灯
纯寄存器操作，手写启动文件和链接脚本，不依赖任何 HAL / 标准库。
## 芯片
STM32F103C8T6（蓝板 / Black Pill）
## 引脚
PA1 → LED
## 编译
arm-none-eabi-gcc \
    -mcpu=cortex-m3 \
    -mthumb \
    -O0 \
    -g \
    -Wall \
    -ffunction-sections \
    -fdata-sections \
    -c main.c \
    -o main.o
arm-none-eabi-gcc \
    -mcpu=cortex-m3 \
    -mthumb \
    -O0 \
    -g \
    -Wall \
    -ffunction-sections \
    -fdata-sections \
    -c SystemInit.c \
    -o SystemInit.o
arm-none-eabi-as \
    -mcpu=cortex-m3 \
    -mthumb \
    -o startup.o \
    startup.s
## 链接
arm-none-eabi-gcc \
    -mcpu=cortex-m3 \
    -mthumb \
    -T linke.ld \
    -nostdlib \
    -Wl,--gc-sections \
    startup.o main.o SystemInit.o \
    -o firmware.elf
## 格式转换
arm-none-eabi-objcopy -O ihex firmware.elf firmware.hex
arm-none-eabi-objcopy -O binary firmware.elf firmware.bin
## 烧录
openocd \
    -f interface/stlink.cfg \
    -f target/stm32f1x.cfg \
    -c "program firmware.hex verify reset exit"
## 文件说明
| 文件 | 用途 |
|------|------|
| `startup.s` | 最小启动文件（向量表 + Reset_Handler） |
| `linke.ld` | 链接脚本（Flash/RAM 布局） |
| `main.c` | 用户程序（寄存器操作 GPIO） |
## 启动流程
