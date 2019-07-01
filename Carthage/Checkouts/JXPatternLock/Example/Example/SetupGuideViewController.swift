//
//  SetupGuideViewController.swift
//  Example
//
//  Created by jiaxin on 2019/6/28.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPatternLock

class SetupGuideViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

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
        lineView.triangleColorStatus = .init(normal: tintColor, error: .red)
        lineView.isTriangleHidden = false
        lineView.lineWidth = 3
        config.connectLine = lineView

        switch title {
        case "密码设置":
            let vc = PasswordConfigViewController(config: config, type: .setup)
            self.navigationController?.pushViewController(vc, animated: true)
        case "密码修改":
            if PasswordManager.currentPassword() == nil {
                let alert = UIAlertController(title: nil, message: "当前没有密码，请先设置", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                alert.addAction(confirm)
                present(alert, animated: true, completion: nil)
            }else {
                let vc = PasswordConfigViewController(config: config, type: .modify)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case "密码验证":
            if PasswordManager.currentPassword() == nil {
                let alert = UIAlertController(title: nil, message: "当前没有密码，请先设置", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                alert.addAction(confirm)
                present(alert, animated: true, completion: nil)
            }else {
                let vc = PasswordConfigViewController(config: config, type: .vertify)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default: break
        }
    }

}
