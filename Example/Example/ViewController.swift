//
//  ViewController.swift
//  Example
//
//  Created by jiaxin on 2019/6/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPatternLock

class ViewController: UIViewController, PatternLockViewDelegate {
    var lockView: PatternLockView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let config = GridConfig()
        config.gridSize = CGSize(width: 100, height: 100)
        lockView = PatternLockView(config: config)
        lockView.delegate = self
        view.addSubview(lockView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        lockView.frame = CGRect(x: 10, y: 200, width: view.bounds.size.width - 20, height: view.bounds.size.width - 20)
    }

    func locakView(_ lockView: PatternLockView, didConnectedGridAt matrix: Matrix) {

    }

    func shouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool {
        return true
    }

    func connectDidCompleted(_ lockView: PatternLockView) {

    }

}

