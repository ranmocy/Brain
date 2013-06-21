# GitCafe Ruby 2.0 升级手记

整理了这次升级 GitCafe 的记录，
正好接下来会进行一轮性能优化，同样需要 Benchmark，
希望能给大家做一个参考，算是回报社区吧。

没怎么写过这种总结类的东西，写的不好请大家多多指教~


## Time

基础运算 Benchmark 的结果：
10^8 次加减乘除运算：
`2.0.0-p0`:

    加法：6.754013
    减法：7.637299
    乘法：8.675309
    除法：6.787901

`1.9.3-p327` falcon 补丁：

    加法： 6.717663
    减法： 6.86062
    乘法： 8.244344
    除法： 20.266194

启动速度：
`2.0.0-p0`：

    $ time rails s --daemon -P tmp/pids/daemon.pid -p 6000
    4.93s user 1.60s system 83% cpu 7.816 total

`1.9.3-327` falcon：

    $ time rails s --daemon -P tmp/pids/daemon.pid -p 6000
    5.95s user 2.21s system 83% cpu 9.828 total

运行速度上 Ruby 2.0 和 Ruby 1.9.3 falcon 补丁比差异不大。
启动速度的优化大概有20%，应该是得益于 require 机制的变化。


## Mem

内存使用情况直接取自生产环境的 top，这个没有办法完全控制变量的做对比，
何况所使用的 Gems 都需要升级。但是整体来看差异不明显，不过有轻微的下降：

Rails：

     2767 gitcafe   20   0  355m 191m 5572 S    0  2.4   2:21.41 ruby
    17415 gitcafe   20   0  377m 189m 5092 S    0  2.4   0:27.34 ruby

Worker：

    1748 gitcafe   20   0  232m 119m 6156 S    0  1.5   2:51.08 resque-1.23.0: Wa
    1825 gitcafe   20   0  232m 119m 6156 S    0  1.5   3:05.89 resque-1.23.0: Wa

Passenger：

    17360 gitcafe   20   0  236m 112m 6084 S    0  1.4   0:07.79 Passenger Applica
    16104 root      20   0 43784 8496 2360 S    0  0.1  58:07.71 Passenger spawn s

Ruby 2.0.0-p0：
Rails：

      1968 gitcafe   20   0  350m 173m 4416 S    0  2.2   0:50.86 ruby
      2014 gitcafe   20   0  340m 162m 4380 S    5  2.0   1:31.54 ruby

Worker：

    1511 gitcafe   20   0  271m 113m 4888 S    0  1.4   0:08.88 resque-1.23.1: Waiting 
    1759 gitcafe   20   0  210m 111m 4888 S    0  1.4   0:08.78 resque-1.23.1: Waiting 

Passenger：

    1851 gitcafe   20   0  222m 112m 4584 S    0  1.4   0:08.48 Passenger ApplicationSpawner
    1768 root      20   0 45552 9812 2612 S    0  0.1   0:00.17 Passenger spawn server


## Upgrade

安装过程 Ruby 2.0 相比 Ruby 1.9.3 的最大变化其实是在 openssl 库上吧。
建议各位使用最新的 openssl 库再安装。
如果你使用 RVM 作为安装 Ruby 的源的话，请参考我之前的[一个帖子](http://ruby-china.org/topics/8589#reply24)。
之前 RVM 安装很折腾，不过最新版本的 RVM 已经可以自动检测并安装相应的依赖库了。

## Gems

兼容性问题一直是升级过程中比较难处理的一部分。
但是 Matz 也承诺了，1.9 到 2.0 应该是完美兼容的，否则就是一个 Bug。
这样看来 Bug 还是不少的……
不过 Ruby 社区的 Gems 都非常活跃的跟进并修复了与 2.0 的兼容性问题，
所以没多久，最新的 Gems 就和 Ruby 2.0 完美兼容了。
所以这部分本来最容易出问题的地方也没有预想的那样困难。

这次的迁移主要问题出现在 Mongoid 这个包上，不过官方提供了2.0到3.0的[升级说明](http://mongoid.org/en/mongoid/docs/upgrading.html)。
这也告诉我们紧跟社区保持最新版本的好处。
