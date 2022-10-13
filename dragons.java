import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Scanner;

public class Dragons {
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        ArrayList<Par> a = new ArrayList<>();

        String[] fl = sc.nextLine().split(" ");

        int s = Integer.parseInt(fl[0]);
        int n = Integer.parseInt(fl[1]);

        while(n > 0) {
            int c = 1;

            for (int i = 0; i < n; i++) {
                String[] sl = sc.nextLine().split(" ");

                Par p = new Par(Integer.parseInt(sl[0]), Integer.parseInt(sl[1]));

                a.add(i, p);
            }

            Collections.sort(a, new Comparator<Par>(){
                @Override
                public int compare(Par um, Par dois) {
                    return um.getPrimeiro() - dois.getPrimeiro();
                }
            });

            for (int i = 0; i < n; i++) {
                if(s <= a.get(i).getPrimeiro()) {
                    c = 0;
                    break;
                } else {
                    s = s + a.get(i).getSegundo();
                }
            }

            if(c == 0) {
                System.out.println("NO");
                break;
            } else {
                System.out.println("YES");
                break;
            }
        }
    }
}

class Par {
    private int primeiro;
    private int segundo;

    public Par(int primeiro, int segundo) {
        this.primeiro = primeiro;
        this.segundo = segundo;
    }

    public int getPrimeiro() {
        return this.primeiro;
    }

    public void setPrimeiro(int primeiro) {
        this.primeiro = primeiro;
    }

    public int getSegundo() {
        return this.segundo;
    }

    public void setSegundo(int segundo) {
        this.segundo = segundo;
    }
}