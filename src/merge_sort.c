
//
// Created by DANIELA CARRERO on 2020-05-15.
//

#include "merge_sort.h"

void merge_sort(int *vec, size_t len) {
    if (len <= 1) {
        return;
    }

    int i = 0;
    int middle = len / 2;

    int *left = (int *) malloc(sizeof(int) * middle);
    int *right = (int *) malloc(sizeof(int) * len - middle);

    for (i = 0; i < middle; i++) {
        left[i] = vec[i];
    }

    for (i = 0; i < len - middle; i++) {
        right[i] = vec[i + middle];
    }

    merge_sort(left, middle);
    merge_sort(right, len - middle - 1);
    merge(vec, left, right, middle, len - middle - 1);

    free(left);
    free(right);
}

void merge(int *vec, const int *left, const int *right, int left_len, int right_len) {
    int i = 0, j = 0;

    while(i < left_len && j < right_len) {
        if (left[i] < right[j]) {
            vec[i + j] = left[i];
            i++;
        } else {
            vec[i + j] = right[j];
            j++;
        }
    }

    for(; i < left_len; i ++) {
        vec[i + j] = left[i];
    }

    for(; j < right_len; j ++) {
        vec[i + j] = right[j];
    }
}
