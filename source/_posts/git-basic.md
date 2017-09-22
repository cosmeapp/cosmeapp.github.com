title: git基本操作
date: 2017-09-21 00:45:09
author:
  name: Limitsy
  link:
tags:
- git
---


本文最早由Limitsy编写，[悔惜晟](https://huixisheng.github.io)做了补充。

## 克隆 ##

```
$ git clone git://host.xz[:port]/path/to/repo.git
```

完整命令，[具体参数可以参考](https://git-scm.com/docs/git-clone), 或者`git clone --help`
```
git clone [--template=<template_directory>]
      [-l] [-s] [--no-hardlinks] [-q] [-n] [--bare] [--mirror]
      [-o <name>] [-b <name>] [-u <upload-pack>] [--reference <repository>]
      [--dissociate] [--separate-git-dir <git dir>]
      [--depth <depth>] [--[no-]single-branch] [--no-tags]
      [--recurse-submodules] [--[no-]shallow-submodules]
      [--jobs <n>] [--] <repository> [<directory>]
```

## 更新操作
1. git add .
2. git commit
3. git pull origin $(current_branch)'
4. git push origin $(current_branch)'（没冲突 OR 先解决冲突 再重复上述操作）

## 合并分支
1. 更新操作完成对分支的修改
2. git pull origin master(合并主分支 防止有冲突)
3. git push origin $(current_branch)'（没冲突 OR 先解决冲突 再重复上述操作）
4. 再在线上完成分支合并

## 新建分支
* git checkout -b {branch} (新建分支)
* git checkout {branch} (切换到现有分支)
* git checkout --track origin/{branch} (切换到远程分支并同步到本地，之前需要操作 git pull)

## Tag操作
* git tag #查看标签列表
* git tag v1.2.1 #添加标签v.1.2.1
* git tag -a v1.2.1 b477cbc #为之前提交的commit添加标签
* git show v1.2.1  #查看标签 v.1.2.1 的信息
* git push --tags # 提交时带上标签信息
* git tag -d 2.5.1001 #删除本地标签
* git push origin :refs/tags/1.2.0 #删除远程标签


## coding 服务切换 ##

>Coding.net Tips : [GIT access is disabled on coding.net domain, please use git.coding.net instead. See detail: https://coding.net/u/coding/pp/54510]
fatal: Could not read from remote repository.

    git remote set-url origin git://host.xz[:port]/path/to/repo.git


## 使用rebase 保持分支书整洁 ##

利用rebase修改历史提交记录，可以看[这里](https://huixisheng.github.io/git-rebase/)

### 方法1 ###

    git pull --rebase origin master


### 方法2  ###

    git checkout dev
    git reabse master
    git checkout master
    git merge dev

- [Git速成班: git rebase](http://www.html-js.com/article/Week-end-column-Git-crash-course-git-rebase)


## submodule 替换为 subtree ##

    git rm —cached app/Library
    rm -rf app/Library
    vi .git/config  删除submodule 配置
    rm .gitmodules

    //添加subtree

    git remote add Library git://host.xz[:port]/path/to/repo.git
    git subtree add —prefix=app/Library Library dev
    git checkout -b dev
    git pull origin dev   合并主分支代码


##  项目一键初始化 ##

    git clone git://host.xz[:port]/path/to/repo.git
    composer update
    mkdir storage
    chmod -R 777 storage/
    mkdir -p bootstrap/cache/
    chmod -R 777 bootstrap/cache/
    php artisan route:cache
    php artisan config:cache

**ps: todo 修改为一键脚本**

## 碰到的问题 ##

- [coding.net Permission denied (publickey)](https://coding.net/u/rainy/pp/30783)
- [如何创建 ssh key](https://help.github.com/articles/generating-ssh-keys/)
- [git命令简单介绍](http://huixisheng.github.io/git/)
