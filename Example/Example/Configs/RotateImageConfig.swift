//
//  RotateImageConfig.swift
//  Example
//
//  Created by jiaxin on 2019/7/2.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation
import JXPatternLock

struct RotateImageConfig: PatternLockViewConfig {
    var matrix: Matrix = Matrix(row: 3, column: 3)
    var gridSize: CGSize = CGSize(width: 70, height: 70)
    var connectLine: ConnectLine?
    var autoMediumGridsConnect: Bool = false
    var connectLineHierarchy: ConnectLineHierarchy = .bottom
    var errorDisplayDuration: TimeInterval = 1
    var initGridClosure: (Matrix) -> (PatternLockGrid)

    init() {
        let tintColor = colorWithRGBA(r: 118, g: 218, b: 208, a: 1)
        initGridClosure = {(matrix) -> PatternLockGrid in
            let gridView = RotateImageGridView()
            gridView.imageStatus = GridPropertyStatus<UIImage>.init(normal: UIImage(named: "jinitaimei.jpg"), connect: UIImage(named: "jinitaimei.jpg"), error: UIImage(named: "jinitaimei.jpg"))
            return gridView
        }
        let lineView = ConnectLineView()
        lineView.lineColorStatus = .init(normal: tintColor, error: .red)
        lineView.lineWidth = 3
        connectLine = lineView
    }
}
