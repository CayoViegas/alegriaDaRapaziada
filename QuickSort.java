public class QuickSort {
    public void quickSort(int arr[], int begin, int end) {
		if (begin < end) {
			int partitionIndex = particaoLomuto(arr, begin, end);

			quickSort(arr, begin, partitionIndex - 1);
			quickSort(arr, partitionIndex + 1, end);
		}
	}

	public int particaoLomuto(int[] v, int ini, int fim) {
		int pivot = v[ini];
		int i = ini;

		for (int j = i + 1; j < v.length; j++) {
			if (v[j] < pivot) {
				i++;
				int aux = v[i];
				v[i] = v[j];
				v[j] = aux;
			}
		}
		int aux = v[ini];
		v[ini] = v[i];
		v[i] = aux;

		return i;
    }
}