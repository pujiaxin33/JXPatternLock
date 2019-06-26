//
//  PatternLockPathView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class PatternLockPathView: PatternLockView {
    
    public override init(config: PatternLockViewConfig) {
        super.init(config: config)

        isUserInteractionEnabled = false
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func addGrid(at matrix: Matrix) {
        for grid in gridViews {
            if grid.matrix == matrix {
                grid.setStatus(.connect)
                connectedGridViews.append(grid)
                config.connectLine?.addGrid(grid)
                break
            }
        }
    }

    public func reset() {
        connectedGridViews.forEach { $0.setStatus(.normal) }
        connectedGridViews.removeAll()
        config.connectLine?.reset()
    }
}
