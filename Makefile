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

install:
	@# Install Andrew Bird et al.'s packages for dosemu2 and fdpp (FreeDOS
	@# plus plus).
	@#
	@# It is also possible to use a 16-bit FreeDOS installation (e.g. via
	@# www.dosemu.org/stable/), but this will likely use the Open Watcom C
	@# runtime, whose license is not (yet) considered DFSG-/FSF-free (see
	@# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=376431).
	sudo add-apt-repository -y ppa:dosemu2/ppa
	sudo apt-get update -y
	sudo apt-get install -y dosemu2 fdpp
	dosemu.bin --version
	dpkg -L dosemu2
	dpkg -L fdpp
	@# Prime the dosemu2 installation, using the ./boot/ directory as the
	@# boot drive (C:).
	@#
	@# Stas Sergeev in Nov 2018 (https://github.com/stsp/dosemu2/commit/
	@# 40aac533960e4cdfebfdac7bdc058f4f5f8a0d1c) patched dosemu2 to allow
	@# $DOSEMU2_FREEDOS_DIR to specify a directory containing comcom32.exe.
	@#
	@# But the Ubuntu PPA might not have this patch yet, so try using
	@# `dosemu.bin -i' if $DOSEMU2_FREEDOS_DIR does not work.
	until \
	    rm -rf ~/.dosemu && \
	    (echo; echo; echo; echo; echo; echo exitemu) | \
	     DOSEMU2_FREEDOS_DIR="`pwd`"/boot dosemu.bin -I 'video {none}' || \
	    rm -rf ~/.dosemu && \
	    ln -sf /usr/share/fdpp/fdppkrnl.sys boot/fdppkrnl.sys && \
	    (echo; echo; echo; echo; echo; echo exitemu) | \
	     dosemu.bin -I 'video {none}' -i"`pwd`"/boot; \
		do true; done
	@# Do a quick test to see if dosemu2 works as expected.
	dosemu.bin -I 'video {none}' -p -K hello.com | \
	    fgrep 'Hello world!'

.PHONY: install
