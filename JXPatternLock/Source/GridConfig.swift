//
//  GridConfig.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

open class GridConfig: PatternLockViewConfig {
    public var matrix: Matrix = Matrix(row: 3, column: 3)
    public var gridSize: CGSize = CGSize(width: 50, height: 50)
    public var gridViewConfig: ((GridView)->())?

    public init() {}

    public func lineColor(in lockView: PatternLockView) -> UIColor {
        return UIColor.blue
    }

    public func lineWidth(in lockView: PatternLockView) -> CGFloat {
        return 3
    }

    public func lockView(_ lockView: PatternLockView, gridViewAt matrix: Matrix) -> PatternLockGridView {
        let grid = GridView()
        gridViewConfig?(grid)
        grid.outerRoundConfig = RoundConfig(radius: 50, strokeLineWidth: 10, fillColorConfig: ColorConfig(normalColor: nil, connectColor: UIColor.blue, errorColor: UIColor.red), strokeColorConfig: ColorConfig.empty)
        return grid
    }
}
