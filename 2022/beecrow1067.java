import java.util.Scanner;

public class uri1067 {

	public static void main(String[] args) {
		
		Scanner sc = new Scanner (System.in);
		
		int i;
		int x = sc.nextInt();
		
		for (i=0;i<=x;i++) {
			if (i % 2 != 0) {
				System.out.println(i);
			}
		}
		
		
		
		sc.close();

	}

}
