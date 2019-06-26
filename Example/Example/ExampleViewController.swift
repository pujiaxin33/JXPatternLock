//
//  ExampleViewController.swift
//  Example
//
//  Created by jiaxin on 2019/6/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXPatternLock
import Security

class ExampleViewController: UIViewController, PatternLockViewDelegate {
    private var lockView: PatternLockView!
    private var currentPassword: String = ""
    private let config: LockConfig
    private var pathView: PatternLockPathView?

    init(config: LockConfig) {
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

        let pathConifg = LockConfig()
        pathConifg.gridSize = CGSize(width: 15, height: 15)
        pathConifg.matrix = Matrix(row: 3, column: 3)
        pathConifg.initGridClosure = {(matrix) -> PatternLockGrid in
            let gridView = GridView()
            let outerStrokeLineWidthStatus = RoundPropertyStatus<CGFloat>.init(normal: 1, connect: 1, error: 1)
            let outerStrokeColorStatus = RoundPropertyStatus<UIColor>(normal: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: UIColor.red)
            let outerFillColorStatus = RoundPropertyStatus<UIColor>(normal: nil, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: UIColor.red)
            gridView.outerRoundConfig = RoundConfig(radius: 6, strokeLineWidthStatus: outerStrokeLineWidthStatus, fillColorStatus: outerFillColorStatus, strokeColorStatus: outerStrokeColorStatus)
            let innerStrokeLineWidthStatus = RoundPropertyStatus<CGFloat>.init(normal: 0, connect: 0, error: 0)
            gridView.innerRoundConfig = RoundConfig(radius: 0, strokeLineWidthStatus: innerStrokeLineWidthStatus, fillColorStatus: nil, strokeColorStatus: nil)
            return gridView
        }

        pathView = PatternLockPathView(config: pathConifg)
        pathView?.frame = CGRect(x: 100, y: 20, width: 100, height: 100)
        view.addSubview(pathView!)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        lockView.frame = CGRect(x: 50, y: 200, width: view.bounds.size.width - 100, height: view.bounds.size.width - 100)
    }

    func lockView(_ lockView: PatternLockView, didConnectedGrid grid: PatternLockGrid) {
        currentPassword.append(grid.identifier)
        pathView?.addGrid(at: grid.matrix)
    }

    func lockViewShouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool {
        return true
    }

    func lockViewDidConnectCompleted(_ lockView: PatternLockView) {
        print(currentPassword)
        currentPassword = ""
    }

}
