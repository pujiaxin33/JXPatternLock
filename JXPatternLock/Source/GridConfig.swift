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
    public var connectLine: ConnectLine = ConnectLineView()
    public var gridViewClosure: (Matrix) -> (PatternLockGrid) = {_ in
        return GridView()
    }

    public init() {}
}
