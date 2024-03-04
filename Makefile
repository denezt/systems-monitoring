PRGNAME=daemonizer
CC=gcc
FLATFILE_DB=./scripts/system_monitoring_scripts.f2db

all: clean compile test
	@printf "Finish, building programs.\n"

clean:
	@printf "Remove, older builds...\n"
	find build/ -type f -delete 2> /dev/null || printf "No builds were found\n"

compile:
	@printf "Compiling, sources\n"
	@ls build 2> /dev/null || mkdir -v build
	@$(CC) src/$(PRGNAME).c -o build/$(PRGNAME) -pthread

test:
	@printf "\033[36mRunning, an initial test...\033[0m\n"
	./build/daemonizer $(FLATFILE_DB) &
	@printf "\033[36mCompleted, Initial test...\033[0m\n"

