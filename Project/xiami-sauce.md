---
title: 虾米酱
created_at: 2013-03-10T00:00:00+0800
updated_at: 2013-03-10T00:00:00+0800
category: Project
---

# 虾米酱 - XiamiSauce

[虾米酱 - XiamiSauce](https://github.com/ranmocy/xiami_sauce) 是一个虾米音乐下载器。
封装成为一个 [Ruby Gem 包](https://rubygems.org/gems/xiami_sauce)。

Fork me at [Github](https://github.com/ranmocy/xiami_sauce)

## 安装 - Installation

一句话安装 - Install it with one-line code:

    $ gem install xiami_sauce --no-ri --no-doc

## 使用方法 - Usage

    $ xsauce http://www.xiami.com/artist/64360
    $ xsauce http://www.xiami.com/album/355791
    $ xsauce http://www.xiami.com/song/184616

虾米酱会按照歌曲信息下载到 `[artist]/[album]/[index].[song].mp3`。
