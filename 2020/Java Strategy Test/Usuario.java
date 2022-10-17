import java.util.Scanner;

public class Usuario {
    private Strategy estrategia;
    private String texto;

    public Usuario() {
        this.estrategia = new CaixaBaixa();
        this.texto = "";
    }

    private void mudaEstrategia(String estrategia) {
        if (estrategia.equals("caixa baixa")) {
            this.estrategia = new CaixaBaixa();
        } else if (estrategia.equals("caixa alta")) {
            this.estrategia = new CaixaAlta();
        } else if (estrategia.equals("italico")) {
            this.estrategia = new Italico();
        } else if (estrategia.equals("negrito")) {
            this.estrategia = new Negrito();
        }
    }

    public void setTexto(String novoTexto) {
        this.texto = novoTexto;
    }

    public String imprimeTexto(String estrategia) {
        this.mudaEstrategia(estrategia);
        return this.estrategia.formatacao(this.texto);
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        Usuario usuario = new Usuario();
        System.out.println("digite o texto: ");
        String texto = sc.nextLine();
        usuario.setTexto(texto);
        System.out.println("digite a formatacao: ");
        String formatacao = sc.nextLine();
        System.out.println(usuario.imprimeTexto(formatacao));
    }
}
