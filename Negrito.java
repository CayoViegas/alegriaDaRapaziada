public class Negrito implements Strategy {
    
    public Negrito() {

    }

    @Override
    public String formatacao(String texto) {
        return "\033[1m" + texto + "\033[1m";
    }
}
