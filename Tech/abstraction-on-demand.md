---
title: 按需抽象 Abstraction on Demand
created_at: 2016-04-08T01:25:57-0800
updated_at: 2016-04-08T01:25:57-0800
category: Tech
---

前些日子收笔了自己的一个业余项目[Coolol](http://coolol.me)。简单来说这是一个纯 Web 的推特客户端，写作目的是验证自己的几个 idea。他们是：按需抽象；面向组件；定制推特。

# 按需抽象 Abstraction on Demand

这个词是我看一个博客<sup>1</sup>的时候想到的。它让我想起了之前自己的编程体会。简单的来说就是在解决任意问题的时候先用最直接的方法来处理，然后回头观察，系统中是否出现重复的代码或模式，如果有，对他们进行抽象，减少代码。没有重复模式不要提前过度优化。

Framework 的出现就是为了抽象某一领域重复出现的模式。但是实际使用的时候我发现他们帮助并没有预想的那么大，尤其是在 JavaScript 领域，框架层出不穷，但是学习成本却愈发增加，magic 和 convention 越来越多，解决的抽象却未有十足的长进。JavaScript 这门语言其实很灵活，解决各种模式都不需要庞大的代码。没有必要为解决特定的问题引入一整套解决方案，往往杀鸡用牛刀。Knuth 说“过早优化是万恶之源”。引入不需要的抽象就是过早优化的一个体现。

Coolol 没有使用任何现有的框架，所以代码体积非常精简，逻辑也非常简单。在写作初期，我只给它设定了两个概念：组件（Component）和服务（Service）。组件描述了一个带视图和逻辑的对象，服务描述了一个全局的后台对象。服务很好理解，它们是全局的单例（Singleton），任何人都可以调用它们。至于组件，下一节会讲到他们。

服务里有很多有趣的抽象。比如Utils，放的都是我经常用到函数。函数是最简单，最常见的抽象<sup>2</sup>，像是`document.querySelector()`用的非常多，所以就仿 jQuery 的语法，把它变成`$()`；经常要迭代一个 object 的 key 和 value，就写了一个`forEachKeyValue(object, callback)`，然后就可以写成`$.forEachKeyValue(obj, (k,v) => { xxx; })`，而不用繁琐的、可读性差的`Object.keys(obj).forEach((k) => { var v=obj[k]; xxx; }`。还有稍微复杂一些的函数，像是`$.registerObjectCallback(obj, callback)`和`$.updateObject(obj, {field: new_value, ...})`。前者会将一个 callback 函数绑定到一个对象上，而后者则会更新一个对象的多个键值并触发全部绑定的 callback，然后移除 callback 列表。这样两个总共三十几行的函数便可完成数据双向绑定的设计模式。而且机制非常透明，就是函数调用，没有任何隐藏的 magic。










<small>

1. [No more JS frameworks](http://bitworking.org/news/2014/05/zero_framework_manifesto)
2. 严格的来说，还有比函数更简单的抽象，比如说变量，它把对表达式的值的引用抽象为一个符号。

</small>
