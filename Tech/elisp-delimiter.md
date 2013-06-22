---
title: elisp 修饰符
create-at: 2012-06-27 22:38:20 +0800
updated-at: 2012-06-27 22:38:20 +0800
category: Tech
---

Quote
-----

引用，表示不进行运算，返回本身。

    '(list a b)
    =>(list a b)

Backquote + Comma
-----------------

引用，但是可以用`,`选择性求值。

    `(list ,(car (list 'a 'b)) b)
    =>(list a b)

Comma + At
----------

将表达式展开为参数表。

    (setq a (list a b))
    `(list ,@a)
    =>(list a b)
