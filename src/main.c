#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EMPTY_LINE 3
#define DECIMAL    10
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
	
	
	// Parsear CLI nacho
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
		if(tmp > INT32_MAX || tmp < INT32_MIN) 
			tmp = 0;

		vector[size++] = (int) tmp;
	}
	
	*result = vector;
	*size_result = size;
	
	return EXIT_SUCCESS;
}