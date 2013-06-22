---
title: Howto Setup Emacs-w3m
created-at: 2012-06-27T22:38:20+08:00
updated-at: 2012-06-27T22:38:20+08:00
category: Tech
---

Install w3m

    brew install w3m

CHECKPOINT:
  Now you have the w3m under your exec-path.

Download from http://emacs-w3m.namazu.org/
Currently newest stable version: http://emacs-w3m.namazu.org/emacs-w3m-1.4.4.tar.gz

If you are using Emacs 24, you have to use development version in CVS.

    cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot login
    # No password is set.  Just hit Enter/Return key.
    cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot co emacs-w3m

CHECKPOINT:
  Now you have the source of emacs-w3m, Luke.

Install it.

    cd emacs-w3m
    autoconf # if it is development version
    ./configure
    make

Move it to your load path by

    (add-to-list load-path "/your/path/to/emacs-w3m")

or

    make install

# Now-you-can

1. (require 'w3m) in your Emacs.

# Finish setup-emacs-w3m #
