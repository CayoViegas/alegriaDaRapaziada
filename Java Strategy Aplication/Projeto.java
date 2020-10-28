package badcode;

import java.util.List;

public class Projeto {

	public int d;

	public boolean isEntregue() {
		return false;
	}

	public List<Cliente> getClientes() {
		return null;
	}

	public String checar(){ 
		// verifica prazo do projeto
		if (this.d < 90) {

		// verifica se projeto ainda está em andamento
			if (!projeto.isEntregue()) {

			// projeto ainda em andamento e com prazo curto para entrega
				return "Projeto está apertado" ;
			} 
			else {
				return "Projeto entregue";
			}
		} else { 
			this.avisaClientes();
			return "Projeto atrasado";
		}
	}

	/* 	[Refatormento] Extract method, para diminuir o tamanho do metodo e dividir funcionalidades
		dividimos ele em outro metodo que será invocado no metodo anterior.
	*/
	private void avisaClientes() {
		List<Cliente> clientes = getClientes();
		for (Cliente c : clientes) {
			c.avisaAtraso(this.d); 
		}
	}

}



