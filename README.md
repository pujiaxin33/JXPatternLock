<div align=center><img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/JXPatternLock.png" width="468" height="90" /></div>

[![platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=plastic)](#)
[![languages](https://img.shields.io/badge/language-swift-blue.svg)](#) 
[![cocoapods](https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=plastic)](https://cocoapods.org/pods/JXPatternLock)
[![support](https://img.shields.io/badge/support-ios%208%2B-orange.svg)](#) 

patternlock desc

## 效果预览


说明 | Gif |
----|------|
设置密码  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/passwordSetup.gif" width="336" height="400"> |
修改密码  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/passwordModify.gif" width="336" height="400"> |
验证密码  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/passwordVertify.gif" width="336" height="400"> |
箭头  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/arrow.gif" width="336" height="330"> |
中间点自动连接 |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/autoConnect.gif" width="336" height="330"> |
小灰点  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/grayRound.gif" width="336" height="330"> |
小白点  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/whiteRound.gif" width="336" height="330"> |
荧光蓝  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/nightBlue.gif" width="336" height="330"> |
fill白色  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/whiteFill.gif" width="336" height="330"> |
阴影  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/shadow.gif" width="336" height="330"> |
图片  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/image.gif" width="336" height="330"> |
旋转  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/rotateImage.gif" width="336" height="330"> |
破折线  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/dashLine.gif" width="336" height="330"> |
图片连接线（箭头）  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/arrowLine.gif" width="336" height="330"> |
图片连接线（小鱼儿）  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/fishLine.gif" width="336" height="330"> |

## 要求

- iOS 9.0+
- Xcode 12.1+
- Swift 5.0

## 安装

### 手动

Clone代码，把Sources文件夹拖入项目，就可以使用了；

### CocoaPods

```ruby
target '<Your Target Name>' do
    pod 'JXPatternLock'
end
```
先执行`pod repo update`，再执行`pod install`

### Carthage
在cartfile文件添加：
```
github "pujiaxin33/JXSegmentedView"
```
然后执行`carthage update --platform iOS` 即可

## 使用

### 初始化`LockConfig`
```Swift
let config = LockConfig()
config.gridSize = CGSize(width: 70, height: 70)
config.matrix = Matrix(row: 3, column: 3)
config.errorDisplayDuration = 1
```

### 配置`GridView`
```Swift
config.initGridClosure = {(matrix) -> PatternLockGrid in
    let gridView = GridView()
    let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
    let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: tintColor, connect: tintColor, error: .red)
    gridView.outerRoundConfig = RoundConfig(radius: 33, lineWidthStatus: outerStrokeLineWidthStatus, lineColorStatus: outerStrokeColorStatus, fillColorStatus: nil)
    let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
    gridView.innerRoundConfig = RoundConfig(radius: 10, lineWidthStatus: nil, lineColorStatus: nil, fillColorStatus: innerFillColorStatus)
    return gridView
}
```

### 配置`ConnectLine`
```Swift
let lineView = ConnectLineView()
lineView.lineColorStatus = .init(normal: tintColor, error: .red)
lineView.triangleColorStatus = .init(normal: tintColor, error: .red)
lineView.isTriangleHidden = false
lineView.lineWidth = 3
config.connectLine = lineView
```

### 初始化`PatternLockView`
```Swift
lockView = PatternLockView(config: config)
lockView.delegate = self
view.addSubview(lockView)
```

## 结构




## 补充

如果刚开始使用`JXPatternLock`，当开发过程中需要支持某种特性时，请务必先搜索使用文档或者源代码。确认是否已经实现支持了想要的特性。请别不要文档和源代码都没有看，就直接提问，这对于大家都是一种时间浪费。如果没有支持想要的特性，欢迎提Issue讨论，或者自己实现提一个PullRequest。

使用过程中，有任何建议或问题，可以通过以下方式联系我：</br>
邮箱：317437084@qq.com </br>

喜欢就star❤️一下吧

## License

JXPatternLock is released under the MIT license.

