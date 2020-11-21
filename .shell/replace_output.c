#include <stdio.h>
#include <stdlib.h>

// To compile with additional logs run:
// $ g++ -DDEBUG=1 replace_output.c

/*
 Function which allows to replace previously written command line output
 with other content.
 */
void replace_output(int lines, const char *content) {
    for (int i = 0; i < lines; ++i) {
        printf("\033[F%s", content);
    }
}

int main(int argc, char *argv[]) {
    int lines = 0;
    const char *content = "";
    for (int i = 0; i < argc; ++i) {
#ifdef DEBUG
        printf("arg%d=%s\n", i, argv[i]);
#endif
        if (i == 1) lines = atoi(argv[i]);
        if (i == 2) content = argv[i];
    }
    
    replace_output(lines, content);
    
    return 0;
}
