---
title: Fast Scrolling with RecyclerView翻译
author:
  name: 刘赛登
  link:
date: 2017-09-27 09:10:58
tags:
- Andriod
- 翻译
---


> 原文来源: https://android.jlelse.eu/fast-scrolling-with-recyclerview-2b89d4574688

这次翻译一篇来自于medium的文章，内容与recyclerView有关。

众所周知,RecyclerView对ListView有很大的优势, Recyclerview也逐步代替ListView来实现列表的效果。我十分想念一个功能——快速滚动，你可以拖动一个绘制的滑块并在列表中滚动。
在ListView中你可以这是做:

```
listView = (ListView) findViewById(R.id.listView);
listView.setFastScrollEnabled(true);
```
但是在RecyclerView中，没有一种简单的方式来拖动滑块实现下面的效果:

![dada](https://cdn-images-1.medium.com/max/1600/1*HliXJE2zpLAXWmXusOFSSA.gif)

所以我们会引用第三方库比如[Recycler Bubble](https://github.com/FutureMind/recycler-fast-scroll)或者[RecyclerView-FastScroll](https://github.com/timusus/RecyclerView-FastScroll)。

随着Support Library 26的到来，我们能够轻松地实现RecyclerView快速滚动。Let’s get to it!

![](https://cdn-images-1.medium.com/max/1600/1*fnt26zTwl3zkAIazlNGvZw.gif)

首先我们项目得引用Support Library 26,项目中的build.gradle如下所示:
```
dependencies {
    ....
    compile 'com.android.support:design:26.0.1'
    compile 'com.android.support:recyclerview-v7:26.0.1'
    ....
}
```

由于Support Library 26现已转移到Google的maven存储库，需要在我们项目级的build.gradle文件中添加**google()**

```
buildscript {

    repositories {
        google()
    }
    ....
}
```

这是我们界面的布局代码,如下:

#### content_main.xml
```
<?xml version="1.0" encoding="utf-8"?>
<android.support.constraint.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    app:layout_behavior="@string/appbar_scrolling_view_behavior"
    tools:context="com.shaishavgandhi.fastscrolling.MainActivity"
    tools:showIn="@layout/activity_main">


 <android.support.v7.widget.RecyclerView
    android:id="@+id/recyclerView"
    android:layout_width="match_parent"
    android:layout_height="wrap_content">

 </android.support.v7.widget.RecyclerView>

</android.support.constraint.ConstraintLayout>
```

我构建了一个recyclerView，其由美国各州以及其代码的mock数据填充，如下展示：

![](https://cdn-images-1.medium.com/max/1600/1*WwKn8Y9KQ-1EFAN324xwuw.gif)

现在让我们开始实现快速滚动,更新后的布局文件如下展示:
```
<?xml version="1.0" encoding="utf-8"?>
<android.support.constraint.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    app:layout_behavior="@string/appbar_scrolling_view_behavior"
    tools:context="com.shaishavgandhi.fastscrolling.MainActivity"
    tools:showIn="@layout/activity_main">


 <android.support.v7.widget.RecyclerView
    android:id="@+id/recyclerView"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    app:fastScrollEnabled="true"
    app:fastScrollHorizontalThumbDrawable="@drawable/thumb_drawable"
    app:fastScrollHorizontalTrackDrawable="@drawable/line_drawable"
    app:fastScrollVerticalThumbDrawable="@drawable/thumb_drawable"
    app:fastScrollVerticalTrackDrawable="@drawable/line_drawable">

 </android.support.v7.widget.RecyclerView>

</android.support.constraint.ConstraintLayout>
```

让我们浏览一下下面的属性：
- **fastScrollEnabled** boolean类型来启动快速滚动，如果设置为true值的话将要求我们提供一下四个属性
- **fastScrollHorizontalThumbDrawable** StateListDrawable类型将被用来绘制可以在横轴可滑动的的滑块
- **fastScrollHorizontalTrackDrawable** StateListDrawable类型将被用来绘制一条表示在横轴上的scrollbar的线条（轨道 译者注0）
- **fastScrollVerticalThumbDrawable** StateListDrawable类型将被用来绘制可以在纵轴可滑动的的滑块
- **fastScrollVerticalTrackDrawable** StateListDrawable类型将被用来绘制一条表示在纵轴上的scrollbar的线条

**后四个的属性的值需要是StateListDrawable 否则会报错**（译者注）

让我们来看一下StateListDrawables ，我使用原生形状，以便
可以轻松地重复使用它们。

#### line_drawable.xml

```
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item
        android:state_pressed="true"
        android:drawable="@drawable/line"/>

    <item
        android:drawable="@drawable/line"/>
</selector>
```

#### line.xml
```
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
       android:shape="rectangle">

    <solid android:color="@android:color/darker_gray" />

    <padding
        android:top="10dp"
        android:left="10dp"
        android:right="10dp"
        android:bottom="10dp"/>
</shape>
```

#### thumb_drawable.xml
```
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item
        android:state_pressed="true"
        android:drawable="@drawable/thumb"/>

    <item
        android:drawable="@drawable/thumb"/>
</selector>
```

#### thumb.xml ####

```
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
       android:shape="rectangle">

    <corners
        android:topLeftRadius="44dp"
        android:topRightRadius="44dp"
        android:bottomLeftRadius="44dp" />

    <padding
        android:paddingLeft="22dp"
        android:paddingRight="22dp" />

    <solid android:color="@color/colorPrimaryDark" />

</shape>
```

效果如下所示：

![image](https://cdn-images-1.medium.com/max/1600/1*RN2W9mpIMaFkAqs2KI5pyw.gif)

太棒了！
![image](https://cdn-images-1.medium.com/max/1600/1*cK8-ghSt_uRfRvMlJNd9cw.gif)

这是启用快速滚动的基本示例。看到我们如何自定义它以显示信件的首字母，如联系人应用程序。

[Demo](https://github.com/shaishavgandhi05/FastScrolling)

最后，happy coding。