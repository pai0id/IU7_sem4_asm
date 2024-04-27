#include <iostream>
#include <cmath>

using namespace std;

#define EPS 1e-8

double f(double x)
{
    double result;
    double five = 5.0;
    double two = 2.0;

    asm volatile (
        "fldl %[x]\n"
        "fmull %[x]\n"
        "fsubl %[five]\n"
        "fsin\n"
        "fmull %[two]\n"
        "fstpl %0"
        : "=m" (result)
        : [x] "m" (x), [five] "m" (five), [two] "m" (two)
    );
    return result;
}


double chordMethod(double a, double b, int iterations)
{
    double f0 = f(a);
    double f1 = f(b);
    if (f0 * f1 > 0)
        throw;
    else if (fabs(f0) < EPS)
        return a;
    else if (fabs(f1) < EPS)
        return b;

    double x0 = a;
    double x1 = b;
    double eps = EPS;
    int five = 5;
    int two = 2;
    
    asm volatile (
        "movq %[iterations], %%rcx\n"
        "main_loop:\n"

        "fldl %[f1]\n"
        "fsubl %[f0]\n"
        "fabs\n"
        "fldl %[eps]\n"
        "fcompp\n"
        "jl end_asm\n"

        "fldl %[x1]\n"
        "fsubl %[x0]\n"
        "fmull %[f1]\n"
        "fldl %[f1]\n"
        "fsubl %[f0]\n"
        "fdivrp %%st, %%st(1)\n"
        "fldl %[x1]\n"
        "fsubp\n"

        "movq %[x1], %%rdx\n"
        "movq %%rdx, %[x0]\n"
        "fstpl %[x1]\n"

        "fldl %[x0]\n"
        "fmull %[x0]\n"
        "fsubl %[five]\n"
        "fsin\n"
        "fmull %[two]\n"
        "fstpl %[f0]\n"
        
        "fldl %[x1]\n"
        "fmull %[x1]\n"
        "fsubl %[five]\n"
        "fsin\n"
        "fmull %[two]\n"
        "fstpl %[f1]\n"

        "loop main_loop\n"
        "end_asm:\n"
        : [x1] "=m" (x1)
        : [x0] "m" (x0), [f0] "m" (f0), [f1] "m" (f1), [iterations] "m" (iterations),
         [eps] "m" (eps), [five] "m" (five), [two] "m" (two)
    );
    
    return x1;
}

int main()
{
    double a = 1;
    double b = 2;
    int iterations = 15;
    
    double root = chordMethod(a, b, iterations);
    
    cout << "x = " << root << endl;
    
    return 0;
}
