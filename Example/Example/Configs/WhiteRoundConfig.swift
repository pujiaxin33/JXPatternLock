//
//  WhiteRoundConfig.swift
//  Example
//
//  Created by jiaxin on 2019/7/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import JXPatternLock

struct WhiteRoundConfig: PatternLockViewConfig {
    var matrix: Matrix = Matrix(row: 3, column: 3)
    var gridSize: CGSize = CGSize(width: 70, height: 70)
    var connectLine: ConnectLine?
    var autoMediumGridsConnect: Bool = false
    var connectLineHierarchy: ConnectLineHierarchy = .bottom
    var errorDisplayDuration: TimeInterval = 1
    var initGridClosure: (Matrix) -> (PatternLockGrid)

    init() {
        initGridClosure = {(matrix) -> PatternLockGrid in
            let gridView = GridView()
            let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: .white, error: .red)
            gridView.outerRoundConfig = RoundConfig(radius: 15, lineWidthStatus: nil, lineColorStatus: nil, fillColorStatus: outerFillColorStatus)
            let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: .white, connect: nil, error: nil)
            gridView.innerRoundConfig = RoundConfig(radius: 10, lineWidthStatus: nil, lineColorStatus: nil, fillColorStatus: innerFillColorStatus)
            return gridView
        }
        let lineView = ConnectLineView()
        lineView.lineColorStatus = .init(normal: .white, error: .red)
        lineView.lineWidth = 3
        connectLine = lineView
    }
}
