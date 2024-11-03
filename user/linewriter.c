// linewriter.c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fcntl.h"

#define MAX_LINE_LENGTH 128

int
main(void)
{
    char filename[MAX_LINE_LENGTH];
    char line[MAX_LINE_LENGTH];
    int fd;
    int empty_line_count = 0;

    // Prompt for the file name
    printf("Enter the file name: ");
    if (gets(filename, sizeof(filename)) == 0) {
        printf("Error reading file name.\n");
        exit(-1);
    }

    // Remove the newline character from the file name
    int len = strlen(filename);
    if (filename[len - 1] == '\n') {
        filename[len - 1] = '\0';
    }

    // Open the file for writing (create if it doesn't exist)
    fd = open(filename, O_CREATE | O_WRONLY);
    if (fd < 0) {
        printf("Error opening file %s\n", filename);
        exit(-1);
    }

    printf("Enter text (enter two empty lines to finish):\n");

    while (1) {
        // Read a line from stdin
        if (gets(line, sizeof(line)) == 0) {
            printf("Error reading input.\n");
            close(fd);
            exit(-1);
        }

        // Check if the line is empty (only contains a newline character)
        if (strlen(line) <= 1) {
            empty_line_count++;
        } else {
            empty_line_count = 0;
        }

        // If two empty lines are entered consecutively, break the loop
        if (empty_line_count >= 2) {
            break;
        }

        // Write the line to the file
        if (write(fd, line, strlen(line)) != strlen(line)) {
            printf("Error writing to file.\n");
            close(fd);
            exit(-1);
        }
    }

    close(fd);
    printf("File %s has been saved.\n", filename);
    exit(0);
}

