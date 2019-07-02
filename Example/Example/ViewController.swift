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
            let vc = ExampleViewController(config: ArrowConfig())
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "中间点自动连接":
            //对已经封装好的配置进行微调
            var config = ArrowConfig()
            config.autoMediumGridsConnect = true
            let vc = ExampleViewController(config: config)
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "小灰点":
            let vc = ExampleViewController(config: GrayRoundConfig())
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "小白点":
            let vc = ExampleViewController(config: WhiteRoundConfig())
            vc.view.backgroundColor = .black
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "荧光蓝":
            let vc = ExampleViewController(config: NightBlueConfig())
            vc.view.backgroundColor = .black
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "白色Fill":
            let vc = ExampleViewController(config: WhiteFillConfig())
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "阴影":
            let vc = ExampleViewController(config: ShadowConfig())
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "图片":
            let vc = ExampleViewController(config: ImageConfig())
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "旋转":
            let vc = ExampleViewController(config: RotateImageConfig())
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "虚线(使用LockConfig)":
            let config = LockConfig()
            config.gridSize = CGSize(width: 70, height: 70)
            config.matrix = Matrix(row: 3, column: 3)
            config.errorDisplayDuration = 1
            let tintColor = colorWithRGBA(r: 18, g: 143, b: 235, a: 1)
            config.initGridClosure = {(matrix) -> PatternLockGrid in
                let gridView = GridView()
                let outerStrokeLineWidthStatus = GridPropertyStatus<CGFloat>.init(normal: 1, connect: 2, error: 2)
                let outerStrokeColorStatus = GridPropertyStatus<UIColor>(normal: tintColor, connect: tintColor, error: .red)
                gridView.outerRoundConfig = RoundConfig(radius: 33, lineWidthStatus: outerStrokeLineWidthStatus, lineColorStatus: outerStrokeColorStatus, fillColorStatus: nil)
                let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: tintColor, error: .red)
                gridView.innerRoundConfig = RoundConfig(radius: 10, lineWidthStatus: nil, lineColorStatus: nil, fillColorStatus: innerFillColorStatus)
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
            let vc = ExampleViewController(config: ImageLineConfig())
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        case "ImageLineView(小鱼)":
            let vc = ExampleViewController(config: FishLineConfig())
            vc.title = title
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            break
        }
    }
}

