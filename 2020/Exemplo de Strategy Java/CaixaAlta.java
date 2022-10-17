public class CaixaAlta implements Strategy {
    
    public CaixaAlta() {

    }

    @Override
    public String formatacao(String texto) {
        return texto.toUpperCase();
    }
}
