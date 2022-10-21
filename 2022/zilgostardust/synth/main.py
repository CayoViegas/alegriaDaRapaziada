from random import sample
import numpy as np
import scipy.io.wavfile as wav

# Oscillate
def interpolate_linearly(wave_table, index):
    truncated = int(np.floor(index))
    next_index = (truncated + 1) % wave_table.shape[0]
    
    next_index_weight = index - truncated
    truncated_weight = 1 - next_index_weight

    return truncated_weight * wave_table[truncated] + next_index_weight * wave_table[next_index]

## Creates a simple Sine Wavefile
def main():
    sample_rate = 44100
    f = 440
    t = 3
    waveform = np.sin
    output_name = 'sine440HZ.wav'

    wavetable_length = 64
    wave_table = np.zeros((wavetable_length,))

    for n in range(wavetable_length):
        wave_table[n] = waveform(2 * np.pi * n / wavetable_length)

    output = np.zeros((t * sample_rate,))

    index = 0
    indexIncrement = f * wavetable_length / sample_rate
    
    for n in range(output.shape[0]):
        # output[n] = wave_table[int(np.floor(index))]
        output[n] = interpolate_linearly(wave_table, index)
        index += indexIncrement
        index %= wavetable_length

    gain = -20 #Db
    amplitude = 10 ** (gain / 20)
    output *= amplitude

    wav.write(output_name, sample_rate, output.astype(np.float32))

if __name__ == '__main__':
    main()