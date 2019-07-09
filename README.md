<div align=center><img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/JXPatternLock.png" width="468" height="90" /></div>

[![platform](https://img.shields.io/badge/platform-iOS-blue.svg?style=plastic)](#)
[![languages](https://img.shields.io/badge/language-swift-blue.svg)](#) 
[![cocoapods](https://img.shields.io/badge/cocoapods-supported-4BC51D.svg?style=plastic)](https://cocoapods.org/pods/JXPatternLock)
[![carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage/)
[![support](https://img.shields.io/badge/support--ios-iOS9%2B-orange.svg)](#) 

An easy-to-use, powerful, customizable pattern lock view in swift. 图形解锁／手势解锁 / 手势密码 / 图案密码 / 九宫格密码

相比于其他同类三方库有哪些优势：
- 完全面对协议编程，支持高度自定义**网格视图**和**连接线视图**，轻松实现各类不同需求；
- 默认支持多种配置效果，支持大部分主流效果，引入就可以搞定需求；
- 源码采用**Swift5**编写，通过泛型、枚举、函数式编程优化代码，具有更高的学习价值；
- 后期会持续迭代，不断添加主流效果；

## 效果预览


说明 | Gif |
----|------|
箭头  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/arrow.gif" width="336" height="330"> |
中间点自动连接 |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/autoConnect.gif" width="336" height="330"> |
小灰点  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/grayRound.gif" width="336" height="330"> |
小白点  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/whiteRound.gif" width="336" height="330"> |
荧光蓝  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/nightBlue.gif" width="336" height="330"> |
fill白色  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/whiteFill.gif" width="336" height="330"> |
阴影  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/shadow.gif" width="336" height="330"> |
图片  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/image.gif" width="336" height="330"> |
旋转(鸡你太美)  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/rotateImage.gif" width="336" height="330"> |
破折线  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/dashLine.gif" width="336" height="330"> |
图片连接线（箭头）  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/arrowLine.gif" width="336" height="330"> |
图片连接线（小鱼儿）  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/fishLine.gif" width="336" height="330"> |
设置密码  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/passwordSetup.gif" width="336" height="400"> |
修改密码  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/passwordModify.gif" width="336" height="400"> |
验证密码  |  <img src="https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/passwordVertify.gif" width="336" height="400"> |

## 要求

- iOS 9.0+
- Xcode 10.2.1+
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
github "pujiaxin33/JXPatternLock"
```
然后执行`carthage update --platform iOS` 即可

## 使用

### 初始化`PatternLockViewConfig`

#### 方式一：使用`LockConfig`
`LockConfig`是默认提供的类，实现了`PatternLockViewConfig`协议。可以直接通过`LockConfig`的属性进行自定义。
```Swift
let config = LockConfig()
config.gridSize = CGSize(width: 70, height: 70)
config.matrix = Matrix(row: 3, column: 3)
config.errorDisplayDuration = 1
```

#### 方式二：新建实现`PatternLockViewConfig`协议的类
该方式可以将所有配置细节聚集到自定义类的内部，外部只需要初始化自定义类即可。详情请参考demo里面的`ArrowConfig`类。这样有个好处就是，多个地方都需要用到同样配置的时候，只需要初始化相同的类，而不用像使用`LockConfig`那样，复制属性配置代码。
```Swift
struct ArrowConfig: PatternLockViewConfig {
    var matrix: Matrix = Matrix(row: 3, column: 3)
    var gridSize: CGSize = CGSize(width: 70, height: 70)
    var connectLine: ConnectLine?
    var autoMediumGridsConnect: Bool = false
    //其他属性配置！只是示例，就不显示所有配置项，影响文档长度
}
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

![structure](https://github.com/pujiaxin33/JXExampleImages/blob/master/PatternLock/JXPatternLockStructure.png)

完全遵从面对协议开发。
`PatternLockView`依赖于配置协议`PatternLockViewConfig`。
配置协议配置网格协议`PatternLockGrid`和连接线协议`ConnectLine`。

## 补充

如果刚开始使用`JXPatternLock`，当开发过程中需要支持某种特性时，请务必先搜索使用文档或者源代码。确认是否已经实现支持了想要的特性。请别不要文档和源代码都没有看，就直接提问，这对于大家都是一种时间浪费。如果没有支持想要的特性，欢迎提Issue讨论，或者自己实现提一个PullRequest。

使用过程中，有任何建议或问题，可以通过以下方式联系我：</br>
邮箱：317437084@qq.com </br>

喜欢就star❤️一下吧

## License

JXPatternLock is released under the MIT license.

