#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "../functions/functions.h"

int main(int argc, char *argv[]) 
{
    if (argc != 4) 
    {
        printf("Usage: %s -(e/d) input_file output_file\n", argv[0]);
        return 1;
    }

    char *input_filename = argv[2];
    char *output_filename = argv[3];

    FILE *input_file = fopen(input_filename, "r");

    if (input_file == NULL) 
    {
        printf("Error while opening input_file!\n");
        return 1;
    }

    fseek(input_file, 0, SEEK_END); 
    long size = ftell(input_file);   
    fseek(input_file, 0, SEEK_SET);  

    char *text = (char *)malloc(size + 1); 
    if (text == NULL) 
    {
        fclose(input_file);
        printf("Memory allocation error!\n");
        return 1;
    }

    fread(text, 1, size, input_file);
    text[size] = '\0';

    fclose(input_file);    

    int opt;
    int encoded_flag = 0;
    int decoded_flag = 0;

    while ((opt = getopt(argc, argv, "ed")) != -1) 
    {
        switch (opt) {
            case 'e':
                encoded_flag = 1;
                break;
            case 'd':
                decoded_flag = 1;
                break;
            default:
                fprintf(stderr, "Usage: %s [-e] [-d]\n", argv[0]);
                return 1;
        }
    }

    char result[1000] = "";

    if (encoded_flag == 1)
    {
        for (int i = 0; i < strlen(text); i++) 
        {
            if (isalpha(text[i]) || isspace(text[i])) 
            {
                strcat(result, charToMorse(text[i]));
                strcat(result, " ");
            }
        }
    }

    if (decoded_flag == 1)
    {
        char* morseCode = strtok(text, " ");
    
        while (morseCode != NULL) 
        {
            char ch = morseToChar(morseCode);
            strncat(result, &ch, 1);
            morseCode = strtok(NULL, " ");
        }
    }

    FILE *output_file = fopen(output_filename, "w");

    if (output_file == NULL) 
    {
        printf("Error while opening file!\n");
        return 1;
    }

    fputs(result, output_file);

    fclose(output_file);

    free(text);

    return 0;
}
