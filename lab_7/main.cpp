#include <iostream>
#include <cstring>

#define STR_SIZE 20
#define OK 0
#define ERR 1

int str_read(FILE *f, char *str, size_t size)
{
    size_t len;

    if (!fgets(str, size, f))
        return ERR;
    len = strlen(str);
    if (len && str[len - 1] == '\n')
    {
        str[len - 1] = 0;
        len--;
    }
    if (!len)
        return ERR;
    return OK;
}

extern "C" long _asmFunc(const char *src, const char *dst, size_t size);

size_t cFunc(const char *str)
{
    size_t length;
    asm volatile (
        "movq %[str], %%rdi\n"    // Переместить адрес строки в RDI
        "xorq %%rax, %%rax\n"     // Очистить регистр RAX (накопитель длины)
        "1:\n"
        "    cmpb $0, (%%rdi)\n"  // Сравнить байт по текущему адресу с нулевым терминатором
        "    je 2f\n"              // Если найден нулевой терминатор, перейти к метке 2
        "    incq %%rax\n"         // Увеличить накопитель длины
        "    incq %%rdi\n"         // Перейти к следующему байту в строке
        "    jmp 1b\n"             // Перейти обратно к метке 1 для продолжения цикла
        "2:\n"
        : "=a" (length)            // Вывод: длина в RAX
        : [str] "r" (str)          // Ввод: адрес строки в RDI
        : "rdi"                    // Разрушаемые: регистр RDI
    );
    return length;
}

int main()
{
    char str1[STR_SIZE], str2[STR_SIZE];
    int rc = str_read(stdin, str1, STR_SIZE);
    if (rc)
        return rc;

    std::cout << cFunc(str1) << std::endl;

    rc = str_read(stdin, str2, STR_SIZE);
    if (rc)
        return rc;

    std::cout << str1 << " " << str2 << std::endl;

    _asmFunc(str1, str2, STR_SIZE);

    std::cout << str1 << " " << str2 << std::endl;

    return OK;
}
