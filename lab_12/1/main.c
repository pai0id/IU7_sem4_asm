#include <stdio.h>

#define MAX_LEN 30

int getLenC(char *str) {
    int i = 0;
    while (str[i]!= '\0') {
        i++;
    }
    return i;
}

int getLenAsm(char *str) {
    int res;
    
    asm volatile (
        "str	wzr, [sp, #28]\n\t"
        "loop:\n\t"
        "ldr	w0, [sp, #28]\n\t"
        "add	w0, w0, #0x1\n\t"
        "str	w0, [sp, #28]\n\t"
        "ldrsw	x0, [sp, #28]\n\t"
        "ldr	x1, %[str]\n\t"
        "add	x0, x1, x0\n\t"
        "ldrb	w0, [x0]\n\t"
        "cmp	w0, #0x0\n\t"
        "b.ne	loop\n\t"
        "ldr	%[result], [sp, #28]\n\t"
        : [result] "=r" (res)
        : [str] "m" (str));

    return res;
}

int main() {
    char str[MAX_LEN] = "1234567";

    printf("StrLenC = %d\n", getLenC(str));
    printf("StrLenAsm = %d\n", getLenAsm(str));
    
    return 0;
}

