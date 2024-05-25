#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MAX_LEN 100000

void fillRndArr(int *arr, size_t n) {
    for (int i = 0; i < n; i++) {
        arr[i] = rand() % n;
    }
}

void prnArr(int *arr, size_t n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int mulArrC(int *arr1, size_t n1, int *arr2, size_t n2, int *res) {
    if (n1!= n2) {
        return 1;
    }

    for (int i = 0; i < n1; i++) {
        res[i] = arr1[i] * arr2[i];
    }

    return 0;
}

int mulArrAsm(int *arr1, size_t n1, int *arr2, size_t n2, int *res) {
    if (n1 != n2) {
        return 1;
    }

    size_t i;
    for (i = 0; i <= n1 - 4; i += 4) {
        asm volatile (
            "ld1 {v0.4S}, [%[arr1]]\n\t"
            "ld1 {v1.4S}, [%[arr2]]\n\t"
            "mul v2.4S, v0.4S, v1.4S\n\t"
            "st1 {v2.4S}, [%[res]]\n\t"
            : 
            : [res] "r" (res+i), [arr1] "r" (arr1 + i), [arr2] "r"(arr2 + i)
            : "q0", "q1", "q2", "memory"
        );
    }

    for (; i < n1; ++i) {
        res[i] = arr1[i] * arr2[i];
    }

    return 0;
}

int main() {
    int rc;
    clock_t start, end;
    double cpu_time_used;
    srand(time(NULL));

    printf("Print arrs?(y/n)\n");
    char c;
    scanf("%c", &c);

    int arr1[MAX_LEN];
    fillRndArr(arr1, MAX_LEN);
    int arr2[MAX_LEN];
    fillRndArr(arr2, MAX_LEN);
    int resC[MAX_LEN];
    int resAsm[MAX_LEN];

    if (c == 'y') {
        printf("ARR1\n");
        prnArr(arr1, MAX_LEN);
        printf("ARR2\n");
        prnArr(arr2, MAX_LEN);
    }

    start = clock();
    rc = mulArrC(arr1, MAX_LEN, arr2, MAX_LEN, resC);
    end = clock();
    if (rc) {
        printf("ERR");
        return rc;
    }

    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("mulArrC\n");
    if (c == 'y') {
        prnArr(resC, MAX_LEN);
    }
    printf("Time: %f\n", cpu_time_used);

    start = clock();
    rc = mulArrAsm(arr1, MAX_LEN, arr2, MAX_LEN, resAsm);
    end = clock();
    if (rc) {
        printf("ERR");
        return rc;
    }

    cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("mulArrAsm\n");
    if (c == 'y') {
        prnArr(resAsm, MAX_LEN);
    }
    printf("Time: %f\n", cpu_time_used);
    
    return 0;
}

