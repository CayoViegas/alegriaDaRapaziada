function digitosMaisFrequentes(a) {
    let valores = ""
    for (let i = 0; i<a.length; i++){
        valores += a[i]
    }

    let arr = [0,0,0,0,0,0,0,0,0,0]

    for(let i = 0; i<valores.length; i++){
        arr[parseInt(valores[i])] += 1;
    }
    let max =  Math.max(...arr)
    
    let ret = []
    for (let i = 0; i<arr.length; i++){
        if(arr[i] === max){
            ret.push(i)
        }
    }
    
    return ret.sort()
}

console.log(digitosMaisFrequentes([3,4,5,34,5,6,7]))
