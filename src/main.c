#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define EMPTY_LINE 3

// Intenta parsear un string separado por espacios en un array de int
// ante un error reporta por stderr y devuelve 0.
int parser(char * line, int * result, size_t * size_result);

int main(int argc, const char * argv[]){
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

//Pensar casos borde, linea vacia
//Pensar catcheo de errores
 int parser(char * line, int * result, size_t * size_result){
	if(!line) 			return EXIT_FAILURE; //No puede ser null
	if(line[0] == '\n') return EMPTY_LINE;   //Catchear arriba para no aplicar mergesort

	int * vector = (int *) calloc(strlen(line) / 2, sizeof(int));
	if (!vector) return EXIT_FAILURE;

	size_t size = 0;
	for(size_t i = 0; line[i] != '\0'; i++){
		if(line[i] == ' '){
			continue;
		}
		//atoi ? 
		// if (error ) return EXIT_FAILURE
		num[size++] = //resultado de conversion
	}
	
	result = num;
	*size_result = size;
	return EXIT_SUCCESS;
}