function mergeSort(array) {
    const half = array.length / 2
    
    // Base case
    if(array.length < 2){
      return array 
    }
    
    const left = array.splice(0, half)
    return merge(mergeSort(left),mergeSort(array))
}