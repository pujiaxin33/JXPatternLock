//
//  ExampleViewController.swift
//  Example
//
//  Created by jiaxin on 2019/6/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPatternLock

class ExampleViewController: UIViewController, PatternLockViewDelegate {
    var lockView: PatternLockView!
    let config: PatternLockViewConfig

    init(config: PatternLockViewConfig) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        lockView = PatternLockView(config: config)
        lockView.delegate = self
        view.addSubview(lockView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let lockWidth = 300
        lockView.bounds = CGRect(x: 0, y: 0, width: lockWidth, height: lockWidth)
        lockView.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
    }

    //MARK: - PatternLockViewDelegate
    func lockView(_ lockView: PatternLockView, didConnectedGrid grid: PatternLockGrid) {
    }

    func lockViewShouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool {
        return true
    }

    func lockViewDidConnectCompleted(_ lockView: PatternLockView) {
    }

}
