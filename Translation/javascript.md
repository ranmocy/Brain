---
title: "JavaScript: 世界上被误解最深的编程语言"
created_at: 2014-04-06T00:15:13-0800
updated_at: 2014-04-06T00:15:13-0800
category: Translation
---

> 英文原文：<br/>
[Douglas Crockford - JavaScript: The World's Most Misunderstood Programming Language](http://www.crockford.com/javascript/javascript.html)<br/>
> 原文写于 2001 年
<!-- > 本翻译已获得原作者 Douglas Crockford 的许可。 -->

[JavaScript](http://javascript.crockford.com/)，亦即 Mocha，亦即 LiveScript，亦即 JScript，亦即 ECMAScript，是世界上最流行的编程语言之一。实际上，世界上几乎所有的个人电脑都安装了至少一个 JavaScript 解释器并在频繁使用。JavaScript 的流行完全要归功于其作为万维网脚本语言的角色。

尽管它很流行，却很少有人知道 JavaScript 是一个非常棒的，动态的，面向对象的，通用编程语言。这怎么会不为人所知呢？为什么这个语言如此被误解？

## 名字

**Java-** 这个前缀使人想到 JavaScript 多少应该和 Java 有点联系，可能是 Java 的超集或是精简集。看起来选择名字的时候就故意制造这种混淆，并从这种混淆发展成了误解。JavaScript 并不是用来解释 Java 的。Java 才解释了 Java。JavaScript 是另外一个语言。

JavaScript 的语法与 Java 之相似甚过于 Java 相对于 C。但是它并非如同 Java 是 C 的超集一般，是 Java 的超集。它在 Java（原名 Oak）最初的应用场景中比 Java 表现的更好`（译注：Java 最初是为 Web 设计的。）`。

JavaScript 并不是由 Java 的母公司，Sun 微系统公司开发的。JavaScript 是由网景公司开发的。它原本被称为 LiveScript，这个名字还不怎么容易混淆。

**-Script** 后缀让人感觉它并不是一个编程语言，脚本语言多少感觉比编程语言要少点什么。但这强调了它的专长。和 C 相比，JavaScript 用性能换取了表达能力和动态性。

## 披着 C 的外皮的 Lisp

JavaScript 的类 C 语法，包括花括号和老式的 `for` 语句，让它看起来像是一个普通的过程语言。这完全是误解，因为 JavaScript 与其说像 C 或 Java，更像是 [Lisp 或 Scheme](http://www.crockford.com/javascript/little.html) 这类函数式语言。它用数组取代列表，用对象取代属性表；函数是一等公民；它有闭包；你不用匹配括号就能得到 lambda 函数。

## 角色定位

JavaScript 被设计用来跑在网景的 Navigator 浏览器里。它在那里的成功致使其发展成为几乎全部网页浏览器的标配。角色定位功不可没。JavaScript 是编程语言里的 [George Reeves](http://www.amazon.com/exec/obidos/ASIN/B000KWZ7JC/wrrrldwideweb)。JavaScript 也广泛适用于非网页相关的应用。

## 不确定的目标

JavaScript 的第一个版本相当羸弱。它缺少异常处理，内部函数和继承。而它现在的形式已经成为一个完整的，面向对象的编程语言了。但是很多对于这门语言的看法仍然认为其形式很不成熟。

负责管理该语言的 ECMA 委员会正意图定制扩展标准，用以解决该语言的一个最大的问题：太多的版本造成的分歧。

## 设计错误

没有完美的编程语言。JavaScript 也有它设计上的错误，像是加法和串联都是利用重载`+`和强制转换来表达，`with` 语句的错误倾向都是应该避免的。保留字策略过于严格。分号的插入是一个巨大的失误，像是字面正则表达式的标记方法一样。这些失误致使编程错误，使得语言设计的整体性成为问题。幸运的是这些问题可以通过一个良好的[分析程序](http://www.jslint.com/)来缓解。

语言设计失误基本上都相当明显。令人意外地是，ECMAScript 委员会似乎对纠正这些问题没什么兴趣。可能他们更有兴趣去制造问题。

## 糟糕的实现

一些早期的 JavaScript 实现充满了 bug。这严重反映在语言上。雪上加霜的时，这些实现被引进充满 bug 的网页浏览器。

## 坏的书籍

几乎所有关于 JavaScript 的书籍都极其槽糕。他们包含着错误，拙劣的样例，提倡着差劲的设计。语言中重要的特性都被一笔带过或是完全抹去。我评估了许多 JavaScript 书籍，*我只能推荐这一本：*[JavaScript：权威指南（第五版）](http://www.amazon.com/exec/obidos/ASIN/0596101996/wrrrldwideweb)，作者 David Flanagan。（作者们请注意：如果你写了本好书，请发送给我一份样书来评估。）

## 不标准的标准

[官方的语言标准说明](http://www.ecma-international.org/publications/standards/Ecma-262.htm)是由 [ECMA](http://www.ecma-international.org/) 发布的。该标准质量及其差劲。非常难以阅读和理解。这也是那些糟糕的书籍出现的原因之一，因为作者无法利用标准文档来增进他们对语言的理解。ECMA 还有 TC39 委员会实在应该为此感到羞愧。

## 业余

大部分写 JavaScript 的人并不是程序员。他们缺乏写良好程序的训练和准则。JavaScript 有良多的表达能力，但他们却完全不能借此做些有用的东西。这让 JavaScript 背上了适合业余人员使用的名声，并且并不适合成为专业编程语言。这根本不是真的。

## 面向对象

JavaScript 面向对象么？它的对象可以包含数据和对数据进行操作的方法。对象可以包含其他对象。它没有类，但是它有构造器能够完成类能做的事情，包括像是类的变量和方法的容器。它没有面向类的继承，但是它有面向原型的继承。

两个主要的构建对象系统的方法是利用继承（is-a）或是利用聚合（has-a）。JavaScript 这两种方法都有，但是它的动态性让它更适合聚合。

一些关于 JavaScript 并非面向对象的争论说它并不提供隐藏信息。就是说，对象不能拥有私有变量和私有方法：所有的成员都是公开的。

但是事实上 JavaScript 对象是可以拥有私有变量和私有方法的。（[这里说明如何做到](http://www.crockford.com/javascript/private.html)）当然，很少有人知道这个，因为 JavaScript 是世界上被误解最深的编程语言。

一些争论说 JavaScript 并非面向对象因为它没有提供继承。但是事实上 JavaScript [不仅提供了类继承，还提供了其他重用代码的模式](http://www.crockford.com/javascript/inheritance.html)。
