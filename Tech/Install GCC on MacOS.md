---
title: Install GCC on MacOS
create-at: 2013-06-12 10:42:01 +0800
updated-at: 2013-06-22 22:42:33 +0800
category: Tech
---

XCode includes the gcc customized for MacOS, but it is incompatible with a lot of wonderful softwares.

Run `brew doctor` will return:

    Versions of XCode newer than 4.2 don't include gcc 4.2.x.
   
If you have `homebrew`, you can easily run a third-party customized script:

    brew install https://github.com/adamv/homebrew-alt/raw/master/duplicates/gcc.rb

or

    brew install https://raw.github.com/adamv/homebrew-alt/master/duplicates/apple-gcc42.rb

It just works.

##### Reference: #####

    https://github.com/mxcl/homebrew/wiki/Custom-GCC-and-cross-compilers
