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
    double x2;
    
    for (int i = 0; i < iterations; ++i)
    {
        if (fabs(f1 - f0) < EPS)
        {
            cout << "Root found with precision within tolerance." << endl;
            break;
        }

        // x2 = x1 - ((f1 * (x1 - x0)) / (f1 - f0));
        asm volatile (
            "fldl %[x1]\n"
            "fsubl %[x0]\n"
            "fmull %[f1]\n"
            "fldl %[f1]\n"
            "fsubl %[f0]\n"
            "fdivrp %%st, %%st(1)\n"
            "fldl %[x1]\n"
            "fsubp\n"
            "fstpl %0"
            : "=m" (x2)
            : [x1] "m" (x1), [x0] "m" (x0), [f1] "m" (f1), [f0] "m" (f0)
        );
        
        x0 = x1;
        x1 = x2;
        f0 = f(x0);
        f1 = f(x1);
    }
    
    return x1;
}

int main()
{
    double a = 1;
    double b = 4;
    int iterations = 10;
    
    double root = chordMethod(a, b, iterations);
    
    cout << "x = " << root << endl;
    
    return 0;
}
