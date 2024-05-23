#include <stdio.h>
#include <stdlib.h>

#define MAX_LEN 10

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
    if (n1!= n2) {
        return 1;
    }

    asm volatile ("");

    return 0;
}

int main() {
    int arr1[MAX_LEN];
    fillRndArr(arr1, MAX_LEN);
    int arr2[MAX_LEN];
    fillRndArr(arr2, MAX_LEN);
    int res[MAX_LEN];

    printf("ARR1\n");
    prnArr(arr1, MAX_LEN);
    printf("ARR2\n");
    prnArr(arr2, MAX_LEN);

    int rc = mulArrC(arr1, MAX_LEN, arr2, MAX_LEN, res);
    if (rc) {
        printf("ERR");
        return rc;
    }

    printf("RES\n");
    prnArr(res, MAX_LEN);
    
    return 0;
}

