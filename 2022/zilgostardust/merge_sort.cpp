#include <iostream>

using namespace std;

void merge(int array[], int const left, int const mid, int const right) {
    auto const sub1 = mid - left + 1;
    auto const sub2 = right - mid;

    auto *leftArray = new int[sub1],
         *rightArray = new int[sub2];

    for (auto i = 0; i < sub1; i++) {
        leftArray[i] = array[left + i];
    }
    for (auto j = 0; j < sub2; j++) {
        rightArray[j] = array[mid + j + 1];
    }

    auto indexSub1 = 0, indexSub2 = 0;
    int indexMerged = left;

    while (indexSub1 < sub1 && indexSub2 < sub2) {}
}