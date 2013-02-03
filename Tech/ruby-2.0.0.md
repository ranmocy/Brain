# Compile Ruby 2.0.0 rc1 under MacOS 10.8.2 Mountain Lion

RVM, Rbenv, ruby-build has already support Ruby 2.0.0.
You can build it by them.

Here is the tranditional compile:

## Install YAML lib

    $ brew install libyaml
    $ brew link libyaml

## Install OpenSSL

    $ brew install openssl
    $ brew link openssl

## Install Readline

    $ brew install readline
    $ brew link readline

## If you are using RVM:

    $ CC=clang rvm install 2.0.0 -C --enable-shared, --with-openssl-dir=/usr/local
    $ rvm use ruby-2.0.0-rc1

## If you are using Rbenv:

    $ CONFIGURE_OPTS="--with-openssl-dir=`brew --prefix openssl`" rbenv install 2.0.0-rc1

## Or you want to compile directly:

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
