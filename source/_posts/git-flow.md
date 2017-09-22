title: Git flow 分支规范管理流程
date: 2017-09-21 00:45:09
author:
  name: 漠天
  link:
tags:
- git
---

本文主要通过git flow管理分支。

## git flow 模型


![image](http://static.cosmeapp.com/FqoiVHHk3A5XeVNnJrj3VuMybjSW?imageView2/2/w/611/h/815)

>图片来自[nvie的博文](http://nvie.com/posts/a-successful-git-branching-model/)


## 安装

    brew install git-flow

## git flow 辅助命令

git flow 命令使用帮助:

    usage: git flow <subcommand>

    Available subcommands are:
       init      Initialize a new git repo with support for the branching model.
       feature   Manage your feature branches.
       release   Manage your release branches.
       hotfix    Manage your hotfix branches.
       support   Manage your support branches.
       version   Shows version information.


命令Samples:

    1. 使用 git feature start meibox 开启meibox功能的开发.
    2. 使用 git feature publish meibox 将meibox分支提交到远端
    3. 使用 git feature finish meibox 完成meibox分支并将功能合并到dev分支

    功能开发完成并完成合并后删除远程分支
    git push origin --delete feature-test

## 分支规范

    master    ~ 主分支 (线上部署分支)
    dev       ~ 开发分支
    feature-  ~ 特性分支
    hotfix-   ~ 修正生产代码中的缺陷

为了更好的使用git flow管理, 已将相关项目的`git submodule` 替换为 `git subtree`

### 分支说明

`feature 分支:`

统一使用简化的git flow 流程来进行项目, 采用统一的分支前缀, 并在管理流程中增加代码Review环节:

	在一个新特性开始时 使用git flow feature start 开启新的特性分支(保持feauter-的相同前缀)
    功能完成开发后, 使用coding的[合并请求]功能发起代码评审.

![code-review](http://static.cosmeapp.com/FpdkhVkrh04GG8Ra_JJoTCRhyRZH?imageView2/2/w/400)

    功能模块代码, 至少经过两个人的code review 才允许被合并.(并且每次提交之前养成自己主动review的习惯)

    在相应feature-完成代码review之后, 作者需要对相关功能进行改进完善(评审人提出异议的情况, 作者确认问题是否真实存在)
    评审完毕后feature特性开发完成, 合并到dev分支, 并删除对应的feature-分支.


>注: 同一个feature在开发完成合并之后需要删除, 不允许重复使用, 新的功能特性新建新的功能分支开进行开发


`hotfix 分支:`

    主要用于修复线上bug, 从master分支切出hotfix分支, 修复问题后合并到master 和 dev
    Sample: git flow hotfix start bugtest, 重要bug修复后需要发起评审

    ➜  projectApi git:(dev) git flow hotfix start test
    Switched to a new branch 'hotfix-test'

    Summary of actions:
    - A new branch 'hotfix-test' was created, based on 'master'
    - You are now on branch 'hotfix-test'

    Follow-up actions:
    - Bump the version number now!
    - Start committing your hot fixes
    - When done, run:

         git flow hotfix finish 'test'

`dev 分支:`

    开发分支, 在feature完成 或 bugfix 之后相关代码被合并到dev.
    develop分支是保存当前最新开发成果的分支。通常这个分支上的代码也是可进行每日夜间发布的代码（Nightly build）。

`master 分支:`

    线上发布分支



线上测试环境:


    在保障dev 分支的代码质量后, 将dev作为线上测试环境的部署分支, 为了简化分支管理流程,在美妆git管理流程中, 暂时去掉了release分支的预发布管理.

>注: release 分支说明:
    release分支是为发布新的产品版本而设计的。在这个分支上的代码允许做小的缺陷修正、准备发布版本所需的各项说明信息
    （版本号、发布时间、编译时间等等）。通过在release分支上进行这些工作可以让develop分支空闲出来以接受新的feature分支上
    的代码提交，进入新的软件开发迭代周期。

## 测试环境代码发布规范 ##

目前主要针对projectApi，projectShop项目

描述： 线上部署的projectApi测试环境统一使用名为在test 的分支进行发布。


发布流程

一、  当A同学开发完一个特性feature-aaa后。(current branch: feature-a)

Sample：

    git checkout test
    git pull origin test
    git merge feature-a (合并远程feature修改使用 git pull origin feature-a)
    git push origin test

二、 当B同学开发完另一个特性feature-b后。同上。



注：此时test分支同时包含A同学B同学修改特性的代码。其他分支禁止合并test分支。

A同学提交到test测试通过后，将feature-a合并到dev, B同学测试通过后将特性feature-b合并到dev。

因为分支上同时包含多个同学的特性代码，严禁直接将test合并到其他分支（包含别人修改的未经测试的特性代码）。



解决问题：

目前线上测试环境部署在dev分支，A和B同时需要测试时，会临时将测试部署修改成A或者B对应的特性分支，这样线上测试环境只有单一特性，

无法满足多人测试。同时未经线上测试的feature合并到dev分支不安全。



缺点：

a. 常规冲突可通过合并解决。但A同学B同学在同一个功能模块上做不同实验性代码修改时会产生问题，比如同一逻辑的不同实现。

b. 因为此时线上测试环境包含多个特性修改，A开发完成，测试feature-a通过，将feature-a合并到dev，最终阶段性开发完成后，将dev合并到master。

此时可能feature-a已经合到dev => master， feature-b还处于测试阶段，那么由于a特性的线上测试受到了b特性的影响，测试环境与最终的部署线上存异，从而因不一致性导致未发现的问题产生。




## 参考

- [基于git的源代码管理模型——git flow](http://www.ituring.com.cn/article/56870)
- [用 Git Subtree 在多个 Git 项目间双向同步子项目，附简明使用手册](https://segmentfault.com/a/1190000003969060)
