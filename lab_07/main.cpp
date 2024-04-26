#include <iostream>
#include <cstring>

#define STR_SIZE 20 + 1
#define OK 0
#define ERR 1

extern "C" void asmFunc(const char *dst, const char *src, size_t size);

size_t cFunc(const char *str)
{
    size_t length;
    asm volatile (
        "movq %[str], %%rdi\n"    // Переместить адрес строки в RDI
        "movq $0xffffffffffffffff, %%rcx\n"
        "xorq %%rax, %%rax\n"
        "repne scasb\n"
        "neg %%rcx\n"
        "dec %%rcx\n"
        "dec %%rcx\n"
        "movq %%rcx, %%rax"
        : "=a" (length)            // Вывод: длина в RAX
        : [str] "r" (str)          // Ввод: адрес строки в RDI
        : "rdi"                    // Разрушаемые: регистр RDI
    );
    return length;
}

int main()
{
    char s[20] = "preved";
    char *s2 = s;

    asmFunc(s2, s, cFunc(s));

    std::cout << s2 << std::endl;

    // std::cout << "Размер строки:" << std::endl;
    // std::cout << "Введите строку: ";
    // std::string str_cnt;
    // std::cin >> str_cnt;
    // std::cout << "Размер: " << cFunc(str_cnt.c_str()) << std::endl;
    // std::cout << "Размер пустой строки: " << cFunc("") << std::endl;

    // std::cout << "Две строки:" << std::endl;
    // std::cout << "Введите первую строку: ";
    // std::string str1;
    // std::cin >> str1;
    // std::cout << "Введите вторую строку: ";
    // std::string str2;
    // std::cin >> str2;
    // char buf1[STR_SIZE], buf2[STR_SIZE];

    // strcpy(buf1, str1.c_str());
    // strcpy(buf2, str2.c_str());
    // std::cout << "Две отдельных строки:" << std::endl;
    // std::cout << buf1 << " " << buf2 << std::endl;
    // asmFunc(buf1, buf2, strlen(buf2));
    // std::cout << buf1 << " " << buf2 << std::endl;

    // strcpy(buf2, str2.c_str());
    // std::cout << "Первая строка - с 3 символа второй: " << std::endl;
    // std::cout << &buf2[2] << " " << buf2 << std::endl;
    // asmFunc(&buf2[2], buf2, strlen(buf2));
    // std::cout << &buf2[2] << " " << buf2 << std::endl;

    // strcpy(buf1, str1.c_str());
    // std::cout << "Вторая строка - с 3 символа первой: " << std::endl;
    // std::cout << buf1 << " " << &buf1[2] << std::endl;
    // asmFunc(buf1, &buf1[2], strlen(buf1));
    // std::cout << buf1 << " " << &buf1[2] << std::endl;

    // strcpy(buf2, str2.c_str());
    // strcpy(buf1, "");
    // std::cout << "Первая строка - пустая: " << std::endl;
    // std::cout << buf1 << " " << buf2 << std::endl;
    // asmFunc(buf1, buf2, strlen(buf2));
    // std::cout << buf1 << " " << buf2 << std::endl;

    // strcpy(buf1, str1.c_str());
    // strcpy(buf2, "");
    // std::cout << "Вторая строка - пустая: " << std::endl;
    // std::cout << buf1 << std::endl;
    // asmFunc(buf1, buf2, strlen(buf2));
    // std::cout << buf1 << std::endl;

    return OK;
}
