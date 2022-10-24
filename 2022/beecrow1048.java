import java.util.Locale;
import java.util.Scanner;
import java.util.Locale;

public class Main {

	public static void main(String[] args) {
		
		
		Locale.setDefault(Locale.US);
		Scanner sc = new Scanner (System.in);
		
		//uri1048
		double salario = sc.nextDouble();
		double reajuste = 0, ganho = 0;
		int percentual = 0;
		
		if (salario > 0 && salario <= 400) {
			ganho = salario * 0.15;
			reajuste = ganho + salario;
			percentual = (int) (100 * 0.15);
		}
		else if (salario > 400 && salario <= 800) {
			ganho = salario * 0.12;
			reajuste = ganho + salario;
			percentual = (int) (100 * 0.12);
		}
		else if (salario > 800 && salario <= 1200) {
			ganho = salario * 0.10;
			reajuste = ganho + salario;
			percentual = (int) (100 * 0.10);
		}
		else if (salario > 1200 && salario <= 2000) {
			ganho = salario * 0.07;
			reajuste = ganho + salario;
			percentual = (int) (100 * 0.07);
		}
		else if (salario > 2000) {
			ganho = salario * 0.04;
			reajuste = ganho + salario;
			percentual = (int) (100 * 0.04);
		}
		
		System.out.printf("Novo salario: %.2f%n", reajuste);
		System.out.printf("Reajuste ganho: %.2f%n", ganho);
		System.out.println("Em percentual: " + percentual + " %");
	
		sc.close();
	}

}
