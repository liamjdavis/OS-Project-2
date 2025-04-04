#include <stdio.h>
#include <stdlib.h>
#include "process_info.h"

int main() {
    process_info_t* process_list = NULL;

    printf("Inserting processes...\n");
    insert_process(&process_list, 1, "Init", 0, (void*)0x1000, (void*)0x2000);
    insert_process(&process_list, 2, "Shell", 1, (void*)0x1100, (void*)0x2100);
    insert_process(&process_list, 3, "Editor", 2, (void*)0x1200, (void*)0x2200);

    printf("\nCurrent process list:\n");
    display_processes(process_list);

    printf("\nDeleting process with PID 2...\n");
    delete_process(&process_list, 2);

    printf("\nProcess list after deletion:\n");
    display_processes(process_list);

    printf("\nDeleting all remaining processes...\n");
    delete_process(&process_list, 1);
    delete_process(&process_list, 3);

    printf("\nFinal process list:\n");
    display_processes(process_list);

    return 0;
}
