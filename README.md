Climc
=====

Climc is a Common Lisp Instant Messaging Client. It is developed on
Debian GNU/Linux, using SBCL .

## Installation

### Installation using asdf-install

Not yet.

### Manual installation

**climc** needs McClim, McClim-TrueType, cl-xmpp, cl-ppcre and their dependencies.
[ASDF]() is used for compilation
Register the .asd file, e.g. by symlinking it, then compile climc using ``asdf:operate``.

    $ ln -sf `pwd`/climc.asd /path/to/your/registry/
    * (asdf:operate 'asdf:load-op :climc)


## Usage

    CL-USER> (climc:start-climc)


## Screenshots

![talk](data/climc-2008-08-01.png)


## Changelog

A changelog is available [here](ChangeLog.md).


## Contact

Nicolas Lamirault <nicolas.lamirault@gmail.com>
