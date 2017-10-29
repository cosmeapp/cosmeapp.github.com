---
title: Android线程知识整理
author:
  name: 张经纬
  link:
date: 2017-10-29 22:26:16
tags:
- Android
---

## Android线程知识整理

* Handler

每个线程都和一个Handler类实例绑定，而且可以和别的线程一起运行，相互通信。
AsyncTask内部也是使用Handler进行处理的，只是不是运行在UI线程而已，它会提供一个channel来和UI线程通信，使用postExecute方法即可实现。

* AsyncTask

使用AsyncTask是在Android上操作线程最简单的方式，也是最容易出错的方式。

* IntentService

这种方式需要写更多的代码，但是这是把耗时任务移动到后台的很好的方式，也是我最喜欢的方式。配上使用一个EventBus机制的框架如Otto，这样的话实现IntentService就非常简单了。

* Loader

关于处理异步任务，还有很多事情需要做，比如从数据库或者内容提供者那里处理一些数据。

* Service

如果你曾经使用过Service的话，你应该知道这里会有一点误区，其中一个常见的误解就是服务是运行在后台线程的。其实不是！看似运行在后台是因为它们不与UI组件关联，但是它们（默认）是运行在UI线程上的……所以默认运行在UI线程上，甚至在上面没有UI部件。

### Android进程

Android会根据进程中运行的组件类别以及组件的状态来判断该进程的重要性，Android会首先停止那些不重要的进程。按照重要性从高到低一共有五个级别：

**前台进程 > 可见进程 > 服务进程 > 后台进程 > 空进程**

空进程：未运行任何程序组件。运行这些进程的唯一原因是作为一个缓存，缩短下次程序需要重新使用的启动时间。系统经常中止这些进程，这样可以调节程序缓存和系统缓存的平衡。

Android 对进程的重要性评级的时候，选取它最高的级别。另外，当被另外的一个进程依赖的时候，某个进程的级别可能会增高。一个为其他进程服务的进程永远不会比被服务的进程重要级低。因为服务进程比后台activity进程重要级高，因此一个要进行耗时工作的activity最好启动一个service来做这个工作，而不是开启一个子进程――特别是这个操作需要的时间比activity存在的时间还要长的时候。例如，在后台播放音乐，向网上上传摄像头拍到的图片，使用service可以使进程最少获取到“服务进程”级别的重要级，而不用考虑activity目前是什么状态。broadcast receivers做费时的工作的时候，也应该启用一个服务而不是开一个线程。

#### Android的单线程模型

Android UI操作并不是线程安全的并且这些操作必须在UI线程中执行。

****

### Message Queue

**Message Queue是一个消息队列，用来存放通过Handler发布的消息。** 消息队列通常附属于某一个创建它的线程，可以通过Looper.myQueue()得到当前线程的消息队列。Android在第一次启动程序时会为UI thread创建一个关联的消息队列，用来管理程序的一些上层组件，activities，broadcase receivers等等。你可以在自己的子线程中创建Handler与UI thread通讯。

注：产生一个Message对象，可以new，也可以使用`Message.obtain()`方法；两者都可以，但是更建议使用obtain方法，因为Message内部维护了一个Message池用于Message的复用，避免使用new 重新分配内存。

`Message.obtain()`源码：
```java
/**
 * Return a new Message instance from the global pool. Allows us to
 * avoid allocating new objects in many cases.
 */
public static Message obtain() {
    synchronized (sPoolSync) {
        if (sPool != null) {
            Message m = sPool;
            sPool = m.next;
            m.next = null;
            m.flags = 0; // clear in-use flag
            sPoolSize--;
            return m;
        }
    }
    return new Message();
}
```

### Hanlder

Handler处理者，是Message的主要处理者，负责Message的发送，Message内容的执行处理。后台线程就是通过传进来的Handler对象引用来`sendMessage(Message)`。而使用Handler，需要implement 该类的`handleMessage(Message)`方法，它是处理这些Message的操作内容，例如Update UI。通常需要子类化Handler来实现handleMessage方法。

**Handler实例化时，会首先得到当前线程中保存的Looper实例，进而与Looper实例中的MessageQueue想关联。也就是与当前线程绑定。**

主要的方法有：
```java
public final boolean sendMessage(Message msg)
```
把消息放入该Handler所 关联的消息队列，放置在所有当前时间前未被处理的消息后。

```java
public void handleMessage(Message msg)
```
关联该消息队列的线 程将通过调用Handler的handleMessage方 法来接收和处理消息，通常需要子类化Handler来 实现handleMessage。

```java
public class TestActivity extends Activity {

    // ...
    // all standard stuff

    @Override
    public void onCreate(Bundle savedInstanceState) {

        // ...
        // all standard stuff

        // we're creating a new handler here
        // and we're in the UI Thread (default)
        // so this Handler is associated with the UI thread
        Handler mHandler = new Handler();

        // I want to start doing something really long
        // which means I should run the fella in another thread.
        // I do that by sending a message - in the form of another runnable object

        // But first, I'm going to create a Runnable object or a message for this
        Runnable mRunnableOnSeparateThread = new Runnable() {
            @Override
            public void run () {

                // do some long operation
                longOperation();

                // After mRunnableOnSeparateThread is done with it's job,
                // I need to tell the user that i'm done
                // which means I need to send a message back to the UI thread

                // who do we know that's associated with the UI thread?
                mHandler.post(new Runnable(){
                    @Override
                    public void run(){
                        // do some UI related thing
                        // like update a progress bar or TextView
                        // ....
                    }
                });


            }
        };

        // Cool but I've not executed the mRunnableOnSeparateThread yet
        // I've only defined the message to be sent
        // When I execute it though, I want it to be in a different thread
        // that was the whole point.

        new Thread(mRunnableOnSeparateThread).start();
    }

    }
```

### Looper

Looper是每条线程里的Message Queue的管家。Android没有Global的Message Queue，而Android会自动替主线程(UI线程)建立Message Queue，但在子线程里并没有建立Message Queue。所以调用`Looper.getMainLooper()`得到的主线程的Looper不为NULL，但调用`Looper.myLooper()`得到当前线程的Looper就有可能为NULL。

1)   可以通过Looper类的静态方法`Looper.myLooper`得到当前线程的Looper实例，如果当前线程未关联一个Looper实例，该方法将返回空。

2)   可以通过静态方法`Looper.getMainLooper()`方法得到主线程的Looper实例

* 首先`Looper.prepare()`在本线程中保存一个Looper实例，然后该实例中保存一个MessageQueue对象；因为Looper.prepare()在一个线程中只能调用一次，所以MessageQueue在一个线程中只会存在一个。
* `Looper.loop()`会让当前线程进入一个无限循环，不端从MessageQueue的实例中读取消息，然后回调`msg.target.dispatchMessage(msg)`方法。
* Handler的构造方法，会首先得到当前线程中保存的Looper实例，进而与Looper实例中的MessageQueue想关联。
* Handler的sendMessage方法，会给msg的target赋值为handler自身，然后加入MessageQueue中。
* 在构造Handler实例时，我们会重写handleMessage方法，也就是`msg.target.dispatchMessage(msg)`最终调用的方法。

****
## 多线程

### Hanlder + Thread

Handler可以把一个Message对象或者Runnable对象压入到消息队列中，进而在UI线程中获取Message或者执行Runnable对象，Handler把压入消息队列有两类方式，Post和sendMessage：

post:
```java
class MyThread extends Thread {

      @Override
      public void run() {
          super.run();
          //... 子线程
          mHandler.post(new Runnable() {
              @Override
              public void run() {
                  //... UI线程
              }
          });
      }
}
```

sendMessage:
```java
class MyThread extends Thread {

      @Override
      public void run() {
          super.run();
          //... 子线程
          mHandler.sendMessage(Message.obtain());
      }
}

mHandler = new Handler(){
      @Override
      public void handleMessage(Message msg) {
          super.handleMessage(msg);
          //...
      }
};

```

### AsyncTask

AsyncTask是android提供的轻量级的异步类,可以直接继承AsyncTask，在类中实现异步操作，并提供接口反馈当前异步执行的程度(可以通过接口实现UI进度更新)，最后反馈执行的结果给UI主线程。

```java
new AsyncTask<Integer, Integer, String>() {

           @Override
           protected void onPreExecute() {
               super.onPreExecute();
               //第一个执行方法
           }

           @Override
           protected String doInBackground(Integer... params) {
               //第二个执行方法,onPreExecute()执行完后执行
               return null;
           }

           @Override
           protected void onProgressUpdate(Integer... values) {
               super.onProgressUpdate(values);
               //这个函数在doInBackground调用,获取进度
           }

           @Override
           protected void onPostExecute(String s) {
               super.onPostExecute(s);
               //doInBackground返回时触发，换句话说，就是doInBackground执行完后触发
               //这里的result就是上面doInBackground执行后的返回值，所以这里是"执行完毕"
           }
};
```

### ThreadPoolExecutor

ThreadPoolExecutor提供了一组线程池，可以管理多个线程并行执行。这样一方面减少了每个并行任务独自建立线程的开销，另一方面可以管理多个并发线程的公共资源，从而提高了多线程的效率。所以ThreadPoolExecutor比较适合一组任务的执行。Executors利用工厂模式对ThreadPoolExecutor进行了封装，使用起来更加方便。

```java
Executors.newFixedThreadPool()
//创建一个定长的线程池，每提交一个任务就创建一个线程，直到达到池的最大长度，这时线程池会保持长度不再变化
Executors.newCachedThreadPool()
//创建一个可缓存的线程池，如果当前线程池的长度超过了处理的需要时，它可以灵活的回收空闲的线程，当需要增加时，
//它可以灵活的添加新的线程，而不会对池的长度作任何限制
Executors.newScheduledThreadPool()
//创建一个定长的线程池，而且支持定时的以及周期性的任务执行，类似于Timer
Executors.newSingleThreadExecutor()
//创建一个单线程化的executor，它只创建唯一的worker线程来执行任务
```

### IntentService

IntentService继承自Service，是一个经过包装的轻量级的Service，用来接收并处理通过Intent传递的异步请求。客户端通过调用startService(Intent)启动一个IntentService，利用一个work线程依次处理顺序过来的请求，处理完成后自动结束Service。

IntentService 继承自普通 Service 同时又在内部创建了一个 HandlerThread，在 onHandlerIntent()的回调里面处理扔到 IntentService 的任务。所以 IntentService 就不仅仅具备了异步线程的特性，还同时保留了 Service 不受主页面生命周期影响的特点。

使用 IntentService 需要特别留意以下几点：
* 首先，因为 IntentService 内置的是 HandlerThread 作为异步线程，所以每一个交给 IntentService 的任务都将以队列的方式逐个被执行到，一旦队列中有某个任务执行时间过长，那么就会导致后续的任务都会被延迟处理。

* 其次，通常使用到 IntentService 的时候，我们会结合使用 BroadcastReceiver 把工作线程的任务执行结果返回给主 UI 线程。使用广播容易引起性能问题，我们可以使用 LocalBroadcastManager 来发送只在程序内部传递的广播，从而提升广播的性能。我们也可以使用 runOnUiThread() 快速回调到主 UI 线程。

* 最后，包含正在运行的 IntentService 的程序相比起纯粹的后台程序更不容易被系统杀死，该程序的优先级是介于前台程序与纯后台程序之间的。

****

### View.post()

`View.post(Runnable)`方法。在post(Runnable action)方法里，View获得当前线程（即UI线程）的Handler，然后将action对象post到Handler里。在Handler里，它将传递过来的action对象包装成一个Message（Message的callback为action），然后将其投入UI线程的消息循环中。在Handler再次处理该Message时，有一条分支（未解释的那条）就是为它所设，直接调用runnable的run方法。而此时，已经路由到UI线程里，因此，我们可以毫无顾虑的来更新UI。



## 参考

[浅析Android线程模型](http://www.cppblog.com/fwxjj/archive/2010/05/31/116787.html)

[有关Android线程的学习](http://android.blog.51cto.com/268543/343823)

[Android 多线程的四种方式](http://www.jianshu.com/p/2b634a7c49ec)

[Android性能优化典范之多线程篇](http://www.cnblogs.com/bugly/p/5519510.html)
