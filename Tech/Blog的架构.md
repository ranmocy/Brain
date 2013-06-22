---
title: Blog 的架构
create-at: 2012-01-29T17:50:00.00+08:00
updated-at: 2012-01-29T17:50:00.00+08:00
category: Tech
---

这个博客系统是基于 `Ruby on Rails 3.2rc2` 构建的。参加 [GitCafe](http://www.gitcafe.com/) 的开发后学习到了很多关于 Rails 的东西，于是使用了如下 `Gem` 包重构了博客：

1. `devise` 用于账号管理相关的功能，十分强大，但同时也配置比较复杂。

2. `slim-rails` slim 语言可以简化 erb 文件的编写，将一切冗余剔除。利用类似 yaml 的风格来处理嵌套和结构。这样所有的结束符都不需要写了。用过之后再也不想写 html 或是 erb 了。视图就清理出来了。

3. `inherited_resources` 将标准的 CRUD 操作完全打包，只需要继承 `Class OoxxController &lt; InheritedResource::Base`，就有了完整的七个操作，而且自定义也十分简单。控制器会变得无比干净。

4. `inherited_resources_views` 这个依赖于上一个包，既然控制器继承自 `InheritedResource::Base`，那么利用 Rails 3.1 的视图继承特性可以将标准的表单视图全部去掉，统一继承自 `app/views/inherited_resource/base/`。这个组件只需要生成一次视图即可移除。唯一的问题在于默认生成在 `app/views/inherited_resource/`，需要手动移动。

5. `redcarpet` 用于 [Markdown](http://daringfireball.net/projects/markdown/syntax) 处理，新版变得无比强大和复杂，支持多种标记语言。

6. `crack` 用于处理 XML 和 JSON 的读取。这个功能做成了一个 rake 任务，从 XML 文件中恢复数据库。导出直接使用视图层提供的指定 format 输出来获取 XML 文件。这个功能就像这个 Gem 包的名字一样，完全是图省事的一个简单暴力的解决方案。已经从 RubyGems 移动到了 GitHub Gems 中去了。可以在 Gemfile 中添加 `gem 'crack', git: 'git://github.com/jnunemaker/crack.git'`，来加入到 Rails 中。或是 `gem install jnunemaker-crack -s http://gem.github.com/` 来添加到系统中去。

7. `sass` &amp; `compass` 在 Rails 3.1 之后 sass 就默认被包含进了 Rails。这个想 slim 一样用类似 yml 风格来处理 css 嵌套。并且提供更为强大的变量和 mixin 处理。加上 `compass` 框架，css 的兼容性和扩展性变得无比强大和简单。`compass` 包含常见的 IE 兼容性处理，css 圆角，多浏览器兼容的各类阴影，分栏效果，按钮 `sprite` 等等。


有了这些 Gem 包的辅助，代码量直线下降，而且更为清晰易于扩展。实属居家旅行必备之 Gem 包。
