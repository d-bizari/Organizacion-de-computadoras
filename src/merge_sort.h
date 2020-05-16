//
// Created by DANIELA CARRERO on 2020-05-15.
//
#ifndef ORGANIZACION_DE_COMPUTADORAS_MERGE_SORT_H

#include <stdlib.h>
#include <stdio.h>

void merge_sort(int *vec, size_t len);
int * clone_vector(int *vec, int from, size_t to);
void merge(int *vec, const int *left, const int *right, int leftLen, int rightLen);

#define ORGANIZACION_DE_COMPUTADORAS_MERGE_SORT_H

#endif //ORGANIZACION_DE_COMPUTADORAS_MERGE_SORT_H
