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
        case "仿支付宝":
            let config = LockConfig()
            config.gridSize = CGSize(width: 50, height: 50)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 36, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: nil, strokeColorStatus: outerStrokeColorStatus)
                let innerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 0, connect: 0, error: 0)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: innerStrokeLineWidthStatus, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineNormalColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            lineView.lineErrorColor = .red
            lineView.triangleNormalColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            lineView.triangleErrorColor = .red
            lineView.isTriangleHidden = false
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            self.navigationController?.pushViewController(vc, animated: true)

        case "Grid Example 2":
            let config = LockConfig()
            config.gridSize = CGSize(width: 50, height: 50)
            config.matrix = Matrix(row: 3, column: 3)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 0.3), error: UIColor.red.withAlphaComponent(0.3))
                gridView.outerRoundConfig = RoundConfig(radius: 36, strokeLineWidthStatus: nil, fillColorStatus: outerFillColorStatus, strokeColorStatus: nil)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: .lightGray, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineNormalColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            lineView.lineErrorColor = .red
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            self.navigationController?.pushViewController(vc, animated: true)

        case "Grid Example 3":
            let config = LockConfig()
            config.gridSize = CGSize(width: 50, height: 50)
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
            lineView.lineNormalColor = .white
            lineView.lineErrorColor = .red
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            vc.view.backgroundColor = .black
            self.navigationController?.pushViewController(vc, animated: true)

        case "Grid Example 4":
            let config = LockConfig()
            config.gridSize = CGSize(width: 50, height: 50)
            config.matrix = Matrix(row: 3, column: 3)
            let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 1, error: 1)
                let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: .white, error: .white)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: .gray, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 36, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: outerFillColorStatus, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineNormalColor = tintColor
            lineView.lineErrorColor = .red
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            self.navigationController?.pushViewController(vc, animated: true)

        case "阴影":
            let config = LockConfig()
            config.gridSize = CGSize(width: 50, height: 50)
            config.matrix = Matrix(row: 3, column: 3)
            let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = ShadowGridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 1, error: 1)
                let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: .white, error: .white)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: .gray, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 36, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: outerFillColorStatus, strokeColorStatus: outerStrokeColorStatus)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineNormalColor = tintColor
            lineView.lineErrorColor = .red
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            self.navigationController?.pushViewController(vc, animated: true)

        case "图片":
            let config = LockConfig()
            config.gridSize = CGSize(width: 50, height: 50)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = ImageGridView()
                gridView.imageStatus = GridPropertyStatus<UIImage>.init(normal: UIImage(named: "emoji1"), connect: UIImage(named: "emoji2"), error: UIImage(named: "emoji3"))
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineNormalColor = tintColor
            lineView.lineErrorColor = .red
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            self.navigationController?.pushViewController(vc, animated: true)

        case "旋转":
            let config = LockConfig()
            config.gridSize = CGSize(width: 50, height: 50)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = RotateImageGridView()
                gridView.imageStatus = GridPropertyStatus<UIImage>.init(normal: UIImage(named: "jinitaimei.jpg"), connect: UIImage(named: "jinitaimei.jpg"), error: UIImage(named: "jinitaimei.jpg"))
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineNormalColor = tintColor
            lineView.lineErrorColor = .red
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

