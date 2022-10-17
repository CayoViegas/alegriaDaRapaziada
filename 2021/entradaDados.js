let input = require("fs").readFileSync("./dados", "utf8");

const valores = input.split("\n");

let x = parseInt(valores.shift());
let y = parseFloat(valores.shift());
let z = parseFloat(valores.shift());
let resul = y * z;
console.log("NUMBER = " + x);
console.log("SALARY = U$ " + resul.toFixed(2));