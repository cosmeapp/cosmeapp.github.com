---
title: 撸一个插件来解析视频地址
date: 2017-10-28 23:00:19
author:
  name: dabennn
tags:
- chrome
---
最近暇余时间帮朋友写了一个解析视频地址用的chrome插件，对chrome插件开发又有了一些新的认识，记录并分享之。



## 故事开头

事情是这样的，有一位朋友，因为工作需要，不时的要在兄弟单位的网站上下载文章里的视频。网页本身没有下载渠道，所以就会丢给我一个地址，让我帮忙下载。

其实下载这些视频本身并不复杂，但是本着能懒则懒的精神，我还是决定用代码来解放双手，实现一劳永逸的伟大目标。

考虑了一下易用性和开发成本之后，我决定开发一个chrome插件。不为什么，简单好用，还能跑在其他webkit内核的浏览器上，简直完美。



## 需求分析

故事先告一段落，言归正传，还是先来理一理思路。

万事开头……难不难我不知道，不过不慌，先来分析一下。

我需要的是一个傻瓜式的插件，点一下鼠标就能显示出来视频的下载地址，还要有一些基本信息，好让用的人知道自己会下载到什么东西。另外，最好对目标网站做一个限制，只能在特定的网站使用。

需求有了，基本的开发思路也就出来了。首先我需要一个右键菜单来进行交互，其次要拦截下请求视频的接口，方便获取视频相关的信息，然后就是展示环节，做一个简单的界面用于展示，动态插入到DOM中，完成展示。

OK，Let's do it～



## 开发过程

Chrome插件开发就不介绍了，详请参见：[官方文档](https://developer.chrome.com/extensions)

这里用到了background_script和content_script相互配合，还有一些插件内的通信、webRequest API等。background_script负责创建右键菜单、拦截请求，content_script负责发送请求和操作DOM生成展示页面。

先在`background.js`里初始化一个右键菜单：

```javascript
chrome.contextMenus.create({
  title: '', // 右键菜单名
  documentUrlPatterns : ['http://*.*.com/*'] // 配置在哪些网站可以显示这个右键菜单，可以使用通配符
}, function (err) {
  console.log(err);
});
```

利用webRequest  API拦截请求，并给右键菜单添加一个监听，通过chrome的拓展内通信发送消息给`content_script.js`，传递拦截到的请求信息：

```javascript
chrome.webRequest.onBeforeRequest.addListener(function(req) {
  chrome.contextMenus.onClicked.addListener(function (info, tab) {
    chrome.tabs.sendMessage(tab.id, req.url);
  });
},
  urls: ['http://*.*.com/*'] // 需要过滤的地址,同样可以使用通配符
});
```

在`content_script.js`里接受消息：

```javascript
chrome.runtime.onMessage.addListener(function(msg, sender, sendResponse) {
  // code....
};
```

然后就是请求接口获取视频信息了，可以用XHR，也可以用jquery等等，我用的jquery。

请求时发现，获取到的地址并不是真的下载地址，我就上硕鼠解析了一下这个地址，成功获得真实下载地址。But，总不能每次拿到地址还要手动去硕鼠解析一下吧，辣岂不是太麻烦了。

于是咨询了一下硕鼠官方有没有开放相关的API，给的回复是“没有开放API，只提供企业服务”。好吧，没有开放就没有开放吧，办法总是有的不是。

分析了一下硕鼠的地址，发现解析的接口用的是get请求，有两个关键的参数`kw` 和 `format`。`kw`的值是要解析的地址，`format`是解析的画质，有原画、超清、高清和普请四种，值分别是real、super、high和空。

OK，万事俱备，伪造一个请求，去硕鼠获取真实的地址。

```javascript
$.get('http://www.flvcd.com/parse.php', {
  kw: url,
  flag: 'one',
  format: 'real',
  lang: 'zh_CN'
}, function(res) {
  // code...
});
```

返回的是整个网页，不要紧，用正则把我们需要的信息匹配出来就好（正则大法好！！！）。

获取到数据，然后就是展示啦，最后的效果就像这样，简约大气，没毛病！

![](https://image.tracup.com/snapshot_1509196144722.png)



## 尾声

经过朋友的亲身检验，插件成功跑在了360浏览器上，工作正常。

完结，撒花！



## 参考链接

Chrome插件官方文档：https://developer.chrome.com/extensions

非官方中文翻译：https://crxdoc-zh.appspot.com/extensions/