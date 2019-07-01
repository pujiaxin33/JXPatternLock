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
        for grid in grids {
            if grid.matrix == matrix {
                grid.setStatus(.connect)
                connectedGrids.append(grid)
                config.connectLine?.addGrid(grid)
                break
            }
        }
    }
}
