---
title: A tiny history of Reader Mode
created_at: 2023-10-03T14:20:00-0800
updated_at: 2023-10-03T14:20:00-0800
category: Tech
---
We used `@postlight/parser` npm package at first, which is rule based parser matching by domain names. But it has no update for more than a year, so I decide to replace it.
 
Then I found `@extractus/article-extractor` npm package which seems cleaner. Checking it source code then I realize it's not rule based. Underneath it uses `@mozilla/readability` which powers Firefox Reader View. It's more like doing DOM analysis and applies transformations directly.

Then I got curious, what about Safari Reader Mode? [Some discussions](https://stackoverflow.com/questions/4864883/safaris-reader-mode-open-source-solution) show that Apple derived an Apache licensed project `readability` from Arc90. And interestingly, Mozilla's library is also based on the same project, which is more than a decade old project.

What is more interesting is that [a Hacker News thread](https://news.ycombinator.com/item?id=24597951) mentioned that the founder of Arc90 founded a new company after Arc90 was acquired. The company is called Postlight. The first library we used is from them! All major players about cleaning up a web page article are from the same root!