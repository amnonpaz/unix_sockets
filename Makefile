.PHONY: all clean

CC = gcc
CFLAGS = -g -Wall -fPIC
LD = gcc
LDFLAGS =
AR = ar
ARFLAGS = rcs

INCLUDES = -Isrc/include/
RM = rm -f

EXTRA_CFLAG =

## User targets
LISTENER = listener
CLIENT = client
CLIENT_LIB = clientlib

## Actual targets
# Listener
LISTENER_TARGET = listenerd
LISTENER_OBJS = src/listener/listener.o

# Client
CLIENT_TARGET = test_client
CLIENT_OBJS = src/client/client_lib.o src/client/client.o

# Client lib
CLIENT_LIB_TARGET = libclient.a
CLIENT_LIB_OBJS = src/client/client_lib.o

## General targets
EXECUTABLES = $(LISTENER_TARGET) $(CLIENT_TARGET)
STATIC_LIBS = $(CLIENT_LIB_TARGET)
ALL_EXISTING_OBJS = $(shell find -name *.o)

## Converting user targets to actual targets

# "all" should be always first, it is the default
all: clean $(EXECUTABLES) $(STATIC_LIBS)

$(LISTENER): $(CLIENT_TARGET)
$(CLIENT): $(CLIENT_TARGET)
$(CLIENT_LIB): $(CLIENT_LIB_TARGET)

## Dependencies
$(LISTENER_TARGET): EXTRA_CFLAGS+=-DSERVICE_NAME=\"LISTENER\"

$(LISTENER_TARGET): $(LISTENER_OBJS)
$(CLIENT_TARGET): $(CLIENT_OBJS)
$(CLIENT_LIB_TARGET): $(CLIENT_LIB_OBJS)

## Recipes

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
