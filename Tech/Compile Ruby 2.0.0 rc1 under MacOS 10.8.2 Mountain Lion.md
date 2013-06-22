RVM, Rbenv, ruby-build has already support Ruby 2.0.0.
You can build it by them.

## Install YAML lib

    $ brew install libyaml
    $ brew link libyaml

## If you are using RVM:

    $ rvm pkg install openssl
    $ rvm install 2.0.0 --with-openssl-dir=$HOME/.rvm/usr
    $ rvm use 2.0.0

Done.

Otherwise, you need install openssl manually:

## Install OpenSSL

    $ brew install openssl
    $ brew link openssl

## Install Readline(Optional)

    $ brew install readline
    $ brew link readline

## If you are using Rbenv:

    $ CONFIGURE_OPTS="--with-openssl-dir=`brew --prefix openssl` --with-readline-dir=`brew --prefix readline`" rbenv install 2.0.0-rc1

## Here is the tranditional compile:

Although configure warnings `configure: WARNING: unrecognized options: --with-openssl-dir, --with-readline-dir`, 
but it truly works.

Otherwire, openssl will be broken when `make`, which will tell you.

    $ wget http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-rc1.tar.gz
    $ tar xzf ruby-2.0.0-rc1.tar.gz
    $ cd ruby-2.0.0-rc1
    $ ./configure --with-openssl-dir=`brew --prefix openssl` --with-readline-dir=`brew --prefix readline`
    $ make
    $ make install

## (Optional) Install Bundler

Install pre-version of bundler for Ruby 2.0

    $ gem install bundler --pre
