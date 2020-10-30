package badcode;

import java.util.List;

public class Gerente {

	/* 	[Refatormento] Extract class, mover o funcionamento do metodo para outra classe
	 	enquanto está apenas realiza a chamada.
	*/
	public String checar( Projeto projeto ) {
		return projeto.checar();
	}
}