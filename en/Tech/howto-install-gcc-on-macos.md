---
title: Howto Install GCC on MacOS
created_at: 2013-06-12T10:42:01+08:00
updated_at: 2013-06-22T22:42:33+08:00
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
