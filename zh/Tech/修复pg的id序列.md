---
title: 修复PG的id序列
created_at: 2012-02-24T12:40:50+08:00
updated_at: 2012-02-24T12:40:50+08:00
category: Tech
---

突然发现我博客发不了文章了，`heroku logs` 中显示： 

    duplicate key violates unique constraint.

如果你在 Heroku 上或是使用 pg 数据库的时候遇到跟我一样的问题，可以使用如下的方式来解决。

原因在于 pg 认为的下一个可用 id 实际上已经被占用了，我们可以手动运行 SQL 语句来修复这个问题：

    heroku run console
    ActiveRecord::Base.connection.execute(“SELECT ...”).values

假如你的模型叫Article，运行下列 SQL 语句：

    SELECT MAX(id) FROM articles;
    SELECT nextval('articles_id_seq');

对比一下，是不是 seq 的数字小于 max ？

运行这条来修复：

    SELECT setval('articles_id_seq', (SELECT MAX(id) FROM artiles)+1);

如是安可。
