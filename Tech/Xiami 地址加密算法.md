# Xiami 地址加密的算法
```
remain_str = "hFaF4%52pt%m155E43t2i14E39pF.75261%fn68_1931e88121A.t%%779%x%2274.2i2FF%_m"
store      = ["hFaF4%52p", "t%m155E43"]
store      = ["hFaF4%52p", "t%m155E43", "t2i14E39", "pF.75261", "%fn68_19", "31e88121", "A.t%%779", "%x%2274.", "2i2FF%_m"]
address    = "http%3A%2F%2Ff1.xiami.net%2F11768%2F454588%2F%5E2_177%5E361274_2491919.mp3"
address    = "http://f1.xiami.net/11768/454588/^2_177^361274_2491919.mp3"
address    = "http://f1.xiami.net/11768/454588/02_1770361274_2491919.mp3"
```

```ruby
  total      = location[0].to_i
  remain_str = location[1..-1]
  span       = (remain_str.length.to_f / total).floor
  remainder  = remain_str.length % total
  store       = []
  address    = ""
  # remain_str = "hFaF4%52pt%m155E43t2i14E39pF.75261%fn68_1931e88121A.t%%779%x%2274.2i2FF%_m"

  remainder.times do |i|
    store[i] = remain_str[(span+1)*i...(span+1)*(i+1)]
  end
  # store      = ["hFaF4%52p", "t%m155E43"]

  remainder.upto(total-1) do |i|
    index    = span*(i-remainder)+(span+1)*remainder
    length   = span
    store[i] = remain_str[index...index+length]
  end
  # store = ["hFaF4%52p", "t%m155E43", "t2i14E39", "pF.75261", "%fn68_19", "31e88121", "A.t%%779", "%x%2274.", "2i2FF%_m"]

  # Take out every first char in store[i],
  # Then take out every second char in store[i],
  # Then cons together.
  (span+1).times { |col| address << store.collect { |row| row[col] }.join }
  # address = "http%3A%2F%2Ff1.xiami.net%2F11768%2F454588%2F%5E2_177%5E361274_2491919.mp3"

  # unEscape string
  # address = "http://f1.xiami.net/11768/454588/^2_177^361274_2491919.mp3"
  # address = "http://f1.xiami.net/11768/454588/02_1770361274_2491919.mp3"
  address = CGI::unescape(address).gsub('^', '0')
end
```

