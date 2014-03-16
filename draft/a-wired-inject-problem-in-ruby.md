---
title: A wired inject problem in ruby
created-at: 10 March 2014 (Monday)
updated-at: 10 March 2014 (Monday)
category: Tech
---


    [1] pry(main)> [1,2,3].inject(Hash.new([])) { |h,i|
        h[1] += [i]
        h
        }
    => {1=>[1, 2, 3]}
    [2] pry(main)> [1,2,3].inject(Hash.new([])) { |h,i|
        h[1].push(i); h }
    => {}
