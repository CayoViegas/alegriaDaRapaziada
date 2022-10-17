module gerenciaDeBagagens
---SIGS
	---Assintura para o ticket
abstract sig tickeT{}
sig greenTicket, redTicket extends tickeT{}

	---Assintura para o Bagagem
abstract sig bagagem{}

sig bagagemLeve extends bagagem{} ---Assintura para o Bagagem Leve---
sig bagagemMedia extends bagagem{} ---Assintura para o Bagagem Media---
sig bagagemPesada extends bagagem{} ---Assintura para o Bagagem Pesada---

	---Assintura para o passageiro abstrato
abstract sig passageiro{
	ticket : one tickeT,
	bagagens : set bagagem
}
	---Assintura para o passageiro Comum
sig passageiroComum extends passageiro{}
	---Assintura para o passageiro Milhagem
sig passageiroMilhagem extends passageiro{}
	---Assintura para o passageiro Vip
sig passageiroVip extends passageiro{}

---FUNÇÕES
	---retorna as bagagens leves de um passageiro
fun retornaBagagensLeve[p : passageiro] : set bagagem {
	p.bagagens & bagagemLeve
}
	---retorna as bagagens medias de um passageiro
fun retornaBagagensMediana[p : passageiro] : set bagagem {
 	p.bagagens & bagagemMedia
}
	---retorna as bagagens pesadas de um passageiro
fun retornaBagagensPesada[p : passageiro] : set bagagem {
	p.bagagens & bagagemPesada
}

---PREDICADOS
	---predicados para bagagens
pred verificaBagagemVip[pv : passageiroVip ] {
	lone (retornaBagagensLeve[pv])
	#(retornaBagagensMediana[pv]) <= 2
	#(retornaBagagensPesada[pv]) <= 2
}

pred verificaBagagemMilhagem[pm : passageiroMilhagem ]{
	lone (retornaBagagensLeve[pm])
	lone (retornaBagagensMediana[pm])
	lone (retornaBagagensPesada[pm])

}

pred verificaBagagemComum[pc : passageiroComum ]{
	lone (retornaBagagensLeve[pc])
	no (retornaBagagensMediana[pc])
	lone (retornaBagagensPesada[pc])
}

	---Predicados para tickets
pred eVerde[p: passageiro]{
	p.ticket in greenTicket
}

pred eVermelho[p: passageiro]{
	p.ticket in redTicket  
}

---FACTS
	---Fatos relacionados ao passageiro
fact passageiroF {
	--- passageiro Comum
	all pc : passageiroComum |  verificaBagagemComum[pc] implies eVerde[pc] else eVermelho[pc]  

	--- passageiro de Milhagem
	all pm : passageiroMilhagem | verificaBagagemMilhagem[pm] implies eVerde[pm] else eVermelho[pm]  

	--- passageiro Vip
	all pv : passageiroVip | verificaBagagemVip[pv] implies eVerde[pv] else eVermelho[pv]
}

	---Fatos relacionados a bagagem do passageiro.
fact bagagemF {
	all b: bagagem | one (b.~bagagens) 
}

	---Fatos relacionados ao passageiro
fact ticketF {
	all t: tickeT | one (t.~ticket)
}

---ASSERTS
	---Assersts para passageiro Comum
assert passageiroComumValido{
	all pc: passageiroComum | pc.ticket = greenTicket implies
		( lone (bagagemLeve & pc.bagagens) 
		and no (bagagemMedia & pc.bagagens)
		and lone (bagagemPesada & pc.bagagens))
}

assert passageiroComumInvalido{
	all pc: passageiroComum | pc.ticket = redTicket implies
			( #(bagagemLeve & pc.bagagens) > 1 
			or #(bagagemMedia & pc.bagagens) > 0 
		   	or #(bagagemPesada & pc.bagagens) > 1 )
}

	---Assersts para passageiro Milhagem
assert passageiroMilhagemValido{
	all pm: passageiroMilhagem | pm.ticket = greenTicket implies
	(lone (bagagemLeve & pm.bagagens) 
	and lone (bagagemMedia & pm.bagagens) 
	and lone (bagagemPesada & pm.bagagens))
}

assert passageiroMilhagemInvalido{
	all pm: passageiroMilhagem | pm.ticket = redTicket implies
	( #(bagagemLeve & pm.bagagens) > 1 
	or #(bagagemMedia & pm.bagagens) > 1 
	or #(bagagemPesada & pm.bagagens) > 1)
}

	---Assersts para passageiro Vip
assert passageiroVipValido{
	all pv: passageiroVip | pv.ticket = greenTicket implies
	(#(bagagemPesada & pv.bagagens) <= 2 
	and #(bagagemMedia & pv.bagagens) <= 2 
	and lone (bagagemLeve & pv.bagagens))
}

assert passageiroVipInvalido{
	all pv: passageiroVip | pv.ticket = redTicket implies
	( #(bagagemPesada & pv.bagagens) > 2 
	or #(bagagemMedia & pv.bagagens) > 2 
	or #(bagagemLeve & pv.bagagens) > 1)
}

--CHECKs
check passageiroComumValido for 10
check passageiroComumInvalido for 10
check passageiroMilhagemValido for 10
check passageiroMilhagemInvalido for 10
check passageiroVipValido for 10
check passageiroVipInvalido for 10

pred show[]{}
run show for 8