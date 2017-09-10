---
title: 周报资源整理
date: 2017-06-12 23:58:19
tags:
- weekly
---


根据周报中技术部推荐的资源进行整理。


## 书 ##

《迟到的间隔年》
>在年轻的时候，选择一次跨国长途旅行，让自己在旅途中观看世界，认识自我，明白自己到底需要什么。这一年就叫做间隔年。”体验着作者那一幕幕挫折和艰险，问自己是否能做到，比起懵懵懂懂的笃定，这份迷茫完全值得......

《微习惯》
>如果大家准备好实现一个长期的目标，比如跑步、减肥、或者英语口语学习，或者别的，这本书提供了一个非常好的针对懒惰的大脑潜意识的对抗策略，这本书相见恨晚啊,一定要看...


日本作家：斋藤孝，《学会学习》
>这里面列举了很多科学有效的学习方法

## 工具 ##

- MAC触摸板拓展http://weibo.com/6156641637/F5QKWgqJZ?type=comment
- 1password2.加密解密相关知识 http://www.jianshu.com/p/86f9a1ef3f24

iterm2 配置优化
配色优化
常用命令
- 主题及配色
- https://segmentfault.com/q/1010000006793078?_ea=1131451
- 分屏无边框
  - https://segmentfault.com/q/1010000006793078?_ea=1131451
- 常用快捷键
  - https://cnbin.github.io/blog/2015/06/20/iterm2-kuai-jie-jian-da-quan/
  - ctrl+shift+enter  当前屏最大化
  - ctrl+shift+d 垂直分屏
  - ctrl+d 水平分屏
  - command + option + 方向键盘，切换窗口
screen 命令
支持退出当前命令行窗口或退出整个terminal时，程序扔保持后台运行
网上常跟另一个命令 tmux比较 (功能更多更强，未用过，我喜欢简单的)
我常用到的screen命令如下，第1，2，4条最常用, -S; -r; ctrl+a+d.

```
- 新建一个session会话
  - screen -S socketname
- 回到上一级会话 (detached)
  - ctrl+a+d
- 远程 detached (用其他终端退出screen session会话窗口，退出非关闭，扔保持后台运行)
  - screen -d 名称
- 从新恢复到screen窗口
  - screen -r 名称
  - 对于已经Attached Session则不能直接screen -r，需要先screen -d，然后才能screen -r
- 列出screen session列表
  - screen -ls
- screen session中新建窗口
  - ctrl+ a + c
- 显示当前session的所有窗口
  - ctrl + a +w
- 在两个最近使用的 window 间切换
  - ctrl+a ctrl+a
- 切换到第 0..9 个 window
  - ctrl+a 0..9
SpaceVim
SpaceVim 是一个社区驱动的模块化 vim/neovim 配置集合。
作者旨在推广Vim，降低使用门槛。
反对的声音 如何评价Vim配置文件SpaceVim?
其他： 用 Vim 被人说装逼，怎么办？
```

### 发现好产品推荐 ###
- https://www.producthunt.com/
- http://next.36kr.com/posts
- http://mindstore.io/
- http://today.itjuzi.com/
- [你的手机上有什么很有意思的 App？](https://www.zhihu.com/question/31476726)

### 翻墙软件推荐 ###
- 鱼摆摆 9元/月 只有mac客户端。很稳定，速度也快，不限流量
- 吾皇SS 有各种套餐，价格便宜，可以每天无限申请试用。全平台支持。IOS的对应App, Windy
- 浪潮 IOS应用，可以每天签到领取流量，点击一键连接可以翻墙
- 神灯 Lantern 现在已经收费，免费的有流量限制。免费个人感觉不好用

### 图片处理 ###
- 长图拼接——想要多长的图都可以，缺点：不能横向拼图，半免费
- 推荐app WorkFlow https://sspai.com/post/27733 虽然我没有发现亮点 但是也许在你们手机中发光
处理图片app  prisma 效果很强大 觉得胜于一些付费的图片处理软件

### 综合资源 ###

- [Awesome Mac](https://github.com/jaywcjlove/awesome-mac/blob/master/README-zh.md)   这个仓库主要是收集非常好用的Mac应用程序、软件以及工具，主要面向开发者和设计师。有这个想法是因为我最近发了一篇较为火爆的涨粉儿微信公众号文章《工具武装的前端开发工程师》，于是建了这么一个仓库，持续更新作为补充，搜集更多好用的软件工具。请Star、Pull Request或者使劲搓它 issues 给我推荐优秀好用的Mac应用，很显然我是一个资深Mac用户，我需要它们帮助我快乐、高效的工作，同时也分享给你。
- [总有你要的编程书单（GitHub）](https://juejin.im/entry/5920f4f0a0bb9f005f4d9535) 可以收藏以后当做字典查询用。

## 生活娱乐 ##
### 电影 ###

- 苏有朋，嫌疑人X的献身
- 趁着新电影《嫌疑人X的献身》 推荐可以看看同名小说或者下载日本08年那部同名电影 剧情反转比较合乎情理
- 楚门的世界@1998年
- 电影《寿司之神》-小野二郎-http://www.dy2018.com/html/gndy/dyzz/20120718/38699.html

推荐一部反映人性的日本电影《飼育の部屋 》，故事大意是：一个男的囚禁了一个女的，并告诉她将永远与他生活下去，一开始这个女的处在各种反抗曾多次试图逃跑，男主角对女主角非常照顾，并对他讲述自己过去的经历，渐渐的这个女的慢慢原谅并接纳了这个男的，最后这个男的把这个女的给放了，男主角自己自首了。后来看了下影评说这种被爱者与加害者之间的依赖与崇拜的感情称之为“斯德哥尔摩综合症”，影片的画面与男女主人公的情感拍的比较细腻，把人性那种自私与关爱的双重性表现的很到位，日本的文艺片总是能在平淡的叙述中把人性赤裸地展现出来...



## 互联网 ##

- [周鸿祎：批评你的人，都是你的贵人](http://www.yixieshi.com/77541.html)
- [留学四年的她被一个习惯毁了前程](http://www.jianshu.com/p/29bcff69064b)
- 经期管理App美柚／大姨吗对比分析：http://www.yixieshi.com/26418.html
- 互联网大佬的人生建议：http://www.yixieshi.com/71658.html
- 15年图灵访谈——阮一峰（http://www.ruanyifeng.com/blog/2015/02/turing-interview.html）（在国内，）如果你想不撒谎、不干坏事、并且被公正地对待，那么可能你只能去编程了。原来文科出身呀~
- 早起，你们都干什么？：http://www.jianshu.com/p/8f071c610534
- 一篇blog-https://medium.com/the-mission/4-bold-decisions-that-will-stop-you-from-being-unhappy-c833c4f44ff2#.4zffbzpz7  ps:自带梯子
- 美国的互联网工具、在线教育和智能硬件市场有哪些独角兽？     http://36kr.com/p/5078061.html
- 10年后，重新设计的微软Skype,变得像Snapchat 和 Facebook     http://36kr.com/p/5078110.html

## 开发相关 ##

## 设计 ##
- [2017年即将流行的9大UX设计趋势](http://www.uisdc.com/2017-ux-design-trends)

### Vue ###
- [如何写一手漂亮的 Vue](http://jeffjade.com/2017/03/11/120-how-to-write-vue-better/)
- [大神面对面：Vue.js 作者尤雨溪专访](https://zhuanlan.zhihu.com/p/27205354)
- [常见css布局方式总结](https://mp.weixin.qq.com/s?__biz=MjM5MzMyNzg0MA==&mid=2650402966&idx=1&sn=479c47c0d0de94a8d9ce83e6535a6428)

### http ###
- [一些安全相关的Http响应头](https://imququ.com/post/web-security-and-response-header.html#toc-5)

### 测试 ###
- [appium连接iOS可能的解决办法](http://www.jianshu.com/p/05943804c25e)

### JavaScript ###
- [JavaScript如何遍历Object](https://huixisheng.github.io/object-loop/)

### 安卓 ###
- Android O发布 http://news.91.com/android/s58d1bc8010d3.html
- Android开发中遇到的坑 https://www.zhihu.com/question/27818921
- [一文解决 Android View 滑动冲突](https://juejin.im/entry/5928bfa92f301e0057d4f414)
- [Google 官方推出应用开发架构指南](https://juejin.im/entry/5922637b128fe1005c2ce6be)



## 其他 ##
- [三十秒的小习惯，一辈子的大影响](https://juejin.im/post/5933ffd6ac502e0068a3427a)
- 要想好好生活，我们需要一场和自我的断舍离：了解自己的真实欲望，不盲目浪费自己的时间和精力；明晰自己的需求，不买多余的东西；懂得节制，将精力留给自己珍视的东西。
http://www.jianshu.com/p/e0b63a98a7fc
- 需求了解要做什么：https://mp.weixin.qq.com/s?__biz=MjM5ODY4ODIxOA==&mid=201952103&idx=1&sn=610a0021807808a34d46edfa1cda40b1&mpshare=1&scene=1&srcid=060200swWvNGr5BZ7TlABFZj&key=48d1218a6e2970b0aa1d0b74aaa3757e00f7f9d8c71bf52f9f8ac81708e80b0d841651b5598c3d3a20749179877849824cc0a3a47c7990c46a48ed18a83b2ffe1a7b68566aed7ee4492b63206e539bc2&ascene=0&uin=MTk3ODA1MDIwMQ%3D%3D&devicetype=iMac+MacBookPro11%2C1+OSX+OSX+10.11.5+build(15F34)&version=12020610&nettype=WIFI&fontScale=100&pass_ticket=iUIezIVUwLB39vKkS8pFwoWKy%2B8QRO9yOawuTuF5klqq4%2FYp0uD7IhxLsvvO0QV0


