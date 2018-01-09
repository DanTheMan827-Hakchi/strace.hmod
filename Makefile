all: out/strace_4.20_armhf.hmod

out/strace_4.20_armhf.hmod: src/strace-4.20/strace
	mkdir -p "mod/bin/" "out/"
	cp "$<" "mod/bin/"
	arm-linux-gnueabihf-strip "mod/bin/strace"
	upx --ultra-brute "mod/bin/strace"
	chmod +x "mod/bin/strace"
	tar -czvf "$@" -C "mod/" bin
	touch "$@"

src/strace-4.20/strace: src/strace-4.20/Makefile
	make -C "src/strace-4.20"
	touch "$@"

src/strace-4.20/Makefile: src/strace-4.20/configure
	cd "src/strace-4.20/"; \
	./configure --host arm-linux-gnueabihf
	touch "$@"

src/strace-4.20/configure: src/strace-4.20.tar.xz
	tar -xJvf "$<" -C "src/"
	touch "$@"

src/strace-4.20.tar.xz:
	mkdir -p "src/"
	wget "https://github.com/DanTheMan827/strace.hmod/releases/download/tarballs/strace-4.20.tar.xz" -O "$@"

clean: clean-hmod
	-rm -rf "src/"

clean-hmod:
	-rm -rf "mod/" "out/"
	
.PHONY: clean clean-hmod
