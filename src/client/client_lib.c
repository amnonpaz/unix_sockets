#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#include <defs.h>

static int socket_connect(int sock, const char *socket_name)
{
    struct sockaddr_un address;

    memset(&address, 0x00, sizeof(address));
    address.sun_family = AF_UNIX;
    strncpy(address.sun_path, socket_name, SOCKET_NAME_MAX_LEN);

    return connect(sock, (struct sockaddr *)&address, sizeof(address));
}

int socket_open(const char *socket_name)
{
    int res;

    int sock = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sock < 0)
        return -1;

    res = socket_connect(sock, socket_name);
    if (res < 0) {
        close(sock);
        return res;
    }
    
    return sock;
}

void socket_close(int sock)
{
    if (sock > 0)
        close(sock);
}

int socket_read(int sock, char *buff, int len)
{
    return read(sock, buff, len);
}

int socket_write(int sock, const char *buff, int len)
{
    return write(sock, buff, len);
}
