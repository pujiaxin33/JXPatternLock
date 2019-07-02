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

        switch title {
        case "密码设置":
            let vc = PasswordConfigViewController(config: ArrowConfig(), type: .setup)
            self.navigationController?.pushViewController(vc, animated: true)
        case "密码修改":
            if PasswordManager.currentPassword() == nil {
                let alert = UIAlertController(title: nil, message: "当前没有密码，请先设置", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                alert.addAction(confirm)
                present(alert, animated: true, completion: nil)
            }else {
                let vc = PasswordConfigViewController(config:  ArrowConfig(), type: .modify)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case "密码验证":
            if PasswordManager.currentPassword() == nil {
                let alert = UIAlertController(title: nil, message: "当前没有密码，请先设置", preferredStyle: .alert)
                let confirm = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                alert.addAction(confirm)
                present(alert, animated: true, completion: nil)
            }else {
                let vc = PasswordConfigViewController(config:  ArrowConfig(), type: .vertify)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        default: break
        }
    }

}
