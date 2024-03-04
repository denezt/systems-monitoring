#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

#define MAX_SCRIPT_NAME_LEN 256
#define MAX_SCRIPTS 100
#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

static char *flatfile_database;

void* run_script(void* arg) {
    char* script = (char*)arg;
    printf("Running script: %s\n", script);
    system(script);
    free(script); /* Free the dynamically allocated script name */
    return NULL;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <script_list_file>\n", argv[0]);
        exit(EXIT_FAILURE);
    } else {
       flatfile_database = argv[1];
    }
	
	printf("Loading scripts from Flat-File DB: %s\n", flatfile_database);

    // Daemonize the process
    pid_t pid = fork();
    if (pid > 0) {
        // Parent process, exit to return control to the shell
        exit(EXIT_SUCCESS);
    } else if (pid < 0) {
        // Fork failed
        perror("fork");
        exit(EXIT_FAILURE);
    }

    // Child process continues
    // Create a new session
    if (setsid() < 0) {
        perror("setsid");
        exit(EXIT_FAILURE);
    }

	// Read script names from the file
    printf("Read script names from the file %s\n", flatfile_database);
    FILE *file = fopen(flatfile_database, "r");
    if (!file) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    char script[MAX_SCRIPT_NAME_LEN];
    pthread_t threads[MAX_SCRIPTS];
    int thread_count = 0;

    while (fgets(script, MAX_SCRIPT_NAME_LEN, file) && thread_count < MAX_SCRIPTS) {
        // Remove newline character if present
        script[strcspn(script, "\n")] = 0;
		printf("Defining script: %s\n", script);
        // Allocate memory for the script name to pass to the thread
        char* script_arg = strdup(script);
        if (script_arg == NULL) {
            perror("strdup");
            exit(EXIT_FAILURE);
        }

        // Create a thread to run the script
        if (pthread_create(&threads[thread_count], NULL, run_script, script_arg) != 0) {
            perror("pthread_create");
            free(script_arg);
            continue;
        }

        ++thread_count;
    }

    fclose(file);

    // Wait for all threads to complete
    for (int i = 0; i < thread_count; ++i) {
        pthread_join(threads[i], NULL);
    }

    return EXIT_SUCCESS;
}
