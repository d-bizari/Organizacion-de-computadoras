//
// Created by DANIELA CARRERO on 2020-05-15.
//

#include "merge_sort.h"

void merge_sort(int *vec, size_t len) {
    if (len <= 1) {
        return;
    }

    int left_len = (len / 2) + 1;
    int right_len = len / 2;
    int *left = clone_vector(vec, 0, (len / 2) + 1);
    int *right = clone_vector(vec, len / 2, len);

    merge_sort(left, left_len - 1);
    merge_sort(right, len - right_len);
    merge(vec, left, right, left_len - 1, len - right_len);

    free(left);
    free(right);
}

int * clone_vector(int *vec, int from, size_t to) {
    int *vec_aux;
    int i;

    //Quizás se podría validar si se queda sin memoria, ver como hacer en assembly
    vec_aux = (int *) malloc((to - from) * sizeof(int));

    for (i = from; i < to; i++) {
        vec_aux[i - from] = vec[i];
    }

    return vec_aux;
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
