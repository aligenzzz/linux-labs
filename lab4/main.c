#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

#define FILENAME "numbers.txt"
#define NUMBERS_TO_WRITE 20

FILE *file;
int numbers_written = 0;

void sig_handler(int signum)
{
    pid_t pid = fork();
    if (pid < 0)
    {
        perror("Error while forking process!");
        exit(EXIT_FAILURE);
    }
    else if (pid != 0)
    {
        exit(EXIT_SUCCESS);
    }
}

void write_number(int num)
{
    fprintf(file, "%d\n", num);
    fflush(file);
    numbers_written++;
}

int main()
{
    signal(SIGINT, sig_handler);

    file = fopen(FILENAME, "w");
    if (file == NULL)
    {
        perror("fopen");
        exit(EXIT_FAILURE);
    }

    for (int i = 1; i <= NUMBERS_TO_WRITE; i++)
    {
        write_number(i);
        sleep(1);
    }

    fclose(file);

    return 0;
}