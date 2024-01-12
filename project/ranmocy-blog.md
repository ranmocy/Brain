---
title: RanmocyBlog
created_at: 2012-01-26T00:00:00+0800
updated_at: 2024-01-12T12:34:00-0800
category: Project
---

[This Blog](http://ranmocy.info) was [first created](https://github.com/ranmocy/ranmocy_blog) on Jan 26, 2012,
written in Ruby on Rails with a dark design, hosted at [Heroku](https://www.heroku.com/).

Later, I rewrote the UI in a very light style to guide readers to focus on the content.

Then static bloggers rose, and since Heroku was very slow in China,
I abandoned Rails and migrated it to [Jekyll](http://jekyllrb.com/),
hosted at [GitHub](https://github.com/) and [GitCafe](https://gitcafe.com/), which is my first involved startup company.

And finally, I rewrote the UI again, and it became what you can see today.

Along with this exploration, I set up a project for myself, "Brain", to record my mind and what I did.

As a side effect, it introduced the project [Smallest Blogger](http://ranmocy.github.io/smallest-blogger/),
which aims to experiment with how little code is needed to write a static blog generator.
I made it with less than 200 lines of Ruby.

(Broad-)logging is a lifetime project, as I am trying with Brain.

-----

Updated on Jan 12, 2024.

The last update of this blogger code was on Jun 25, 2015. Seven years ago.
A lot of things had changed. The tech stack changed, and my understanding of coding changed as well.

I haven't really used Ruby for more than ten years now. I no longer remember all those APIs to use it efficiently again. Now, most of my code is in JavaScript.

Looking at this project, I decided to rewrite it again with pure JavaScript, with as few dependencies as possible, because the code is likely to be in the archive mode again for a long time after this rewriting. The more dependencies it uses, the harder it is to remember all the APIs/usages to understand the code and change it after a long time.

I dropped all the code structures and OOP and used a simple script instead.
I dropped complex utility libraries even though they are well-designed and use simple hand-written util functions instead.
I aim for simplicity, fewer lines of code over completeness, and just works for my use case.

The result is impressive.
The Ruby version used 13 libraries and nine files. The main building file has 301 lines of Ruby.
Now, I can build the same website with 295 lines of JavaScript in one file and one library to convert Markdown to HTML.
It even has a mini template rendering function that supports looping.
And it takes 240ms to build the entire website, and 15s for CloudFlare from me pushing the code to deploy it everywhere.

This, once again, is an evidence that reducing the requirements would dramatically reduce the software's complexity and increase its quality and speed at the same time.
