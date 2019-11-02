PREFIX = /usr/local
BINDIR = $(PREFIX)/bin

CC = cc
LD = $(CC)

SRC = xwait.c

OBJ = $(SRC:.c=.o)
BIN = $(SRC:.c=)

all: build

build: $(BIN)

.c.o:
	@echo "CC $<"
	@$(CC) -c $< -o $@

install: xwait
	mkdir -p $(DESTDIR)$(BINDIR)
	install -m 755 -t $(DESTDIR)$(BINDIR) xwait

uninstall:
	rm $(DESTDIR)$(PREFIX)/bin/xwait

clean:
	rm -f $(OBJ) $(BIN)

