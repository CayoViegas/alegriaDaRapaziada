
import java.io.*;
import java.lang.reflect.Array;
import java.util.*;
 
public class D {
    static class FastReader {
        BufferedReader br;
        StringTokenizer st;
 
        public FastReader() {
            br = new BufferedReader(new
                    InputStreamReader(System.in));
        }
 
        String next() {
            while (st == null || !st.hasMoreElements()) {
                try {
                    st = new StringTokenizer(br.readLine());
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            return st.nextToken();
        }
 
        int nextInt() {
            return Integer.parseInt(next());
        }
 
        long nextLong() {
            return Long.parseLong(next());
        }
 
        double nextDouble() {
            return Double.parseDouble(next());
        }
 
        String nextLine() {
            String str = "";
            try {
                str = br.readLine();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return str;
        }
    }
 
    static FastReader s = new FastReader();
    static PrintWriter out = new PrintWriter(System.out);
 
    private static int[] rai(int n) {
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            arr[i] = s.nextInt();
        }
        return arr;
    }
 
    private static int[][] rai(int n, int m) {
        int[][] arr = new int[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                arr[i][j] = s.nextInt();
            }
        }
        return arr;
    }
 
    private static long[] ral(int n) {
        long[] arr = new long[n];
        for (int i = 0; i < n; i++) {
            arr[i] = s.nextLong();
        }
        return arr;
    }
 
    private static long[][] ral(int n, int m) {
        long[][] arr = new long[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                arr[i][j] = s.nextLong();
            }
        }
        return arr;
    }
 
    private static int ri() {
        return s.nextInt();
    }
 
    private static long rl() {
        return s.nextLong();
    }
 
    private static String rs() {
        return s.next();
    }
 
    static int gcd(int a,int b)
    {
        if(b==0)
        {
            return a;
        }
        return gcd(b,a%b);
    }
 
    static boolean isPrime(int n) {
        if (n % 2 == 0) return false;
        for (int i = 3; i <= Math.sqrt(n); i += 2) {
            if (n % i == 0)
                return false;
        }
        return true;
    }
 
    static SparseMatrix sp=null;
    static int[][] vis;
 
    static boolean check(int l1,int l2,int last)
    {
 
        if(l1==0 && l2==0)
        {
            return true;
        }
        if(vis[l1][l2]!=-1)
        {
            return vis[l1][l2] == 1;
        }
        int ind=sp.getMaxIndex(0,last);
        int len=last-ind+1;
        int newLast=ind-1;
        if(l1>=len && l2>=len)
        {
            boolean b=check(l1-len,l2,newLast);
            boolean b1=check(l1,l2-len,newLast);
            if(b)
            {
                vis[l1][l2]=1;
            }
            else
            {
                vis[l1][l2]=0;
            }
            if(b1)
            {
                vis[l1][l2]=1;
            }
            else
            {
                vis[l1][l2]=0;
            }
            return b || b1;
        }
        else if(l1>=len)
        {
            boolean b=check(l1-len,l2,newLast);
            if(b)
            {
                vis[l1][l2]=1;
            }
            else
            {
                vis[l1][l2]=0;
            }
            return b;
        }
        else if(l2>=len)
        {
            boolean b1=check(l1,l2-len,newLast);
            if(b1)
            {
                vis[l1][l2]=1;
            }
            else
            {
                vis[l1][l2]=0;
            }
            return b1;
        }
        else {
            vis[l1][l2]=0;
            return false;
        }
    }
    public static void main(String[] args) {
        StringBuilder ans = new StringBuilder();
        int t = ri();
//        int t=1;
        while (t-- > 0) {
            int n=ri();
            n*=2;
 
            int[] arr=rai(n);
            int last=n-1;
 
             sp=new SparseMatrix(arr);
             vis=new int[(n/2)+1][(n/2)+1];
             for(int i=0;i<=n/2;i++)
             {
                 Arrays.fill(vis[i],-1);
             }
            int l1=n/2,l2=n/2;
            if(!check(l1,l2,last))
            {
                ans.append("NO\n");
            }
            else {
                ans.append("YES\n");
            }
 
 
        }
        out.print(ans.toString());
        out.flush();
 
    }
    static public class SparseMatrix {
        private int[] arr;
        private int m;
        private int[][] minSparse;
        private int[][] minIndex;
        private int[][] maxSparse;
        private int[][] maxIndex;
        private int n;
        public SparseMatrix(int[] arr) {
            this.arr = arr;
            this.m=arr.length;
            this.n=Integer.toBinaryString(m).length();
            minSparse=new int[n][m];
            minIndex=new int[n][m];
 
            maxSparse=new int[n][m];
            maxIndex=new int[n][m];
 
            createMinSparse();
            createMaxSparse();
        }
        private void createMaxSparse()
        {
            for(int j=0;j<m;j++)
            {
                maxSparse[0][j]=arr[j];
                maxIndex[0][j]=j;
            }
            for(int i=1;i<n;i++)
            {
                for(int j=0;j+(1<<(i-1))<m;j++)
                {
                    int left=maxSparse[i-1][j];
                    int right=maxSparse[i-1][j+(1<<(i-1))];
                    maxSparse[i][j]=Math.max(left,right);
 
                    if(left>=right)
                    {
                        maxIndex[i][j]=maxIndex[i-1][j];
                    }
                    else
                    {
                        maxIndex[i][j]=maxIndex[i-1][j+(1<<(i-1))];
                    }
                }
            }
        }
        private void createMinSparse()
        {

            for(int j=0;j<m;j++)
            {
                minSparse[0][j]=arr[j];
                minIndex[0][j]=j;
            }
            
            for(int i=1;i<n;i++)
            {
                for(int j=0;j+(1<<(i-1))<m;j++)
                {
 
                    int left=minSparse[i-1][j];
                    int right=minSparse[i-1][j+(1<<(i-1))];
 
                    minSparse[i][j]=Math.min(left,right);
 
                    if(left<=right)
                    {
                        minIndex[i][j]=minIndex[i-1][j];
                    }
                    else {
                        minIndex[i][j]=minIndex[i-1][j+(1<<(i-1))];
                    }
 
                }
            }
        }
 

        public int getMin(int l,int r)
        {
            int len=r-l+1;
            int p=Integer.toBinaryString(len).length()-1;
            int k=1<<p;
 
            int left=minSparse[p][l];
            int right=minSparse[p][r-k+1];
            return Math.min(right,left);
        }
 
        public int getMinIndex(int l,int r)
        {
            int len=r-l+1;
            int p=Integer.toBinaryString(len).length()-1;
            int k=1<<p;
 
            int left=minSparse[p][l];
            int right=minSparse[p][r-k+1];
            if (left <= right) {
                return minIndex[p][l];
            } else {
                return minIndex[p][r - k + 1];
            }
        }
 
 
        public int getMax(int l,int r)
        {
            int len=r-l+1;
            int p=Integer.toBinaryString(len).length()-1;
            int k=1<<p;
 
            int left=maxSparse[p][l];
            int right=maxSparse[p][r-k+1];
            return Math.max(right,left);
        }
 
        public int getMaxIndex(int l,int r)
        {
            int len=r-l+1;
            int p=Integer.toBinaryString(len).length()-1;
            int k=1<<p;
            int left=maxSparse[p][l];
            int right=maxSparse[p][r-k+1];
            if(left>=right)
            {
                return maxIndex[p][l];
 
            }
            return maxIndex[p][r-k+1];
        }
        void print()
        {
            for(int i=0;i<minSparse.length;i++)
            {
                for(int j=0;j<minSparse[i].length;j++)
                {
                    System.out.print(minSparse[i][j]+" ");
                }
                System.out.println();
            }
            System.out.println();
            for(int i=0;i<n;i++)
            {
                for(int j=0;j<m;j++)
                {
                    System.out.print(minIndex[i][j]+" ");
                }
                System.out.println();
            }
        }
    }
 
 
}