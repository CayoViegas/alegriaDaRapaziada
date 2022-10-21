fun main(args: Array<String>) {
    val numbers = mutableListOf(2, 5, 238, 123, 345893, 12, -1, 32, -345, 9, 0)
    val sortedNumbers = mergeSort(numbers)
    println("unsorted: $numbers")
    println("sorted: $sortedNumbers")
}

fun mergeSort(list: List<Int>): List<Int> {
    if (list.size <= 1) {
        return list
    }

    val mid = list.size / 2
    var left = list.subList(0, mid)
    var right = list.subList(mid, list.size)

    return merge(mergeSort(left), mergeSort(right))
}

fun merge(left: List<Int>, right: List<Int>): List<Int> {
    var indexLeft = 0
    var indexRight = 0
    var newList : MutableList<Int> = mutableListOf()

    while (indexLeft < left.count() && indexRight < right.count()) {
        if (left[indexLeft] <= right[indexRight]) {
            newList.add(left[indexLeft])
            indexLeft++
        } else {
            newList.add(right[indexRight])
            indexRight++
        }
    }

    while (indexLeft < left.size) {
        newList.add(left[indexLeft])
        indexLeft++
    }

    while (indexRight < right.size) {
        newList.add(right[indexRight])
        indexRight++
    }
    return newList
}