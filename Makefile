target=	runner
cc_srcs = Board SPIRAM LCD Keypad
simavr = /home/cactus/prog/arduino/libs

IPATH = .
IPATH += ${simavr}/include/simavr

LIBDIR = $(simavr)/lib
LDFLAGS += -lpthread

all: obj ${target}

include Makefile.common

CXXFLAGS	+= $(shell pkg-config --cflags sdl2)
LDFLAGS		+= $(shell pkg-config --libs sdl2)


board = ${OBJ}/${target}.elf

${board} : ${OBJ}/${target}.cc.o ${foreach src, ${cc_srcs}, ${OBJ}/${src}.cc.o}

${target}: ${board}
	@echo $@ done

clean: clean-${OBJ}
#	rm -rf *.a *.axf ${target} *.vcd *.hex