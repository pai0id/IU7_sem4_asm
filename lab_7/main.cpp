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
    std::cout << "Размер строки:" << std::endl;
    std::cout << "Введите строку: ";
    std::string str_cnt;
    std::cin >> str_cnt;
    std::cout << "Размер: " << cFunc(str_cnt.c_str()) << std::endl;
    std::cout << "Размер пустой строки: " << cFunc("") << std::endl;

    std::cout << "Две строки:" << std::endl;
    std::cout << "Введите первую строку: ";
    std::string str1;
    std::cin >> str1;
    std::cout << "Введите вторую строку: ";
    std::string str2;
    std::cin >> str2;
    std::string buf1, buf2;

    buf1 = str1;
    buf2 = str2;
    std::cout << "Две отдельных строки:" << std::endl;
    std::cout << buf1 << " " << buf2 << std::endl;
    asmFunc(buf1.c_str(), buf2.c_str(), 2);
    std::cout << buf1 << " " << buf2 << std::endl;

    buf2 = str2;
    std::cout << "Первая строка - с 3 символа второй: " << std::endl;
    std::cout << &buf2[2] << " " << buf2 << std::endl;
    asmFunc(&buf2[2], buf2.c_str(), 2);
    std::cout << &buf2[2] << " " << buf2 << std::endl;

    buf1 = str1;
    std::cout << "Вторая строка - с 3 символа первой: " << std::endl;
    std::cout << buf1 << " " << &buf1[2] << std::endl;
    asmFunc(buf1.c_str(), &buf1[2], 2);
    std::cout << buf1 << " " << &buf1[2] << std::endl;

    return OK;
}
