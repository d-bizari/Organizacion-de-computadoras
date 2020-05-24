#define _POSIX_C_SOURCE 200809L //Para getline()
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
/************ MACROS ***************/
#define FINISH                 2
#define INPUT_POS              0
#define OUTPUT_POS             1
#define EMPTY_LINE             3
#define DECIMAL         	   10
#define MAX_INT_32      	   2147483647
#define MIN_INT_32             (-INT32_MAX-1)
#define MSG_HELP               "Usage:\ntp1 -h\ntp1 -V\ntp1 -i in_file -o out_file\nOptions:\n-V, --version Print version and quit.\n-h, --help Print this information and quit.\n-i, --input Specify input stream/file, \"-\" for stdin.\n-o, --output Specify output stream/file, \"-\" for stdout.\n"
#define MSG_ERROR_OPEN_INPUT   "Error opening input file"
#define MSG_ERROR_OPEN_OUTPUT  "Error opening output file"
#define MSG_ERROR_MALLOC       "Error allocating memory"
#define VERSION                 0.1

// // Funcion escrita en assembly
extern void merge_sort(int * array, size_t lenght);

// Lee y parsea commands in line arguments
int cliCmd(int argc, char const * argv[], FILE * files[]);

// Intenta parsear un string separado por espacios en un array de int
// ante un error reporta por stderr y devuelve 0. Queda a cargo del cliente la liberacion de memoria.
int parser(char * line, int ** result, size_t * size_result);

int main(int argc, const char * argv[]){
	FILE * files[2];
	char * line = NULL;
	size_t tam = 0;
	ssize_t largo = 0;

	int status = cliCmd(argc, argv, files);
	if(status != EXIT_SUCCESS){
		return status;
	}
	if (!files[1]) {
		files[1] = stdout;
	}

	while((largo = getline(&line, &tam, files[INPUT_POS])) != -1){
		size_t n = 0;
		int *  vector = NULL;

		status = parser(line, &vector, &n);
		if(status == EMPTY_LINE){
			fprintf(files[OUTPUT_POS], "\n");
			free(line);
			line = NULL;
			continue;
		}
		if(status != EXIT_SUCCESS){
			free(line);
			return status;
		}
		merge_sort(vector,n);
		for(size_t i = 0; i < n; i++){
			if (i != n-1) {
				fprintf(files[1], "%d ", vector[i]);
			}
			else {
				fprintf(files[1], "%d", vector[i]);
			}
		}
		fprintf(files[OUTPUT_POS], "\n");

		free(vector);
		free(line);
		line = NULL;
	}

	free(line);

	for(size_t i = 0; i < 2; i++)
		if(files[i]!=stdin && files[i]!=stdout) fclose(files[i]);

	return EXIT_SUCCESS;
}

int cliCmd(int argc, char const * argv[], FILE * files[]) {
	int valueToReturn = EXIT_SUCCESS;
	files[INPUT_POS] = NULL;
	files[OUTPUT_POS] = NULL;

	if (argc >  5) {
		fprintf(stderr, "Too many parameters -h for help\n");
		//write(2, "Too many parameters -h for help\n", 0);
		valueToReturn = FINISH;
	}
	if (argc < 2) {
		fprintf(stderr, "At least one parameter is needed, use -h for help\n");
		//write(2, "At least one parameter is needed, use -h for help\n", 0);
		valueToReturn = FINISH;
	}

	for(size_t i = 1; i < argc; i++){
		if (!(strcmp(argv[i], "-h") && strcmp(argv[i], "--help"))){
			fprintf(stdout, "%s", MSG_HELP);
			valueToReturn = EXIT_SUCCESS;
			break;
		}
		if (!(strcmp(argv[i], "-V") && strcmp(argv[i], "--version"))){
			fprintf(stdout, "%.2f", VERSION);
			valueToReturn = EXIT_SUCCESS;
			break;
		}
		if (!(strcmp(argv[i], "-i") && strcmp(argv[i], "--input"))){
			if(strcmp("-",argv[i+1])){
				files[INPUT_POS] = fopen(argv[i+1],"r");
				if(!files[INPUT_POS]){
					fprintf(stderr, "%s", MSG_ERROR_OPEN_INPUT);
					valueToReturn = EXIT_FAILURE;
					break;
				}
			}else{
				files[INPUT_POS] = stdin;
			}
		}
		if (!(strcmp(argv[i], "-o") && strcmp(argv[i], "--output"))){
			if(strcmp("-",argv[i+1])){
				files[OUTPUT_POS] = fopen(argv[i+1],"w");
				if(!files[OUTPUT_POS]){
					fprintf(stderr, "%s", MSG_ERROR_OPEN_OUTPUT);
					valueToReturn = EXIT_FAILURE;
					break;
				}
			}else {
				files[OUTPUT_POS] = stdout;
			}
		}
	}

	return valueToReturn;
}

 int parser(char * line, int ** result, size_t * size_result){
	if(!line) 			return EXIT_FAILURE; //No puede ser null
	if(line[0] == '\n') return EMPTY_LINE;   //Catchear arriba para no aplicar mergesort

	size_t n_sep = 0;
	for (size_t i=0; line[i]; i++)
		if(line[i] == ' ') n_sep++;

	int * vector = (int *) calloc(n_sep + 2, sizeof(int));
	if (!vector){
		fprintf(stderr, "%s", MSG_ERROR_MALLOC);
		return EXIT_FAILURE;
	}

	size_t size = 0;
	long tmp;

	for(char ** ptr2str = &line; **ptr2str != '\0'; (*ptr2str)++){
		if(**ptr2str == ' ' )  continue;
		if(**ptr2str == '\n' ) break;

		tmp = strtol(*ptr2str, ptr2str, DECIMAL); //Si el resultado no se puede representar devuelve cero, la funcion adelanta ptr2str hasta el proximo caracter numerico luego del num leido
		if(tmp > MAX_INT_32 || tmp < MIN_INT_32)
			tmp = 0;

		vector[size++] = (int) tmp;
	}

	*result = vector;
	*size_result = size;

	return EXIT_SUCCESS;
}
