# Copyright (c) 2018 TK Chia
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; ; see the file COPYING.  If not see
# <http://www.gnu.org/licenses/>.

prefix = $(HOME)/.local
boot_dest = $(prefix)/dosemu-on-travis-ci/boot

install:
	@# Install Andrew Bird et al.'s packages for dosemu2 and fdpp (FreeDOS
	@# plus plus).
	@#
	@# It is also possible to use the 16-bit FreeDOS kernel (e.g. via
	@# www.dosemu.org/stable/) instead of fdpp, but this will likely use
	@# the Open Watcom C runtime, whose license is not (yet) considered
	@# DFSG-/FSF-free; see the discussion at https://bugs.debian.org/
	@# cgi-bin/bugreport.cgi?bug=376431 .
	@#
	@# As for the command.com command interpreter, this setup currently
	@# uses FreeDOS's FreeCOM 0.84-pre6 as compiled with gcc-ia16 (see
	@# https://github.com/FDOS/freecom/releases/tag/com084pre6).  This is
	@# not exactly an official stable release, but it should be enough for
	@# our needs.
	sudo add-apt-repository -y ppa:dosemu2/ppa
	sudo apt-get update -y
	sudo apt-get install -y dosemu2 fdpp
	dosemu.bin --version
	dpkg -L dosemu2
	dpkg -L fdpp
	@# Copy out our ./boot/ directory to the installation target directory
	@# (currently set to be somewhere in the user home directory).
	rm -rf $(boot_dest)
	mkdir -p $(boot_dest)
	cp -a boot/* $(boot_dest)
	@# Prime the dosemu2 installation, using the "boot" directory as the
	@# boot drive (C:).
	until \
	    rm -rf ~/.dosemu && \
	    (echo; echo; echo; echo; echo; echo exitemu) | \
	     DOSEMU2_FREEDOS_DIR=$(boot_dest) dosemu.bin -I 'video {none}' || \
	    rm -rf ~/.dosemu && \
	    ln -sf /usr/share/fdpp/fdppkrnl.sys $(boot_dest)/fdppkrnl.sys && \
	    (echo; echo; echo; echo; echo; echo exitemu) | \
	     dosemu.bin -I 'video {none}' -i$(boot_dest); \
		do true; done
	@# Do some quick tests to see if dosemu2 works as expected.
	dosemu -dumb -quiet -K hello.com | tee /dev/stderr | \
	    fgrep -q 'Hello world!'
	dosemu -dumb -quiet -K hello-lfn.com | tee /dev/stderr | \
	    fgrep -q 'Hello world (with long file name)!'

.PHONY: install
