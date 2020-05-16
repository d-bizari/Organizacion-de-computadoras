#include <unistd.h>
extern size_t merge_sort(const char *);

int main(int argc, char * const argv[]){
    char *msg = "Hola mundo.\n";
    write(1, msg, merge_sort(msg));
    return 0;
}
