public class CaixaBaixa implements Strategy {
    
    public CaixaBaixa() {

    }

    @Override
    public String formatacao(String texto) {
        return texto.toLowerCase();
    }
}
