---
title: Note of Elisp Delimiter
created-at: 2012-06-27T22:38:20+08:00
updated-at: 2012-06-27T22:38:20+08:00
category: Tech
---

Quote
-----

This is quote. There is no computing. Just return itself.

    '(list a b)
    =>(list a b)

Backquote + Comma
-----------------

This is a backquote to return itself,
but you can use `,` to computing inside.

    `(list ,(car (list 'a 'b)) b)
    =>(list a b)

Comma + At
----------

The expression will be expanded in place.
Useful for dynamic arguments.

    (setq a (list a b))
    `(list ,@a)
    =>(list a b)
