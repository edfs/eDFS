Welcome to eDFS
===============

eDFS is a distributed file system built with Erlang.

The goal of this project is to provide a simple system for managing files and data
on multiple storage devices without compromising reliability and performance.


## Getting started

This sections assumes that you have a working installation of git and Erlang(R14B02 or later).

First clone this repository.

    $ git clone https://github.com/edfs/eDFS.git
    $ cd eDFS
    $ make rel


## Server control

To start a daemonized(background) instance of eDFS:

    $ bin/edfs start

To attach to the Erlang console node of the background instance of eDFS:

    $ bin/edfs attach

To stop a background instance of eDFS:

    $ bin/edfs stop

Alternatively, if you want to run a foreground instance of eDFS, you can type either one of the
following commands:

    $ bin/edfs console

    # recompiles source code, run tests and runs in debug mode
    $ make shell


## Accessing the GUI

By default the admin GUI is accessible at http://localhost:9879


## Running tests

To run the test suites:

    $ make tests

You can perform static analysis of the code using dialyzer:

    $ make build-plt
    $ make dialyze


## Clients for other languages

Currently, the official client libraries include:

* Erlang [https://github.com/edfs/edfs-erlang-client](https://github.com/edfs/edfs-erlang-client)
* Python [https://github.com/edfs/edfs-python-client](https://github.com/edfs/edfs-python-client)
* Ruby [https://github.com/edfs/edfs-ruby-client](https://github.com/edfs/edfs-ruby-client)


## Contributing to eDFS

To report a bug or issue, please open a new issue against this repository.

We appreciate any contribution to eDFS so please checkout our CONTRIBTING.md for more information.


## More information

You can find out more about eDFS on [edfs.github.io](http://edfs.github.io)

Also checkout the project's wiki.


## License

eDFS is released under the MIT Licence. See the bundled LICENSE file for details.
