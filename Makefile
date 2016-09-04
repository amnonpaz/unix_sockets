.PHONY: all clean

CC = gcc
RM = rm -f
CFLAGS = -g -Wall
LDFLAGS =
INCLUDES = -Isrc/include/ 

LISTENER_TARGET = listener
LISTENER_SRCS = src/listener/listener.c
LISTENER_OBJS = $(LISTENER_SRCS:.c=.o)

TARGETS = $(LISTENER_TARGET)
ALL_OBJS = $(shell find -name *.o)

all: clean $(TARGETS)

$(LISTENER_TARGET): $(LISTENER_OBJS)

$(TARGETS): 
	@echo "Linking $@"
	@$(CC) $(LDFLAGS) -D_SERVICE_NAME=$@ -o $@ $^

%.o: %.c
	@echo "Compiling $<"
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

clean:
	@echo "Cleaning..."
	@$(RM) $(TARGETS) $(ALL_OBJS)
