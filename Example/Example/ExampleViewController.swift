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
    var lockViewConfig: ((PatternLockView) -> ())?
    private var lockView: PatternLockView!
    private var currentPassword: String = ""
    private let config: GridConfig

    deinit {
        lockViewConfig = nil
    }

    init(config: GridConfig) {
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
        lockViewConfig?(lockView)
        view.addSubview(lockView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        lockView.frame = CGRect(x: 50, y: 200, width: view.bounds.size.width - 100, height: view.bounds.size.width - 100)
    }

    func locakView(_ lockView: PatternLockView, didConnectedGrid grid: PatternLockGrid) {
        currentPassword.append(grid.identifier)
    }

    func shouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool {
        return true
    }

    func connectDidCompleted(_ lockView: PatternLockView) {
        print(currentPassword)
        currentPassword = ""
    }

}
