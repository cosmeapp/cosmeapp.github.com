---
title: FlexboxLayout的封装过程
author:
  name: 刘赛登
  link:
date: 2017-10-29 22:22:49
tags:
- Android
---

## 什么是FlexboxLayout
[FlexboxLayout](https://github.com/google/flexbox-layout)是Google开源出来的一个控件。

> FlexboxLayout is a library project which brings the similar capabilities of CSS Flexible Box Layout Module to Android.

上面大致的意思是FLexboxLayout是一个能为android带来类似CSS Flexbox 布局类似的能力的组件。

根据官方的说明，在使用FlexboxLayout之前，我们需要了解CSS Flexbox属性。以下是了解Flexbox的链接，需要各位了解：

1. [CSS Flexbox 介绍](http://cssreference.parryqiu.com/flexbox/)
2. [FLEXBOX FROGGY玩游戏学flex
](http://flexboxfroggy.com/#zh-cn)
3. [Flexbox相关收集](https://github.com/huixisheng/flexbox)

## 实例
![image](https://raw.githubusercontent.com/HuangYuSherry/sketch/master/demo.png)

## 使用场景
实例中说明FlexboxLayout可以来实现首页功能按钮的多行布局（**解决RecyclerView嵌套问题**），流式布局（**代替[hongyang 的FlowLayout](https://github.com/hongyangAndroid/FlowLayout)，官方的功能性更强**）,前两个场景应该还我们开发过程经常会碰到的，当然还有很多使用场景。

## 封装过程 ##

我封装的目的是为了使用方便,并没有对fleboxlayout本身做内部操作。

### 引入Flexboxlayout ###

在项目的build.gradle添加一下代码:
```
dependencies {
    compile 'com.google.android:flexbox:0.3.1'
}
```
### 创建Adapter适配器
```
public abstract class FlexBoxAdapter<T extends FlexBoxViewHolder> {

    public abstract T onCreateViewHolder(ViewGroup parent);

    public abstract void onHandleLayoutParams(View view, int spanCount, int position);

    public abstract void onBindViewHolder(T holder, int position);

    public abstract int getCount();

    private final DataSetObservable mDataSetObservable = new DataSetObservable();

    public void registerDataSetObserver(DataSetObserver observer) {
        mDataSetObservable.registerObserver(observer);
    }

    public void unregisterDataSetObserver(DataSetObserver observer) {
        mDataSetObservable.unregisterObserver(observer);
    }

    public void notifyDataSetChanged() {
        mDataSetObservable.notifyChanged();
    }
}
```
使用adapter是了为控件提供数据的来源，将数据和View本身分离，对实现者来说操作层面上只需要关注**onCreateViewHolder()**,**onBindViewHolder()**，**onHandleLayoutParams()**,熟悉RecyclerView的人来说能理解前两个方法，第三个方法是为了对子view进行Flexbox属性操作。例如：

```
@Override
    public void onHandleLayoutParams(View view, int spanCount, int position) {
        FlexboxLayout.LayoutParams lp = (FlexboxLayout.LayoutParams) view.getLayoutParams();
        if ((position) % spanCount == 0) {
            lp.setWrapBefore(true);
        } else {
            lp.setWrapBefore(false);
        }
        view.setLayoutParams(lp);
    }
```
上面的属性是调用者主动让子View换行。使用情景可以首页功能按钮为多行。

###封装FlexboxLayout
核心代码

```
 public void setAdapter(FlexBoxAdapter adapter) {
        if (mAdapter != null && mDataSetObserver != null) {
            mAdapter.unregisterDataSetObserver(mDataSetObserver);
        }

        mAdapter = adapter;

        if (mAdapter != null) {
            mDataSetObserver = new AdapterDataSetObserver();
            mAdapter.registerDataSetObserver(mDataSetObserver);
            removeAllViews();
            mHolders.clear();
            refreshView();
        } else {
            throw new NullPointerException("adapter 不可为空");
        }
    }
    private void refreshView() {
        mCurItemCount = mAdapter.getCount();
        if (mCurItemCount > 0) {
            for (int i = 0; i < mCurItemCount; i++) {
                final FlexBoxViewHolder holder = createViewHolder(i);

                onHandleItmViewListener(i, holder);

                mAdapter.onHandleLayoutParams(holder.itemView, mSpanCount, i);

                mAdapter.onBindViewHolder(holder, i);
            }
        } else {
            removeAllViews();
            mHolders.clear();
        }
    }

    /**
     * 创建ViewHolder
     *
     * @param position
     * @return
     */
    private FlexBoxViewHolder createViewHolder(int position) {

        FlexBoxViewHolder holder = null;
        if (mHolders.size() > position) {
            holder = mHolders.get(position);
        }

        if (holder == null) {
            holder = mAdapter.onCreateViewHolder(this);
            if (holder.itemView.getParent() == null) {// 未添加到父布局中需要添加，已经添加的不需要再次添加
                this.addView(holder.itemView, position);
            }
            mHolders.add(holder);
        }
        return holder;
    }

     private void notifyDataSetChanged() {
        if (getChildCount() > mAdapter.getCount()) {
            removeViewAt(getChildCount() - mAdapter.getCount());
        }
        refreshView();
    }
```
这里开放setAdapter()供调用者使用，接下来做的操作解释创建View，添加View，对View进行数据操作，这方面可以对照**onCreateViewHolder()**,**onBindViewHolder()**两个方法理解。

### 点击事件
```
 flexboxLayout.setOnFlexBoxItemClickListener(new OnFlexBoxItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                //@todo
            }
        });
```


### 调用代码

```
UIFlexBoxView tagView = findViewById(R.id.tag_view);
TagFlexBoxAdapter  adapter = new TagFlexBoxAdapter(tagList.getTags());
tagView(adapter);
```

### 关于NotifyDataSetChanged()
notifyDataSetChanged() 这边是为了减少View的创建，并没有实现RecyclerView的View复用的效果。当然你依然可以在数据变化后依然调用setAdapter(),在正常情况下并不影响使用效果。


[github项目地址](https://github.com/shamao/Beauty/tree/master/app/src/main/java/beauty/louise/com/view/flexbox)












