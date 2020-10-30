public class Italico implements Strategy {
    
    public Italico() {

    }

    @Override
    public String formatacao(String texto) {
        return "\033[3m" + texto + "\033[0m";
    }
}
