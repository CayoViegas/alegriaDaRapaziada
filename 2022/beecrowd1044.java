
import java.io.IOException;
import java.util.Scanner;

 

public class Main {
 
    public static void main(String[] args) throws IOException {
        
        Scanner sc = new Scanner(System.in);
        
        int a = sc.nextInt(); 
		int b = sc.nextInt();
		
		if (a % b == 0 || b % a == 0) {
			System.out.println("Sao Multiplos");
		}
		else {
			System.out.println("Nao sao Multiplos");
		}

    }
 
}
