//
//  GridConfig.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

/// 所有的配置项都是静态配置，配置好之后再更新是没有效果的！！！
open class LockConfig: PatternLockViewConfig {
    public var connectLineHierarchy: ConnectLineHierarchy = .bottom
    public var matrix: Matrix = Matrix(row: 3, column: 3)
    public var gridSize: CGSize = CGSize(width: 50, height: 50)
    public var connectLine: ConnectLine?
    public var errorDisplayDuration: TimeInterval = 0.5
    public var initGridClosure: (Matrix) -> (PatternLockGrid) = {_ in
        //默认配置
        let gridView = GridView()
        let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: UIColor.blue.withAlphaComponent(0.3), error: UIColor.red.withAlphaComponent(0.3))
        gridView.outerRoundConfig = RoundConfig(radius: 36, strokeLineWidthStatus: nil, fillColorStatus: outerFillColorStatus, strokeColorStatus: nil)
        let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: UIColor.lightGray, connect: UIColor.blue, error: UIColor.red)
        gridView.innerRoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: nil, fillColorStatus: innerFillColorStatus, strokeColorStatus: nil)
        return gridView
    }

    public init() {}
}
