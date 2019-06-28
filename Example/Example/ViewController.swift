//
//  ViewController.swift
//  Example
//
//  Created by jiaxin on 2019/6/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPatternLock

func colorWithRGBA(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: a)
}

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        var title = ""
        for view in cell!.contentView.subviews {
            if let label = view as? UILabel {
                title = label.text!
                break
            }
        }
        switch title {
        case "密码设置、修改、验证":
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SetupGuideViewController")
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "箭头":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            let tintColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: tintColor, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 33, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: nil, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: tintColor, error: .red)
            lineView.triangleColorStatus = .init(normal: tintColor, error: .red)
            lineView.isTriangleHidden = false
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "小灰点":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 0.3), error: UIColor.red.withAlphaComponent(0.3))
                gridView.outerRoundConfig = RoundConfig(radius: 33, strokeLineWidthStatus: nil, fillColorStatus: outerFillColorStatus, strokeColorStatus: nil)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: .lightGray, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: .red)
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "小白点":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: .white, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 15, strokeLineWidthStatus: nil, fillColorStatus: outerFillColorStatus, strokeColorStatus: nil)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: .white, connect: nil, error: nil)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: .white, error: .red)
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.view.backgroundColor = .black
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "荧光蓝":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            let tintColor = colorWithRGBA(r: 18, g: 106, b: 152, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: UIColor.black.withAlphaComponent(0.3), error: UIColor.red.withAlphaComponent(0.3))
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 2, connect: 2, error: 2)
                gridView.outerRoundConfig = RoundConfig(radius: 33, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: outerFillColorStatus, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: .white, connect: .white, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: tintColor, error: .red)
            lineView.lineWidth = 10
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.view.backgroundColor = .black
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "白色Fill":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 1, error: 1)
                let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: .white, error: .white)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: .gray, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 33, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: outerFillColorStatus, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: tintColor, error: .red)
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "阴影":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = ShadowGridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 1, error: 1)
                let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: .white, error: .white)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: .gray, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 33, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: outerFillColorStatus, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: tintColor, error: .red)
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "图片":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = ImageGridView()
                gridView.imageStatus = GridPropertyStatus<UIImage>.init(normal: UIImage(named: "emoji1"), connect: UIImage(named: "emoji2"), error: UIImage(named: "emoji3"))
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: tintColor, error: .red)
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "旋转":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = RotateImageGridView()
                gridView.imageStatus = GridPropertyStatus<UIImage>.init(normal: UIImage(named: "jinitaimei.jpg"), connect: UIImage(named: "jinitaimei.jpg"), error: UIImage(named: "jinitaimei.jpg"))
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: tintColor, error: .red)
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "ConnectLineView属性自定义":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            let tintColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: tintColor, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 33, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: nil, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineColorStatus = .init(normal: tintColor, error: .red)
            lineView.lineWidth = 3
            lineView.lineOtherConfig = {(line) in
                line.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 10)]
            }
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "ImageLineView(箭头)":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            config.connectLineHierarchy = .top
            let tintColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: tintColor, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 33, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: nil, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ImageLineView(imageStatus: .init(normal: UIImage(named: "arrow"), error: UIImage(named: "arrowRed")))
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "ImageLineView(小鱼)":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            config.connectLineHierarchy = .top
            let tintColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: tintColor, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 33, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: nil, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ImageLineView(imageStatus: .init(normal: UIImage(named: "fish"), error: UIImage(named: "fishRed")))
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

