import java.util.Scanner;

public class BuyingAHouse {
    public static int solve(int n, int m, int k, int[] a) {
        int retorno = Integer.MAX_VALUE;
        
        for (int i = 0; i < n; i++) {
            if(a[i] != 0 && a[i] <= k) {
                retorno = Math.min(retorno, Math.abs((i + 1) - m));
            }
        }

        return retorno * 10;
    }
    
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        String[] fl = sc.nextLine().split(" ");
        String[] sl = sc.nextLine().split(" ");

        int n = Integer.parseInt(fl[0]);
        int m = Integer.parseInt(fl[1]);
        int k = Integer.parseInt(fl[2]);
        int[] a = new int[n];

        for (int i = 0; i < n; i++) {
            a[i] = Integer.parseInt(sl[i]);
        }

        System.out.println(solve(n, m, k, a));
    }
}