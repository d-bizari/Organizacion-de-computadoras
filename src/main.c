#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
	if(line == NULL){
		return NULL;
	}
	
	int * num = malloc(sizeof(int) * strlen(line) / 2); // pensar un poco mejor la cantidad de memoria que pido, pensar en el formato que me llega

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