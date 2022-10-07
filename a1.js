var input = require("fs").readFileSync("/dev/stdin", "utf8");
var lines = input.split("\n");

let salario = parseFloat(lines[1]);
let vendas = parseFloat(lines[2]);

const comissao = vendas * 0.15;
const resultado = salario + comissao;

console.log(`TOTAL = R$ ${resultado.toFixed(2)}\n`);
