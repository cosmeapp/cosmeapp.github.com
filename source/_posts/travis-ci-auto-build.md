---
title: Travis CI 系列：自动化部署博客
date: 2017-09-18 10:11:19
author:
  name: Stephen
  link: https://blog.stephencode.com
tags:
- CI
---

先引出今天的主角：Travis CI （撒花 ~ 撒花 ~）

> Travis CI 是在软件开发领域中的一个在线的，分布式的持续集成服务，用来构建及测试在GitHub托管的代码。

![travis ci](https://cdn.stephencode.com/article/travis/travis.jpg)

最近变得更懒了，觉得每次本地提交代码到 GitHub 上后还要去服务器上拉取文件，完成所谓的部署工作有点麻烦。所以想要让这样的一个过程自动化，那么也就有了今天的这番折腾了~

其实我的部署之路也是从石器时代逐步到蒸汽时代再到电气时代的。。。

最开始，通过 FTP 传文件的方式，在每一次对本地文件进行修改并在本地环境测试通过后，通过 FTP 传输到远程服务器，然后在线上看看有没有问题（这里可能有人会问，为什么不中间搞个测试服务器？我一个个人博客网站搞那么多步骤不是得搞死自己么，好吧，其实是我懒。。。），这里有一个很要命的问题，有时候可能一下子改了很多文件，然后等到测试完成要上传的时候。。。嗯，忘记都改了哪些文件了，那怎么办啊，还是有办法的，把整个项目都上传一遍（那时候还没用上 Git 呢，别跟我扯 Git 这一套，我不听我不听我不听）。

之后，将自己的博客放上了“基友交流网” —— GitHub，然后用上了偶像 Linus 又一具有世界级影响力的版本控制软件，从此再也不用记住自己改了哪些文件了。测试完 push 一下，登录远程服务器 pull 一下，就搞定了。

年纪大起来了，不想每次 push 上去后还要登录自己的服务器 pull 一下，懒病再次发挥了至关重要的作用，它迫使我接入 Travis CI 持续集成。。。

然后，嗯，上了 Travis 这条“贼船” ~

对于 GitHub 的集成 Travis 做得很好，与 Jenkis 不同，Travis 不需要自己在服务器部署服务，并且是高度集成 GitHub 的，所以对于开源项目还是非常友好的。

开始这次磕磕绊绊的集成之旅~

## 注册配置 Travis

万事开头难，不，每次注册都是最容易的，更何况还是使用 GitHub 第三方授权登录呢~

注册成功，登录，然后添加自己的 GitHub 上的 repo

![add repo](https://cdn.stephencode.com/article/travis/add-repo.jpg)

选择其中一个或多个你需要集成的项目，开启 build，也就是点击叉叉变成勾勾的过程。

假设现在已经对某个项目开启了 Travis，那么先去看看 Settings 里默认开启的那几项，根据自己实际需求进行设置，没什么特殊需求默认的设置就可以了。

接下来的步骤很清楚，官方也有配图说明：

![build step](https://cdn.stephencode.com/article/travis/buil-step.png)

### 添加 .travis.yml

说白了接下来的事情都是如何去写这个配置文件，因为 Travis 全是根据这个配置文件去执行相应动作的。

根据你的语言不同，配置也会有较大差异，因为我的博客使用 PHP 的流行框架 Laravel 写的，所以这里也拿它作为例子，官方给出的最精简的 PHP 配置文件是：

```YML
language: php

php:
  - 7.1.9
  - nightly
```

### 触发构建

接下来如上面所说的第三步，将这个 `.travis.yml` 文件提交到 GitHub，那么 Travis 就会自动触发构建任务。

我就知道第一次不会这么简单的，失败了。。。

报错原因是执行 `phpunit` 时提示：

```
PHP Warning:  require(/home/travis/build/stephencode/super-admin/bootstrap/../vendor/autoload.php): failed to open stream: No such file or directory in /home/travis/build/stephencode/super-admin/bootstrap/autoload.php on line 17
```

一看是自己项目的 composer 依赖包的 `autoload.php` 文件没找到，那应该是没有执行 `composer up` 之类的操作，结合网上找的资料，比较好的解决方式是在 `install` 层添加一行：

```
install:
  - composer install --prefer-dist --optimize-autoloader --quiet
```

这样就不会报上面这个错了，然后会报接下来的一个错。。。

```
1) Tests\Feature\RouteTest::testBasicTest
RuntimeException: No application encryption key has been specified.
```

其实这个是我在 Laravel 里面的 `phpunit.xml` 没有配置好的缘故。将 `<env name="APP_KEY" value="base64:xxxxxx="/>` 补上就好，在 `<php></php>` 标签里，这个 key 你自己去生成。

在经过五六次 build failed 之后，总算天不负我了。

![build failed](https://cdn.stephencode.com/article/travis/build-failed.png)

## 自动部署到远程服务器

现在已经可以自动构建了，那么接下来的一步就是部署到远程服务器。Travis 提供 `after_success` 来实现这步骤。

等等，我们要部署到远程服务器，那么势必需要让 Travis 登录到远程服务，那么登录密码怎么处理才能保证安全？这是首先要解决的问题，明文肯定是不行的。

### 加密登录密码

那看来先得解决这个问题，Travis Docs 里也帮我考虑到了这个避不开的问题的解决方案（[Encrypting Files](https://docs.travis-ci.com/user/encrypting-files/)）

我们一起来实践一下：

首先通过 Ruby 的 gem 安装 travis

```
gem install travis
```

哎，重试了几次发现敲完这段 shell 如同石沉大海一般，屁都不放一个。。。就算开了代理还是纹丝不动，没办法只能换镜像了。

```
$ gem sources -l

*** CURRENT SOURCES ***

https://rubygems.org/
```

查看一下当前的镜像，这货（rubygems）国内出奇的难以访问，网上一搜国内的镜像源，[Ruby China](http://gems.ruby-china.org/) 的应该很显眼吧~

```
$ gem update --system
$ gem sources --add https://gems.ruby-china.org/
```

然后再查看一下 gem 镜像，确保只有 Ruby China 的 gem 源。

好了，现在可以愉快的安装 travis 了

```
$ sudo gem install travis
```

接下来让我们先在命令行中登录 Travis

```
$ travis login

We need your GitHub login to identify you.
This information will not be sent to Travis CI, only to api.github.com.
The password will not be displayed.

Try running with --github-token or --auto if you don't want to enter your password anyway.

Username: xxx@xxx.xxx
Password for xxx@xxx.xxx: ***
Successfully logged in as demo!
```

会要求你输入 GitHub 的账号密码，这个是走 GitHub 的服务，所以不用担心密码泄露。

将目录切换到项目根目录下，也就是 `.travis.yml` 目录下。因为我们需要让 travis 远程登录自己的服务器，所以需要将本地保存着的 SSH 私钥进行加密处理（默认你也是通过 SSH 免密登录的模式哦，不清楚可以参考我这一篇 [《SSH 系列：免密登录远程服务器》](https://blog.stephencode.com/p/ssh_login_no_pwd.html)）。

```
$ travis encrypt-file ~/.ssh/id_rsa --add

Detected repository as xxx/xxx, is this correct? |yes| yes
encrypting ~/.ssh/id_rsa for xxx/xxx
storing result as id_rsa.enc
storing secure env variables for decryption

Make sure to add id_rsa.enc to the git repository.
Make sure not to add ~/.ssh/id_rsa to the git repository.
Commit all changes to your .travis.yml.
```

这个时候去看一下当前目录下的 `.travis.yml`，会多出几行

```
before_install:
  - openssl aes-256-cbc -K $encrypted_d89376f3278d_key -iv $encrypted_d89376f3278d_iv
  -in id_rsa.enc -out ~\/.ssh/id_rsa -d
```

为保证权限正常，多加一行设置权限的 shell

```
before_install:
  - openssl aes-256-cbc -K $encrypted_d89376f3278d_key -iv $encrypted_d89376f3278d_iv
    -in id_rsa.enc -out ~/.ssh/id_rsa -d
  - chmod 600 ~/.ssh/id_rsa
```

还有一点可能会用上，因为 travis 第一次登录远程服务器会出现 SSH 主机验证，这边会有一个主机信任问题。官方给出的方案是添加 addons 配置：

```
addons:
  ssh_known_hosts: your-ip
```

到这里，travis 就能够免密登录自己的远程服务器啦~

## 自动部署

既然已经可以免密登录服务器了，那么写一个部署脚本，在登录时执行该脚本就可以了，一切就是这么顺其自然就好~

### 写部署脚本

我写 Shell 脚本的水平很有限，这边也就给出一个最精简的 Demo 可以参考一下：

```bash
#!/bin/bash
cd /path/to/your-project
git pull origin master
echo 'travis build done!'
```

### 执行部署脚本

在 `.travis.yml` 配置文件中写下这么两行：

```
after_success:
  - ssh your-user@your-ip "./your-shell-script"
```

记得将其中的 `your-user`、`your-ip`、`your-shell-script` 都替换成自己的哦！

## 高大上标志

辛苦奋斗了一天，总是希望别人看到自己的劳动成果的，除了写这篇文章意外还能做点什么呢？那自然是给自己的这个项目在 GitHub 上的 README.md 中显示一个高大上的 `build:passing` 标志，就像这样：

![build tag](https://cdn.stephencode.com/article/travis/build-tag.png)

## 总结

这次过程中基本都是从不会到会的一个学习过程，从中了解到不少新东西，也发现一些自己的短板，比如写 shell 脚本。。。

最后，贴出我自己的 `.travis.yml`，里面有关涉及个人隐私的部分我会注释并说明：

```yml
language: php

php:
  - 7.1.9
  - nightly

env:
  - APP_DEBUG=false

before_install:
  - openssl aes-256-cbc -K $encrypted_d89376f3278d_key -iv $encrypted_d89376f3278d_iv
    -in id_rsa.enc -out ~/.ssh/id_rsa -d
  - chmod 600 ~/.ssh/id_rsa

install:
  - composer install --prefer-dist --optimize-autoloader --quiet

notifications:
  email:
    recipients:
    - stephenfxl@gmail.com
    on_success: always
    on_failure: always

script:
  - phpunit -c phpunit.xml --coverage-text

after_success:
  - ssh xxx@xxxx.xxxx.xxxx.xxxx "./travis_build" # 请替换成自己的登录IP和登录用户

addons:
  ssh_known_hosts: xxxx.xxxx.xxxx.xxxx # 请替换成自己的服务器IP

```

本文参考链接：

- [使用Travis进行持续集成](https://www.liaoxuefeng.com/article/0014631488240837e3633d3d180476cb684ba7c10fda6f6000)
- [Jekyll + Travis CI 自动化部署博客](https://mritd.me/2017/02/25/jekyll-blog-+-travis-ci-auto-deploy/)