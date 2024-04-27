#include <iostream>
#include <ctime>
#include <cmath>

using namespace std;

#define MAX_NUM_TESTS 100000

double calc_mean(const long long data[], size_t length);

double calc_stdev(const long long data[], size_t length, double avr);

double calc_rse(size_t length, double avr, double stdev);

template <typename Type>
void check_sum(Type a, Type b)
{
    size_t i;
    double avr;
    long long test_arr[MAX_NUM_TESTS];
    struct timespec start, end;

    for (i = 0; i < MAX_NUM_TESTS; i++)
    {
        clock_gettime(CLOCK_MONOTONIC_RAW, &start);
        a + b;
        clock_gettime(CLOCK_MONOTONIC_RAW, &end);

        test_arr[i] = (end.tv_sec - start.tv_sec) * 1000000000 + end.tv_nsec - start.tv_nsec;

        if (i % 10 == 9)
        {
            avr = calc_mean(test_arr, i + 1);
            if (calc_rse(i + 1, avr, calc_stdev(test_arr, i + 1, avr)) <= 5)
            {
                i++;
                break;
            }
        }
    }

    avr = calc_mean(test_arr, i);
    
    cout << "sum: " << avr << endl;
}

template <typename Type>
void check_mul(Type a, Type b)
{
    size_t i;
    double avr;
    long long test_arr[MAX_NUM_TESTS];
    struct timespec start, end;

    for (i = 0; i < MAX_NUM_TESTS; i++)
    {
        clock_gettime(CLOCK_MONOTONIC_RAW, &start);
        a * b;
        clock_gettime(CLOCK_MONOTONIC_RAW, &end);

        test_arr[i] = (end.tv_sec - start.tv_sec) * 1000000000 + end.tv_nsec - start.tv_nsec;

        if (i % 10 == 9)
        {
            avr = calc_mean(test_arr, i + 1);
            if (calc_rse(i + 1, avr, calc_stdev(test_arr, i + 1, avr)) <= 5)
            {
                i++;
                break;
            }
        }
    }

    avr = calc_mean(test_arr, i);
    
    cout << "mul: " << avr << endl;
}

template <typename Type>
void check_sum_asm(Type a, Type b)
{
    size_t i;
    double avr;
    long long test_arr[MAX_NUM_TESTS];
    struct timespec start, end;
    double res;

    for (i = 0; i < MAX_NUM_TESTS; i++)
    {
        clock_gettime(CLOCK_MONOTONIC_RAW, &start);
        __asm__(
            "fldl %[a]\n"
            "fldl %[b]\n"
            "faddp\n"

            "fstpl %0\n"
            : "=m"(res)
            : [a] "m"(a), [b] "m"(b)
        );
        clock_gettime(CLOCK_MONOTONIC_RAW, &end);

        test_arr[i] = (end.tv_sec - start.tv_sec) * 1000000000 + end.tv_nsec - start.tv_nsec;

        if (i % 10 == 9)
        {
            avr = calc_mean(test_arr, i + 1);
            if (calc_rse(i + 1, avr, calc_stdev(test_arr, i + 1, avr)) <= 5)
            {
                i++;
                break;
            }
        }
    }

    avr = calc_mean(test_arr, i);
    
    cout << "sum: " << avr << endl;
}

template <typename Type>
void check_mul_asm(Type a, Type b)
{
    size_t i;
    double avr;
    long long test_arr[MAX_NUM_TESTS];
    struct timespec start, end;
    double res;

    for (i = 0; i < MAX_NUM_TESTS; i++)
    {
        clock_gettime(CLOCK_MONOTONIC_RAW, &start);
        __asm__
        (
            "fldl %[a]\n"
            "fldl %[b]\n"
            "fmulp\n"
            "fstpl %0\n"
            :"=m"(res)
            : [a] "m"(a), [b] "m"(b)
        );
        clock_gettime(CLOCK_MONOTONIC_RAW, &end);

        test_arr[i] = (end.tv_sec - start.tv_sec) * 1000000000 + end.tv_nsec - start.tv_nsec;

        if (i % 10 == 9)
        {
            avr = calc_mean(test_arr, i + 1);
            if (calc_rse(i + 1, avr, calc_stdev(test_arr, i + 1, avr)) <= 5)
            {
                i++;
                break;
            }
        }
    }

    avr = calc_mean(test_arr, i);
    
    cout << "mul: " << avr << endl;
}

template <typename Type>
void time_measure(Type a, Type b)
{
    cout << "asm: " << endl;
    check_sum_asm(a, b);
    check_mul_asm(a, b);
    cout << "c++: " << endl;
    check_sum(a, b);
    check_mul(a, b);
}

int main()
{
    float f1 = 3.745326f;
    float f2 = 2.334523f;
    cout << "FLOAT:" << endl;
    time_measure(f1, f2);

    double d1 = 3.7422123311;
    double d2 = 2.3312314673;
    cout << "\nDOUBLE:" << endl;
    time_measure(d1, d2);

    cout << endl;
}

// Функция для вычисления среднего значения
double calc_mean(const long long data[], size_t length)
{
    long long sum = 0;
    for (size_t i = 0; i < length; i++)
        sum += data[i];
    return (double)sum / (double)length;
}

// Функция для вычисления стандартного отклонения
double calc_stdev(const long long data[], size_t length, double avr)
{
    double sum = 0;
    for (size_t i = 0; i < length; i++)
    {
        double diff = data[i] - avr;
        sum += diff * diff;
    }
    return sqrt((double)sum / ((double)length - 1));
}

// Функция для вычисления относительной стандартной ошибки (RSE)
double calc_rse(size_t length, double avr, double stdev)
{
    return stdev / sqrt((double)length) / avr * 100;
}
