title: Sublime Text操作规范即基本操作
date: 2017-09-26 20:57:09
author:
  name: Limitsy
  link:
tags:
- 工具
- SublimeText
---

本文对`Sublime Text`基本配置，常用插件，基本快捷键做的基本整理。

## 自定义配置 ##

在原配置中添加：

	"font_face": "source code pro", //字体设置
	"font_size": 15, //字体大小
	"translate_tabs_to_spaces": true, //转换tab为空格(必要)
	"trim_trailing_white_space_on_save": true //保存时候删除每行末尾空格(必要)

## 自定义快捷键 ##

	[
		{ "keys": ["super+shift+a"], "command": "reindent" },//格式化，super为command键
		{ "keys": ["super+shift+r"], "command": "goto_symbol_in_project" }//全局搜索类/方法
	]

## 插件 ##

* 使用Package Control组件安装
* 先在hosts中添加

	#sublime service
	50.116.34.243 sublime.wbond.net

### 安装Package Control组件 ###

* 按Ctrl+`调出console
* 粘贴以下代码到底部命令行并回车：
* sublime text 3:

	import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read())

* sublime text 2:

	import urllib2,os; pf='Package Control.sublime-package'; ipp = sublime.installed_packages_path(); os.makedirs( ipp ) if not os.path.exists(ipp) else None; urllib2.install_opener( urllib2.build_opener( urllib2.ProxyHandler( ))); open( os.path.join( ipp, pf), 'wb' ).write( urllib2.urlopen( 'http://sublime.wbond.net/' +pf.replace( ' ','%20' )).read()); print( 'Please restart Sublime Text to finish installation')

* 重启Sublime Text
* 如果在Perferences->package settings中看到package control这一项，则安装成功。

### 用Package Control安装插件的方法 ###

* 按下Ctrl+Shift+P调出命令面板
* 输入install 调出 Install Package 选项并回车，然后在列表中选中要安装的插件。

#### 必要插件 ####

* [SublimeLinter](https://github.com/titoBouzout/SideBarEnhancements/tree/st3)
* [Git](https://github.com/kemayo/sublime-text-git)
* [DocBlockr](https://github.com/spadgos/sublime-jsdocs)
* [Alignment](https://github.com/wbond/sublime_alignment)
* [Bracket​Highlight](https://github.com/facelessuser/BracketHighlighter)
* ConvertToUTF8
* [Emmet](http://emmet.io/)

## 基本快捷键(我会用到的) ##

### 打开/前往

快捷键  		 |   操作
------------ |-----------
**command + P**  | 前往文件(输入```:```则等同于```control + G```跳到行)
**command + control + P** | 前往项目
**command + R**  | 前往method
**command + shift + R**  | 前往全局method(也许需添加之前的配置)
command + shift + P | 命令提示
control + G  | 前往行
**command + K + B** | 开关侧栏
control +  ` | python控制台

### 编辑

快捷键  		 |   操作
------------ |-----------
**command + D**  | 选择词 (重复按下时多重选择相同的词进行多重编辑)
command + KK | 从光标处删除至行尾
**command + shift + D** | 复制(多)行
command + J  | 合并(多)行
command + KU | 改为大写
command + KL | 改为小写
**command + /**  | 注释
**command + option + /** |  块注释
command + Z  | 撤销
command + Y  | 恢复或重复
control + M  | 跳转至对应的括号
command + U  | 软撤销（可撤M销光标移动）
command + shift + U | 软重做（可重做光标移动）

### 分屏

快捷键  		 |   操作
------------|-----------
command + option + X | X屏
control + [1,2,3,4]  |  焦点移动至相应组
control + shift + [1,2,3,4] | 将当前文件移动至相应组
command + [1,2,3]  |  选择相应标签页