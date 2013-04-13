# 在 Bundler 里面运行 Bundler

当 Bundler 被加载两遍但却不是同一个位置的包，
运行会报错，一般是某个包文件没有找到。

比如我正在使用 Ruby 2.0，
想用 Rake 命令运行 `rvm 1.8.7 do bundle install` 同步在 1.8.7 下的 Gems，
除非原本已经安装好了所有的包，否则就会报错找不到修改的包文件。

问题原因在于 Bundler 在运行的时候会检查环境变量来确定自身的位置，
所以只要去掉这个环境变量就可以了，
将命令改为 `env -u RUBYOPT rvm 1.8.7 do bundle install` 就可以正常运行了。

这个在写 Gem 的时候自动配合 Guard 自动跑 Bundler 和 RSpec 会非常有用。
