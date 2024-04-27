#include <iostream>
#include <cmath>

using namespace std;

double sin_asm()
{
    double result = 0.0;
    asm volatile(
        "fldpi\n"
        "fsin\n"
        "fstpl %0\n"
        :"=m"(result)
    );
    return result;
}

double sin_half_asm()
{
    double result = 0.0;
    int divide = 2;
    asm volatile(
        "fildl %1\n"
        "fldpi\n"
        "fdiv\n"
        "fsin\n"
        "fstpl %0\n"
        : "=m"(result)
        : "m"(divide)
    );
    return result;
}


int main()
{
    cout << "SIN:" << endl;
    printf("sin(3.14)\t%.20f\n", sin(3.14));
    printf("sin(3.141593)\t%.20f\n", sin(3.141593));
    printf("sin(M_PI)\t%.20f\n", sin(M_PI));
    printf("asm sin(pi)\t%.20f\n", sin_asm());
    cout << endl;
    printf("sin(3.14 / 2)\t\t%.20f\n", sin(3.14 / 2.0));
    printf("sin(3.141593 / 2)\t%.20f\n", sin(3.141593 / 2.0));
    printf("sin(M_PI / 2.0)\t\t%.20f\n", sin(M_PI / 2.0));
    printf("asm sin(pi / 2)\t\t%.20f\n", sin_half_asm());
}