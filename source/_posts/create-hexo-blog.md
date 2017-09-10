---
title: 开篇如何通过hexo创建blog
date: 2017-09-08 23:58:19
author:
  name: 悔惜晟
  link: http://huixisheng.github.io
tags:
- hexo
---

此为团队博客开篇，让技术部的知识沉淀下来，这是一个好的开始。算是技术部的一个坑，让大家都参与进来。本文介绍通过hexo如何搭建技术博客。

为何选择hexo，支持`markdown`，最主要是先有个平台有内容产出，有内容了什么都好说，选择其他框架、自定义主题或者自行开发一个适合自己的博客系统。

## 安装 ##

```bash
$ npm install -g hexo-cli
```
**注意：**安装之前先安装nodejs ，下载地址 https://nodejs.org/en/

## 初始化 ##

```bash
$ hexo init
$ git init // 添加仓库
$ git remote add origin git@github.com:cosmeapp/cosmeapp.github.com.git
$ git clone https://github.com/iissnan/hexo-theme-next themes/next // 安装主题，记得切换到hexo站点目录下
```

### 创建文章 ###

```bash
$ hexo new post create-hexo-blog
```

### 本地预览 ###

```bash
$ hexo server -g
```

### 构建发布 ###

```bash
$ hexo deploy -g
```

## 插件 ##

### hexo-deployer-git ###

>Git deployer plugin for Hexo.

```bash
$ npm install hexo-deployer-git --save-dev
```

配置`_config.yml`

```
deploy:
  type: git
  repo: git@github.com:cosmeapp/cosmeapp.github.com.git
  branch: master
```

### 配置主题 ###

```bash
$ git clone https://github.com/iissnan/hexo-theme-next themes/next
```

配置`_config.yml`

```
theme: next
```

其他具体的配置参考[http://theme-next.iissnan.com/](http://theme-next.iissnan.com/)

### [Gitalk](https://github.com/gitalk/gitalk) ###
>Gitalk 是一个基于 Github Issue 和 Preact 开发的评论插件

因公司业务调整多说项目于2017年6月1日正式关停服务。于是考虑使用`Gitalk`代替。

`NexT`主题集成`Gittalk`，这个可以发个pr

```
+++ b/layout/_partials/comments.swig
@@ -32,4 +32,5 @@
       <div id="vcomments"></div>
     {% endif %}
   </div>
+  <div id="gitalk-container"></div>
 {% endif %}

+++ b/layout/_third-party/comments/index.swig
 {% include 'valine.swig' %}
+{% include 'gittalk.swig' %}
```

```
{% if page.comments %}
<link rel="stylesheet" href="/gitalk/gitalk.css">
<script src="/gitalk/gitalk.min.js"></script>

<script>
var gitalk = new Gitalk({
  clientID: 'cb9d990636e84547cadb',
  clientSecret: '78036da2ca2985c3df477c76c407a120ae664368',
  repo: 'cosmeapp.github.com',
  owner: 'cosmeapp',
  id: '',
  title: '{{ page.title }}',
  body: '{{ page.permalink }}\n\n{{ page.title }}',
  labels: ['Gitalk'{% if page.tags and page.tags.length %}{% for tag in page.tags %},'{{ tag.name }}'{% endfor %}{% endif %}],
  admin: ['huixisheng'],
  distractionFreeMode: true
});

gitalk.render('gitalk-container');
</script>
{% endif %}
```

不想设置`id`成为`labels`。于是下载`Gitalk`源码修改，但构建的时候报错

```
ERROR in ./src/index.js
Module parse failed: ~/gitalk/src/index.js Unexpected token (23:18)
You may need an appropriate loader to handle this file type.
|     }
|
|     return render(<GitalkComponent options={this.options}/>, node)
|   }
| }
 @ multi (webpack)-dev-server/client?http://localhost:8000 webpack/hot/dev-server ./index.js
```

很奇怪，看了相关`webpack`配置并没有什么问题，提了[issue](https://github.com/gitalk/gitalk/issues/23)。当然提issue前努力尝试去解决问题，开源的项目不可能连构建都不行。

- 尝试升级相关的dependencies，推荐`npm-check`
- 删除`node_moduels`,尝试 `npm install`和 `yarn install`
- 问题初步怀疑是`jsx`不解析，但是`babel-loader`配置没问题
- google `You may need an appropriate loader to handle this file type.` 尝试添加了`webpack`、`babel-loader`、`jsx`等关键词。折腾到凌晨2点多，无果，媳妇喊睡觉
- 第二天起来，开始尝试写最简单的[demo](https://github.com/huixisheng/lab/tree/gh-pages/React)，demo跑起来没有问题，对比demo的配置，配置无差。后面发现`Gitalk`的项目是`clone`在`node_modules`目录下，换了目录。项目终于可以跑起来了 @todo 深入为何在`node_modules`目录下不行？初步设想，应该是`nodejs`查找依赖，通过配置`webpack`可以解决

问题的出现不是偶然，任何问题的出现都是有原因，有可能是一个字母，不同的环境。当出现不可思议的问题时候，需要静下心，慢慢体会碰到问题的苦恼，最终享受问题解决的快乐。

移除`id`添加为`labels`
```
+++ b/src/gitalk.jsx
@@ -184,7 +184,8 @@ class GitalkComponent extends Component {
       params: {
         client_id: clientID,
         client_secret: clientSecret,
-        labels: labels.concat(id).join(',')
+        labels: labels.join(',')
       }
     }).then(res => {
     return axiosGithub.post(`/repos/${owner}/${repo}/issues`, {
       title,
-      labels: labels.concat(id),
+      labels: labels,
```

相关的扩展阅读[如何评价「多说」即将关闭？有什么替代方案？](https://www.zhihu.com/question/57426274)


### 其他插件 ###

```
    "hexo-all-minifier": "^0.2.6",
    "hexo-generator-feed": "^1.2.2",
    "hexo-generator-seo-friendly-sitemap": "0.0.21",
    "hexo-wordcount": "^3.0.2",
```