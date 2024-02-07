#include <stdio.h>
#include <string.h>
#include <stdbool.h>

#define BUFFER_LEN 200
#define RESULT_LEN 8

static bool isnum(char c) {
	return c >= '0' && c <= '9';
}

int main(int argc, char **argv) {
	char buffer[BUFFER_LEN];
	char result[RESULT_LEN];
	memset(result, 0, RESULT_LEN*sizeof(char));
	int max_range = fread(buffer, sizeof(char), BUFFER_LEN, stdin);
	
	for (int i = 0; i < max_range; i++) {
		int start_index = i;
		bool met = false;
		while (isnum(buffer[i]) && i < max_range) {
			met = true;
			i++;
		}
		if (met && buffer[i] == '%') {
			i++;
			if (i - start_index > max_range) {
				return -2;
			}
			memcpy(result, &buffer[start_index], i-start_index);
			printf("%s", result);
			return 0;
		}
	}
	return -1;
}
