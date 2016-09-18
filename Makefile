.PHONY: all clean

CC = gcc
CFLAGS = -g -Wall
LD = gcc
LDFLAGS =

INCLUDES = -Isrc/include/
RM = rm -f

EXTRA_CFLAG =

## Listener
LISTENER_TARGET = listener
LISTENER_SRCS = src/listener/listener.c
LISTENER_OBJS = $(LISTENER_SRCS:.c=.o)

## Client
CLIENT_TARGET = client
CLIENT_SRCS = src/client/client_lib.c src/client/client.c
CLIENT_OBJS = $(CLIENT_SRCS:.c=.o)

TARGETS = $(LISTENER_TARGET) $(CLIENT_TARGET)
ALL_EXISTING_OBJS = $(shell find -name *.o)

all: clean $(TARGETS)

$(LISTENER_TARGET): EXTRA_CFLAGS+=-DSERVICE_NAME=\"LISTENER\"

$(LISTENER_TARGET): $(LISTENER_OBJS)
$(CLIENT_TARGET): $(CLIENT_OBJS)

$(TARGETS): 
	@echo "Linking $@..."
	@$(LD) $(LDFLAGS) -o $@ $^

%.o: %.c
	@echo "Compiling $<"
	@$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@echo "Cleaning..."
	@$(RM) $(TARGETS) $(ALL_EXISTING_OBJS)
