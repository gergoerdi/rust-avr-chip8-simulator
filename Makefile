target		= Main
cc_srcs		= Board Util SPIRAM LCD Keypad

PKGS		= simavr sdl2
CPPFLAGS	= $(shell pkg-config --cflags $(PKGS))
LDFLAGS		= $(shell pkg-config --libs $(PKGS))
LDFLAGS 	+= -pthread -Wl,--no-as-needed

CXXFLAGS	+= --std=c++11 -g -Wall

OBJ 		:= obj-${shell $(CC) -dumpmachine}

all: obj ${target}

obj: ${OBJ}

clean: clean-${OBJ}

board = ${OBJ}/${target}.elf

${board} : ${OBJ}/${target}.cc.o ${foreach src, ${cc_srcs}, ${OBJ}/${src}.cc.o}

${target}: ${board}
	@echo $@ done

${OBJ}/%.c.o: src/%.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -MMD \
		$<  -c -o $@

${OBJ}/%.cc.o: src/%.cc
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -MMD \
		$<  -c -o $@

${OBJ}/%.elf:
	$(CXX) -MMD ${CFLAGS}  ${LFLAGS} -o $@ $^ $(LDFLAGS)

${OBJ}:
	@mkdir -p ${OBJ}

clean-${OBJ}:
	rm -rf ${OBJ}

# include the dependency files generated by gcc, if any
-include ${wildcard ${OBJ}/*.d}
