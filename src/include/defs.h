#ifndef __UNIX_DOMAIN_SOCKETS_DEMO_DEFS_H__
#define __UNIX_DOMAIN_SOCKETS_DEMO_DEFS_H__

#include <sys/un.h>
#include <stdio.h>

#ifdef SERVICE_NAME
#define LOG(msg, ...) printf("[" SERVICE_NAME "] " msg "\n", ##__VA_ARGS__)
#else
#define LOG(msg, ...) printf(msg "\n", ##__VA_ARGS__)
#endif

#define LOGE(msg, ...) LOG("ERROR " msg, ##__VA_ARGS__)
#define LOGI(msg, ...) LOG("INFO  " msg, ##__VA_ARGS__)

#define MAX(a, b) (((a) > (b)) ? a : b)
#define MIN(a, b) (((a) < (b)) ? a : b)

#define SOCKET_NAME_MAX_LEN \
    (sizeof(struct sockaddr_un) - sizeof(sa_family_t))

#define SOCKET_NAME_LEN(name) \
    MIN(strlen(name, SOCKET_NAME_MAX_LEN))

#define ARRAY_LEN(arr) (sizeof(arr)/sizeof(arr[0]))

#define MAX_BUFFER_LEN 4096

#endif // __UNIX_DOMAIN_SOCKETS_DEMO_DEFS_H__
