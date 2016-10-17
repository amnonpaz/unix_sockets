#include <sys/socket.h>
#include <sys/un.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <unistd.h>

#include <string.h>
#include <errno.h>

#include <defs.h>

#define MAX_CLIENTS 10
#define TERM_CMD "TERM"
#define TERM_CMD_LEN (strlen(TERM_CMD))

/**
 * bind_address: Bind a path to a socket
 *
 * Returns: Fail/Pass
 */
int bind_address(int sock, const char *path)
{
    struct sockaddr_un addr;

    memset(&addr, 0x00, sizeof(addr));
    addr.sun_family = AF_UNIX;
    strncpy(addr.sun_path, path, sizeof(addr.sun_path));

    return bind(sock, (struct sockaddr *)&addr, sizeof(addr));
}

/**
 * create_socket: Create a new Unix-domain soket,
 * clear the desired path and bind the socket to
 * the path.
 *
 * Returns: Fail/Pass
 */
int create_socket(const char *path)
{
    int res;

    int sock = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sock < 0) {
        LOGE("Failed creating a new socket");
        return sock;
    }

    /* Clearing the path, in case the last 
       execution didn't terminate properly */
    unlink(path);

    res = bind_address(sock, path);
    if (res < 0) {
        LOGE("Failed binding socket to %s (%d: %s)",
             path, errno, strerror(errno));
        goto bind_error;
    }

    res = listen(sock, MAX_CLIENTS);
    if (res < 0) {
        LOGE("Failed listening on socket (%d: %s)", errno, strerror(errno));
        goto listen_error;
    }

    return sock;

listen_error:
    unlink(path);
bind_error:
    close(sock);

    return res;
}

/**
 * destroy_socket: Close the socket and clear
 * the path
 */
void destroy_socket(int sock, const char *path)
{
    close(sock);
    unlink(path);
}

/**
 * handle_client: Example on handling a client
 * connection - Receive a buffer, print the
 * incoming data and return "Got it" message.
 * If the client sent us "TREM", then the session
 * will be over
 */
void handle_client(int sock)
{
    char buff[MAX_BUFFER_LEN];
    const char gotit[] = "Got your message\n";
    int len, err;

    while (1) {
        len = read(sock, buff, MAX_BUFFER_LEN-1);
        if (len <= 0) {
            if (errno == ENOENT) {
                LOGI("Client socket was closed by peer");
            } else {
                LOGE("Failed reading from client (%d: %s)",
                     errno,
                     errno ? strerror(errno) : "No input on socket");
            }
            return;
        }
    
        LOGI("Incoming message: %.*s", len, buff);

        err = write(sock, gotit, strlen(gotit));
        if (err <= 0) {
            LOGE("Failed writing to socket (%d: %s)",
                 errno,
                 errno ? strerror(errno) : "No data could be written to socket");
            return;
        }

        if (!strncmp(buff, TERM_CMD, MIN(TERM_CMD_LEN, len)))
            break;
    }
}

/**
 * run: Loop and wait for connecting clients
 *
 * Returns: Fail/Pass
 */
int run(int sock)
{
    while (1) {
        int client_socket = accept(sock, NULL, NULL);
        if (client_socket < 0) {
            if (errno != EINTR)
                continue;

            LOGE("Failed accepting client (%d: %s)", errno, strerror(errno));
            break;
        }

        handle_client(client_socket);

        close(client_socket);
    }

    return 0;
}

int main(int argc, char *argv[])
{
    char *path;
    int sock;

    if (argc < 2) {
        LOGI("Usage: %s <socket path>", argv[0]);
        return 0;
    }

    LOGI("Starting \"Unix Domain Sockets\" demo listener");

    path = argv[1];
    sock = create_socket(path);
    if (sock < 0)
        return 1;

    run(sock);

    destroy_socket(sock, path);

    return 0;
}
