volatile unsigned int *reg;
unsigned int val;

int main(void) {
    // 偏移地址：0x18 0x4002 1000 - 0x4002 13FF 复位和时钟控制(RCC) 
    // 0x4001 0800 - 0x4001 0BFF GPIO端口A 

    /* 开启gpioa的时钟 */
    reg = (volatile unsigned int *)(0x40021000 + 0x18);
    val = *reg;
    val |= (1 << 2);
    *reg = val;

    /* 配置pa1引脚 */
    reg = (volatile unsigned int *)(0x40010800 + 0x00);
    /* 推挽输出 10mhz */
    val = *reg;
    val &= ~(0xF << 4);
    val |= (1 << 4);
    *reg = val;

    /* light */
    reg = (volatile unsigned int *)(0x40010800 + 0x10);
    *reg = (1 << 1);
    
    while (1) {
        /* blink */
        *reg = (1 << 1);
        for (volatile int i = 50000; i > 0; i--);
        *reg = (1 << 17);
        for (volatile int i = 50000; i > 0; i--);
    }
    return 0;
}