//
//  GrayRoundConfig.swift
//  Example
//
//  Created by jiaxin on 2019/7/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import JXPatternLock

struct GrayRoundConfig: PatternLockViewConfig {
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
            let outerFillColorStatus = GridPropertyStatus<UIColor>(normal: nil, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 0.3), error: UIColor.red.withAlphaComponent(0.3))
            gridView.outerRoundConfig = RoundConfig(radius: 33, lineWidthStatus: nil, lineColorStatus: nil, fillColorStatus: outerFillColorStatus)
            let innerFillColorStatus = GridPropertyStatus<UIColor>(normal: .lightGray, connect: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: .red)
            gridView.innerRoundConfig = RoundConfig(radius: 10, lineWidthStatus: nil, lineColorStatus: nil, fillColorStatus: innerFillColorStatus)
            return gridView
        }
        let lineView = ConnectLineView()
        lineView.lineColorStatus = .init(normal: colorWithRGBA(r: 18, g: 143, b: 235, a: 1), error: .red)
        lineView.lineWidth = 3
        connectLine = lineView
    }
}
