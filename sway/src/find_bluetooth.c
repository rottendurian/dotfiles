#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#define BUFFER_LEN 500
#define RESULT_LEN 50

int main(int argc, char **argv) {
	char buffer[BUFFER_LEN];
	char result[RESULT_LEN];
	memset(result, 0, RESULT_LEN*sizeof(char));
	int max_range = fread(buffer, sizeof(char), BUFFER_LEN, stdin);

	char* expected = "Name: ";
	int expected_len = strlen(expected);
	
	for (int i = 0; i < max_range; i++) {
		bool met = false;
		int count = 0;
		while (!met && i < max_range && count < expected_len) {
			if (buffer[i] != expected[count]) {
				break;
			} else if (count == expected_len - 1) {
				met = true;
				break;
			}
			count++;		
			i++;
		}

		if (met) {
			i++;
			int start_index = i;
			while (i < max_range && buffer[i] != '\n') {
				i++;
			}
			memcpy(result, &buffer[start_index], i-start_index);
            printf("[%s]", result);

			return 0;
		}
	}
    printf("none");
	return -1;
}


