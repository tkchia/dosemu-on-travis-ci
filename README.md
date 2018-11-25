# Run Linux DOSEmu on Travis CI

[![(build status)](https://travis-ci.org/tkchia/dosemu-on-travis-ci.svg?branch=master)](https://travis-ci.org/tkchia/dosemu-on-travis-ci)

This project tackles a very small coding subtask: getting [DOSEmu2 for Linux](http://stsp.github.io/dosemu2/) to run (in batch mode) on the [Travis CI](https://travis-ci.org/) test platform.

This allows us to use Travis CI to do automated testing of programs targeted at 16-bit MS-DOS.

You can use this project as a [submodule](https://git-scm.com/docs/git-submodule) of another Git repository.

## Usage

To use, you can arrange for your project's `.travis.yml` to install DOSEmu inside a Travis virtual environment, by adding this shell command:

> `make` [`-C` _this-dir_] `install`

And, to get Travis to run a program under DOSEmu in "dumb terminal" mode:

> `dosemu -dumb -quiet -K` _prog_{`.com` | `.exe`} [`>` _log_]
