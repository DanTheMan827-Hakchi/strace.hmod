all: out/strace_4.20_armhf.hmod

out/strace_4.20_armhf.hmod: mod/bin/strace
	mkdir -p "out/"
	echo "---" > mod/readme.md
	echo "Name: `head -n 1 readme.md | cut -c 3-`" >> mod/readme.md
	echo "Creator: DanTheMan827" >> mod/readme.md
	echo "Developer: Dmitry Levin" >> mod/readme.md
	echo "Category: Developer Tools" >> mod/readme.md
	echo "Packed on: `date`" >> mod/readme.md
	echo "Git commit: $(GIT_COMMIT)" >> mod/readme.md
	echo "---" >> mod/readme.md
	sed 1d readme.md >> mod/readme.md
	tar -czvf "$@" -C "mod/" bin
	touch "$@"

mod/bin/strace: src/strace-4.20/strace
	mkdir -p "`dirname "$@"`"
	cp "$<" "$@"
	arm-linux-gnueabihf-strip "$@"
	upx --ultra-brute "$@"
	chmod +x "$@"

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
