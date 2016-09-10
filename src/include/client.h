#ifndef __LINUX_SOCKETS_H__
#define __LINUX_SOCKETS_H__

int socket_open(const char *socket_name);
void socket_close(int s);
int socket_read(int s, char *buffer, int len);
int socket_write(int s, const char *buffer, int len);

#endif /* __LINUX_SOCKETS_H__ */
