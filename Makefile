ifdef OS
   RM = del /Q
   FixPath = $(subst /,\,$1)
   TARGET = c3270Server_win
   OS_LDLIBS = -lws2_32 -lwsock32
else
   ifeq ($(shell uname), Linux)
      RM = rm -rf
      FixPath = $1
      TARGET = c3270Server_linux
   endif
endif

SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin

EXE := $(BIN_DIR)/$(TARGET)
SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

INC_DIRS := ./include
# (12)Include files add together a prefix, clang make sense that -I flag
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

CFLAGS   := $(INC_FLAGS) -Wall -pthread -std=c99
LDFLAGS  := -Llib
LDLIBS   := -lm $(OS_LDLIBS)

CC 	 := gcc



.PHONY: all clean run

all: $(EXE)
$(EXE): $(OBJ) | $(BIN_DIR)
	$(CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BIN_DIR) $(OBJ_DIR):
	mkdir -p $@

clean:
	$(RM) $(BIN_DIR) 
	$(RM) $(OBJ_DIR)

run: clean . all
	./$(EXE)

.NOTPARALLEL:

-include $(OBJ:.o=.d)