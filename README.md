# Run Linux DOSEmu on Travis CI

[![(build status)](https://travis-ci.org/tkchia/dosemu-on-travis-ci.svg?branch=master)](https://travis-ci.org/tkchia/dosemu-on-travis-ci)

This project tackles a very small coding subtask: getting [DOSEmu2 for Linux](http://stsp.github.io/dosemu2/) to run (in batch mode) on the [Travis CI](https://travis-ci.org/) test platform.

This allows us to use Travis CI to do automated testing of programs targeted at 16-bit MS-DOS.

Usage:

> `make` [`-C` _source-path_`/dosemu-on-travis-ci`] `install`

> `dosemu -dumb -quiet -K` _dos-program_{`.com` | `.exe`} [`>` _output-log_]
