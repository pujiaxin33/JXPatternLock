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
                let outerStrokeLineWidthStatus = RoundPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
                let outerStrokeColorStatus = RoundPropertyStatus<UIColor>(normal: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: UIColor.red)
                gridView.outerRoundConfig = RoundConfig(radius: 36, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: nil, strokeColorStatus: outerStrokeColorStatus)
                let innerStrokeLineWidthStatus = RoundPropertyStatus<CGFloat>.init(normal: 0, connect: 0, error: 0)
                let innerFillColorStatus = RoundPropertyStatus<UIColor>(normal: nil, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: UIColor.red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: innerStrokeLineWidthStatus, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineNormalColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            lineView.lineErrorColor = UIColor.red
            lineView.triangleNormalColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            lineView.triangleErrorColor = UIColor.red
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
                let outerFillColorStatus = RoundPropertyStatus<UIColor>(normal: nil, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1).withAlphaComponent(0.3), error: UIColor.red.withAlphaComponent(0.3))
                gridView.outerRoundConfig = RoundConfig(radius: 36, strokeLineWidthStatus: nil, fillColorStatus: outerFillColorStatus, strokeColorStatus: nil)
                let innerFillColorStatus = RoundPropertyStatus<UIColor>(normal: UIColor.lightGray, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: UIColor.red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
                return gridView
            }
            let lineView = ConnectLineView()
            lineView.lineNormalColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            lineView.lineErrorColor = UIColor.red
            lineView.lineWidth = 3
            config.connectLine = lineView

            let vc = ExampleViewController(config: config)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

