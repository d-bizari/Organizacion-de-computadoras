#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define OPEN_FILE 4
#define WRITE_FILE 5
#define OPEN_WRITE_FILE 6
#define EMPTY_LINE 3
#define DECIMAL    10
#define MAX_INT_32 2147483647
#define MIN_INT_32 (-INT32_MAX-1)


int cliCommands(int argc, char const * argv[], char const* argv_inputs[]) {
	argv_inputs[0] = "";
	argv_inputs[1] = "";
	int valueToReturn = EXIT_SUCCESS;
	if (argc >  5) {
		write(2, "Too many parameters -h for help\n", 0);
		valueToReturn = EXIT_FAILURE;
	}
	if (argc < 2) {
		write(2, "At least one parameter is needed, use -h for help\n", 0);
		valueToReturn = EXIT_FAILURE;
	}
	if (argc == 2 && !(strcmp(argv[1], "-h") && strcmp(argv[1], "--help"))) {
		char* msg = "Usage:\ntp1 -h\ntp1 -V\ntp1 -i in_file -o out_file\nOptions:\n-V, --version Print version and quit.\n"
		"-h, --help Print this information and quit.\n-i, --input Specify input stream/file, \"-\" for stdin.\n"
		"-o, --output Specify output stream/file, \"-\" for stdout.\n";
		write(1, msg, 0);
		valueToReturn = EXIT_FAILURE;
		}
	else if (argc == 2) {
		argv_inputs[0] = argv[1];
	}
	if (argc == 4 && !(strcmp(argv[2], "-o") && strcmp(argv[2], "--output")) && (strcmp(argv[1], "-i") && strcmp(argv[1], "--input"))) {
		argv_inputs[0] = argv[1];
		argv_inputs[1] = argv[3];
		return WRITE_FILE;
	}
	if (argc == 3 && !(strcmp(argv[1], "-i") && strcmp(argv[1], "--input"))) {
		argv_inputs[0] = argv[2];
		argv_inputs[1] = "";
		return EXIT_SUCCESS;
	}
	if (argc == 5 && !(strcmp(argv[3], "-o") && strcmp(argv[3], "--output")) && !(strcmp(argv[1], "-i") && strcmp(argv[1], "--input"))) {
		argv_inputs[0] = argv[2];
		argv_inputs[1] = argv[4];
		return OPEN_WRITE_FILE;
	}
	return valueToReturn;
}

// Intenta parsear un string separado por espacios en un array de int
// ante un error reporta por stderr y devuelve 0.
int parser(char * line, int ** result, size_t * size_result);
int main(int argc, const char * argv[]){
	char str[20000];

	while(fgets(str, 20000, stdin)){
		int * vec = NULL;
		size_t s = 0;

		parser(str,&vec, &s);

		for(size_t i = 0; i < s;i++){
			printf("%d ", vec[i]);
		}

		printf("\n");
		free(vec);
	}

	char* inputs[2];
	int action = cliCommands(argc, argv, inputs) == EXIT_FAILURE;
	if (action == EXIT_FAILURE) return EXIT_FAILURE;
	printf("%s", inputs[0]);
//	if (action == OPEN_FILE) {
		//READ_FILE AND ASSIGN TO INPUTS[0]
//	}
//	if (action == WRITE_FILE) {
		//WITH THIS WE KNOW THAT A COMMAND TO WRITE A FILE WAS SEND AND THE LOCATION
		//IS IN INPUTS[1]
//	}
//	if (action == OPEN_WRITE_FILE) {
		//COMBINATION OF THE ABOVE CASES, A COMBINATION OF METHODS SHOULD BE PUT HERE
//	}
	// Apertura de archivo
	// Inicio de while != feof(archivo)
	// Intentar parsear linea
	// aplicar mergesort
	// printer en file output
	// repetir ciclo
	// cerrar archivos
	return 0;
}

 int parser(char * line, int ** result, size_t * size_result){
	if(!line) 			return EXIT_FAILURE; //No puede ser null
	if(line[0] == '\n') return EMPTY_LINE;   //Catchear arriba para no aplicar mergesort

	size_t n_sep = 0;
	for (size_t i=0; line[i]; i++)
		if(line[i] == ' ') n_sep++;

	int * vector = (int *) calloc(n_sep + 2, sizeof(int));
	if (!vector) return EXIT_FAILURE;

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
