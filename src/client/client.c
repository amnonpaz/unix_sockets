
#include <defs.h>
#include <client.h>

int main(int argc, char *argv[])
{
    char *path, *data;
    char resp[MAX_BUFFER_LEN]; 
    int sock;

    if (argc < 3) {
        LOGI("Usage: %s <socket path> <data>", argv[0]);
        return 0;
    }

    LOGI("Starting \"Unix Domain Sockets\" demo client");

    path = argv[1];
    data = argv[2];
    sock = socket_open(path);
    if (sock < 0) {
        LOGE("Failed opening socket %s", path);
        return 1;
    }

    if (socket_write(sock, data, strlen(data)) < 0) {
        LOGE("Error writing to socket");
        socket_close(sock);
        return 1;
    }
        
    if (socket_read(sock, resp, ARRAY_LEN(resp)) < 0) {
        LOGE("Error reading from socket");
        socket_close(sock);
        return 1;
    }

    LOGI("Got back: %s", resp);

    socket_close(sock);

    return 0;
}
