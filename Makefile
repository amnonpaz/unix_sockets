.PHONY: all clean

CC = gcc
CFLAGS = -g -Wall
LD = gcc
LDFLAGS =
AR = ar
ARFLAGS = rcs

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

## Client lib
CLIENT_LIB_TARGET = client.a
CLIENT_LIB_SRCS = src/client/client_lib.c
CLIENT_LIB_OBJS = $(CLIENT_SRCS:.c=.o)

EXECUTABLES = $(LISTENER_TARGET) $(CLIENT_TARGET)
STATIC_LIBS = $(CLIENT_LIB_TARGET)
ALL_EXISTING_OBJS = $(shell find -name *.o)

all: clean $(EXECUTABLES) $(STATIC_LIBS)

$(LISTENER_TARGET): EXTRA_CFLAGS+=-DSERVICE_NAME=\"LISTENER\"

$(LISTENER_TARGET): $(LISTENER_OBJS)
$(CLIENT_TARGET): $(CLIENT_OBJS)
$(CLIENT_LIB_TARGET): $(CLIENT_LIB_OBJS)

$(EXECUTABLES):
	@echo "Linking $@..."
	@$(LD) $(LDFLAGS) -o $@ $^

$(STATIC_LIBS):
	@echo "Creating static lib $@..."
	@$(AR) $(ARFLAGS) -o $@ $^

%.o: %.c
	@echo "Compiling $<"
	@$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@echo "Cleaning..."
	@$(RM) $(EXECUTABLES) $(STATIC_LIBS) $(ALL_EXISTING_OBJS)
