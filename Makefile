.PHONY: all clean

CC = gcc
RM = rm -f
CFLAGS = -g -Wall
LDFLAGS =
INCLUDES = -Isrc/include/ 

EXTRA_CFLAG =

## Listener
LISTENER_TARGET = listener
LISTENER_SRCS = src/listener/listener.c
LISTENER_OBJS = $(LISTENER_SRCS:.c=.o)

TARGETS = $(LISTENER_TARGET)

all: clean $(TARGETS)

$(LISTENER_TARGET): EXTRA_CFLAGS+=-DSERVICE_NAME=\"LISTENER\"

$(LISTENER_TARGET): $(LISTENER_OBJS)

$(TARGETS): 
	@echo "Linking $@..."
	@$(CC) $(LDFLAGS) -o $@ $^

%.o: %.c
	@echo "Compiling $<"
	@$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@echo "Cleaning..."
	@$(RM) $(TARGETS) $(ALL_EXISTING_OBJS)
