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
$ hexo new weekly  weekly-2017-05-06 // 创建周刊模板
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


| replace(r/\d{4}-/g, '')


### 其他插件 ###

```
    "hexo-all-minifier": "^0.2.6",
    "hexo-generator-feed": "^1.2.2",
    "hexo-generator-seo-friendly-sitemap": "0.0.21",
    "hexo-wordcount": "^3.0.2",
```

## 自定义scaffold  ##

最初是想实现如下title的日期是自动生成的。但`{{ date }}`会含有时间，直觉`filter`可以处理。然而没并软，且有报错。

```
---
title: 美妆心得技术周刊2017-05-06
tags:
  - weekly
date: 2017-05-06 22:16:48
---
```

于是开始啃代码，从`hexo-cli`开始

根据`package.json` 的 `"main": "lib/hexo",` 和`bin/hexo`。使用的核心模块是`Hexo`，初步猜测当前项目的`node_moduels`存在`hexo`，就加载该目录下的模块，否则加载全局的。这个跟`webpack`一样。

根据提示的报错

```
Template render error: (unknown path) [Line 1, Column 22]
  expected symbol, got string
    ...
    at /Users/huixisheng/cosmeapp.github.com/node_modules/hexo/lib/extend/tag.js:66:9
   ...
    at Tag.render (/Users/huixisheng/cosmeapp.github.com/node_modules/hexo/lib/extend/tag.js:64:10)
    at /Users/huixisheng/cosmeapp.github.com/node_modules/hexo/lib/hexo/post.js:111:16
```
定位到`post.js`。

```
Post.prototype.create = function(data, replace, callback) {
  // console.log(data);
  // return;
```

执行了 `_renderScaffold`

`tag.render(yfmSplit.data, frontMatter)`。

```
var placeholder = '\uFFFC';
var rPlaceholder = /(?:<|&lt;)\!--\uFFFC(\d+)--(?:>|&gt;)/g;

Tag.prototype.render = function(str, options, callback) {
```

```
  return new Promise(function(resolve, reject) {
    str = str.replace(/<pre><code.*>[\s\S]*?<\/code><\/pre>/gm, escapeContent);
    env.renderString(str, options, function(err, result) {
```

最后发现是[`nunjucks`](http://mozilla.github.io/nunjucks/cn/templating.html)模块引擎解析的。那么这样问题就好办了。于是根据相关语法做配置即可。然后并没有提供`filter date`的方法，需要添加自定义`filter`。类试的库有[`nunjucks-date`](https://www.google.com.sg/search?biw=1242&bih=703&q=nunjucks+date&oq=nunjucks+date&gs_l=psy-ab.3...5873433.5873948.0.5874188.5.5.0.0.0.0.0.0..0.0....0...1.1.64.psy-ab..5.0.0.lMlZdOVppgE)。添加库需要涉及到`hexo`源码的修改，是否可以从原有的`filter`做文章。于是找到`replace`

```
---
title: 美妆心得技术周刊{{ date | replace(r/\s.*/g, "")  }}
```
关于`Hexo`源码的阅读还需更深入。


### 参考文章 ###
- http://johnwonder.github.io/2016/09/29/hexo-scaffold/
- http://mozilla.github.io/nunjucks/cn/templating.html
- https://hexo.io/zh-cn/docs/writing.html


### 2017-09-11 ###
- 添加自定义scaffold
