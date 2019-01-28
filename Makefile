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
	@# OK, so there is the original dosemu by "The DOSEMU Team" (www.dosemu.org)
	@# and the upcoming dosemu2 (stsp.github.io/dosemu2).
	@#
	@# While dosemu did --- and probably still does --- have some bugs last
	@# I tried it, it turns out that dosemu2 is (as of writing) still very
	@# unstable.
	@#
	@# And for testing DOS programs, we do want something that is as stable
	@# as possible.
	sudo apt-get update -y
	sudo apt-get install -y dosemu
	dosemu.bin --version
	dpkg -L dosemu
	exec $(MAKE) install-dot-dosemu-and-fix-deb

install-dot-dosemu-and-fix-deb:
	@# Nothing to fix in the installed dosemu for now...
	exec $(MAKE) install-dot-dosemu-only

install-dot-dosemu-only:
	rm -rf ~/.dosemu
	yes | dosemu -dumb -quiet -i exitemu
	exec $(MAKE) installcheck

installcheck:
	@# Do some quick tests to see if dosemu2 works as expected.
	dosemu -dumb -quiet hello.com | tee /dev/stderr | \
	    fgrep -q 'Hello world!'
	dosemu -dumb -quiet hello-lfn.com | tee /dev/stderr | \
	    fgrep -q 'Hello world (with long file name)!'

.PHONY: install install-dot-dosemu-and-fix-deb install-dot-dosemu-only \
    installcheck
