---
title: iOS开发-利用AVFoundation开发仿微信的拍摄功能
author:
  name: 李傲
  link:
date: 2017-10-29 22:27:39
tags:
---

## iOS开发-利用AVFoundation开发仿微信的拍摄功能

### AVFoundation概述

AVFoundation是一个可以用来使用和创建基于时间的视听媒体的框架，它提供了一个能使用基于时间的视听数据的详细级别的Objective-C接口。

你可以用它来：

- 检查，创建，编辑或是重新编码媒体文件
- 从设备中获取输入流
- 在视频实时播放时操作和回放

AVFoundation框架包含视频相关的APIs和音频相关的API。



### 开发中要使用的相关的类

- AVCaptureSession ：是AVFoundation的核心类,用于捕捉视频和音频,协调视频和音频的输入和输出流。
- AVCaptureVideoPreviewLayer：一个核心动画层，当有视频被捕获时，就可以在这上面显示。他是CALayer的子类。
- AVCaptureDevice：可以初始化一个设备，这个设备可以是视频或者音频。你可以使用这个设备配置一些硬件属性。它同时向AVCaptureSession提供输入数据
- AVCaptureDeviceInput：设备输入
- AVCaptureVideoDataOutput: 视频输出
- AVCaptureAudioDataOutput：音频输出
- AVCaptureStillImageOutput：图像输出



### 项目相关需求

​   同时提供拍照和录制视频功能。单击拍摄按钮为拍照功能，长按则直接录制视频。

### code

​   在vc(ViewController，一下ViewController均简称vc)中定义如下与AVFoundation相关的属性:

```swift
    //会话
    private var session : AVCaptureSession?

    //视频音频设备
    private var videoCaptureDevice : AVCaptureDevice?
    private var audioCaptureDevice : AVCaptureDevice?

    //视频音频输入
    private var videoDeviceInput : AVCaptureDeviceInput?
    private var audioDeviceInput : AVCaptureDeviceInput?

    //视频音频照片输出
    private var videoOutput : AVCaptureVideoDataOutput?
    private var audioOutput : AVCaptureAudioDataOutput?
    private var imageOutput : AVCaptureStillImageOutput?

    //用于视频缓存
    private var mediaWriter : PBJMediaWriter?
    private var videoPreviewLayer : AVCaptureVideoPreviewLayer?
```

并在代码中初始化

初始化session:

```swift
session = AVCaptureSession()
session?.sessionPreset = AVCaptureSessionPreset1280x720
```

初始化video相关设备，并与session绑定：

```swift
    //video
    videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    do {
            videoDeviceInput = try AVCaptureDeviceInput.init(device: videoCaptureDevice!)
        } catch {
            print("initial videoDeviceInput error")
            return
        }

    //video input
    if session!.canAddInput(videoDeviceInput!) {
      //如果session支持该inputDevice，则添加到session中
        session!.addInput(videoDeviceInput!)
        videoPreviewLayer?.connection.videoOrientation = .portrait
    }
```

以相同的逻辑初始化audio:

```swift
//audio
audioCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio)

do {
    audioDeviceInput = try AVCaptureDeviceInput.init(device: audioCaptureDevice)
} catch {
    print("initial videoDeviceInput error")
}

//audio input
if session!.canAddInput(audioDeviceInput!) {
    session!.addInput(audioDeviceInput!)
}
```

该项目中同时又三个输出，即视频，音频和图片：其初始化方法如下：

```swift
//video output
videoOutput = AVCaptureVideoDataOutput()
videoOutput!.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
videoOutput!.setSampleBufferDelegate(self, queue: queue)
session!.addOutput(videoOutput)

//audio output
audioOutput = AVCaptureAudioDataOutput()
audioOutput!.setSampleBufferDelegate(self, queue: queue)
session!.addOutput(audioOutput)

//photo output
imageOutput = AVCaptureStillImageOutput()
imageOutput!.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
session!.addOutput(imageOutput)

```

以上代码中，在设置setSampleBufferDelegate，加入了一个queue队列，这是一个串行队列，在vc中初始化如下：

```swift
//音频视频输出的串行队列
lazy private var queue : DispatchQueue = {
    let queue = DispatchQueue(label: "ouputQueue")
    return queue
}()
```

同时，这里使用了一个第三方库用于将拍照或者录制的数据写入硬盘中：

```swift
//视频缓存路径
private let path : URL = {
let doc = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).last
let path = doc?.appendingPathComponent("recordVideo").appendingPathExtension("mp4")
return path!
}()

//用于视频缓存
private var mediaWriter : PBJMediaWriter?

```

在代码中设置若干标志位用于记录当前的拍摄状态，并记录录制时间：

```swift
//状态
private var isRecording : Bool = false //录制状态
private var isTakePhoto : Bool = false //拍照状态
private var beginTime : TimeInterval? = nil //开始录制时间
private var videoWritten : Bool = false //记录buffer是否是视
```

监听手势，当长按手势大于指定时间时，则判定为录制视频，否则，则是拍照：

```swift
//MARK: 手势响应
func handleLongPress(_ gesture : UILongPressGestureRecognizer) {
    if gesture.state == .began {
        beginTime = Date().timeIntervalSince1970
        _startVideo()
    } else if gesture.state == .cancelled || gesture.state == .ended {
        if Date().timeIntervalSince1970 - beginTime! < minRecordDuration {
            _takePhoto()
        } else {
            _endVideo()
        }
    }
}
```

最核心的就是监听AVCaptureVideoDataOutputSampleBufferDelegate和AVCaptureAudioDataOutputSampleBufferDelegate的回调方法，将数据存入指定的路径中：

```swift
//MARK: AVCaptureVideoDataOutputSampleBufferDelegate && AVCaptureAudioDataOutputSampleBufferDelegate
func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        if !CMSampleBufferDataIsReady(sampleBuffer) {
            return
        }

        // check
        if !isRecording ||  mediaWriter == nil {
            return
        }

        let isVideo = captureOutput == videoOutput

        if !isVideo && !(mediaWriter!.isAudioReady)  {
            //audio settings
            _ = _setupAudioWithSampleBuffer(sampleBuffer: sampleBuffer)
        }

        if isVideo && !(mediaWriter!.isVideoReady) {
            //video settings
            _ = _setupVideoWithSampleBuffer(sampleBuffer: sampleBuffer)
        }


        let isReadyToRecord : Bool = mediaWriter!.isAudioReady && mediaWriter!.isVideoReady

        if (!isReadyToRecord) {
            //需要音频和视频同时准备好
            return;
        }

        if isVideo {
            mediaWriter?.write(sampleBuffer, withMediaTypeVideo: isVideo)
            videoWritten = true

        } else if !isVideo && videoWritten  {
            mediaWriter?.write(sampleBuffer, withMediaTypeVideo: isVideo)
        }
    }
```

在开启系统设备后，videoOutput和audioOutput都会将数据出入该回调方法，即sampleBuffer。在音频和视频buffer同时准备好了之后，则将该buffer写入指定路径。拍照则使用另外一套逻辑。

```swift
func _takePhoto() {
        isTakePhoto = true

        let videoConnection = imageOutput?.connection(withMediaType: AVMediaTypeVideo);
        videoConnection?.videoOrientation = .portrait

        imageOutput?.captureStillImageAsynchronously(from: videoConnection!, completionHandler: { (buffer, error) in
            if error == nil {
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                var image = UIImage(data: imageData!)
                image = image!.fixOrientation()
                let vc = VisionPreviewViewController()
                vc.photo = image
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: false)
            }

        })
    }
```

利用imageOutput异步获取imageData并转为image格式。


## 总结

利用AVFoundation开发拍摄功能的核心代码已经介绍大致如上，其中还是许多相关细节并没与在文中意义赘述，代码请参考：https://github.com/leoIsAllRight/SwiftDemo/tree/master/SwiftDemo的vision中的相关类。



