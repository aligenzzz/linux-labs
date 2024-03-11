#include "functions.h"

char morseToChar(const char* morse) 
{
    if (strcmp(morse, ".-") == 0) return 'A';
    if (strcmp(morse, "-...") == 0) return 'B';
    if (strcmp(morse, "-.-.") == 0) return 'C';
    if (strcmp(morse, "-..") == 0) return 'D';
    if (strcmp(morse, ".") == 0) return 'E';
    if (strcmp(morse, "..-.") == 0) return 'F';
    if (strcmp(morse, "--.") == 0) return 'G';
    if (strcmp(morse, "....") == 0) return 'H';
    if (strcmp(morse, "..") == 0) return 'I';
    if (strcmp(morse, ".---") == 0) return 'J';
    if (strcmp(morse, "-.-") == 0) return 'K';
    if (strcmp(morse, ".-..") == 0) return 'L';
    if (strcmp(morse, "--") == 0) return 'M';
    if (strcmp(morse, "-.") == 0) return 'N';
    if (strcmp(morse, "---") == 0) return 'O';
    if (strcmp(morse, ".--.") == 0) return 'P';
    if (strcmp(morse, "--.-") == 0) return 'Q';
    if (strcmp(morse, ".-.") == 0) return 'R';
    if (strcmp(morse, "...") == 0) return 'S';
    if (strcmp(morse, "-") == 0) return 'T';
    if (strcmp(morse, "..-") == 0) return 'U';
    if (strcmp(morse, "...-") == 0) return 'V';
    if (strcmp(morse, ".--") == 0) return 'W';
    if (strcmp(morse, "-..-") == 0) return 'X';
    if (strcmp(morse, "-.--") == 0) return 'Y';
    if (strcmp(morse, "--..") == 0) return 'Z';
    if (strcmp(morse, " ") == 0) return ' ';
    return '?';
}
