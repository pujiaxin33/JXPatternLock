//
//  PatternLockView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/21.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

public struct Matrix: Equatable {
    let row: Int
    let column: Int
    public static var zero: Matrix { return Matrix(row: 0, column: 0) }
    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
    public static func == (lhs: Matrix, rhs: Matrix) -> Bool {
        if lhs.row == rhs.row && lhs.column == rhs.column {
            return true
        }
        return false
    }
}

/// Grid不同的状态显示不同的参数
public struct GridPropertyStatus<T> {
    public private(set) var map: [GridStatus: T] = [GridStatus: T]()
    public init(normal: T? = nil, connect: T? = nil, error: T? = nil) {
        map[.normal] = normal
        map[.connect] = connect
        map[.error] = error
    }
}

/// ConnectLine不同的状态显示不同的参数
public struct ConnectLinePropertyStatus<T> {
    public private(set) var map: [ConnectLineStatus: T] = [ConnectLineStatus: T]()
    public init(normal: T? = nil, error: T? = nil) {
        map[.normal] = normal
        map[.error] = error
    }
}

public enum GridStatus {
    case normal
    case connect
    case error
}

public enum ConnectLineStatus {
    case normal
    case error
}

public enum ConnectLineHierarchy {
    case top
    case bottom
}

public protocol PatternLockGrid: UIView {
    var matrix: Matrix { set get }
    var identifier: String { set get }
    func setStatus(_ status: GridStatus)
}

public protocol ConnectLine: UIView {
    func setStatus(_ status: ConnectLineStatus)
    func setCurrentPoint(_ point: CGPoint)
    func addGrid(_ grid: PatternLockGrid)
    func reset()
}

public protocol PatternLockViewConfig {
    var matrix: Matrix { set get }
    var gridSize: CGSize { set get }
    var connectLineHierarchy: ConnectLineHierarchy { set get }
    /// 是否允许两次连接点之间相交的点被自动连接，举例：水平依次连接(0,1)、(0,2)坐标的点，中间坐标为(0,1)的点，为true就被自动连接。
    var autoMediumGridsConnect: Bool { set get }
    var connectLine: ConnectLine? { set get }
    var errorDisplayDuration: TimeInterval { set get }
    var initGridClosure: (Matrix) -> (PatternLockGrid) { set get }
}

public protocol PatternLockViewDelegate: AnyObject {
    func lockView(_ lockView: PatternLockView, didConnectedGrid grid: PatternLockGrid)
    func lockViewShouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool
    func lockViewDidConnectCompleted(_ lockView: PatternLockView)
}

open class PatternLockView: UIView {
    public weak var delegate: PatternLockViewDelegate?
    internal let config: PatternLockViewConfig
    internal lazy var grids: [PatternLockGrid] = { [PatternLockGrid]() }()
    internal lazy var connectedGrids: [PatternLockGrid] = { [PatternLockGrid]() }()
    private var isTaskDelaying = false

    public init(config: PatternLockViewConfig) {
        self.config = config
        super.init(frame: CGRect.zero)

        for rowIndex in 0..<config.matrix.row {
            for columnIndex in 0..<config.matrix.column {
                let grid =  config.initGridClosure(Matrix(row: rowIndex, column: columnIndex))
                grid.setStatus(.normal)
                grid.matrix = Matrix(row: rowIndex, column: columnIndex)
                grid.identifier = "\(grid.matrix.row * config.matrix.column + grid.matrix.column)"
                addSubview(grid)
                grids.append(grid)
            }
        }

        if config.connectLine != nil {
            config.connectLine?.setStatus(.normal)
            if config.connectLineHierarchy == .top {
                addSubview(config.connectLine!)
            }else {
                insertSubview(config.connectLine!, at: 0)
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        var horizantalSpacing: CGFloat = 0
        if config.matrix.column > 1 {
            horizantalSpacing = (bounds.size.width - CGFloat(config.matrix.column) * config.gridSize.width)/CGFloat(config.matrix.column - 1)
        }
        var verticalSpacing: CGFloat = 0
        if config.matrix.row > 1 {
            verticalSpacing = (bounds.size.width - CGFloat(config.matrix.row) * config.gridSize.height)/CGFloat(config.matrix.row - 1)
        }
        grids.forEach { (grid) in
            grid.frame = CGRect(x: CGFloat(grid.matrix.column) * (horizantalSpacing + config.gridSize.width), y: CGFloat(grid.matrix.row) * (verticalSpacing + config.gridSize.height), width: config.gridSize.width, height: config.gridSize.height)
        }
        config.connectLine?.frame = bounds
    }

    //MARK: - Event
    @objc public func reset() {
        isTaskDelaying = false
        connectedGrids.forEach { $0.setStatus(.normal) }
        connectedGrids.removeAll()
        config.connectLine?.reset()
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesDidChanged(touches)
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesDidChanged(touches)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesDidEnded()
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesDidEnded()
    }

    private func touchesDidChanged(_ touches: Set<UITouch>) {
        if isTaskDelaying {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reset), object: nil)
            reset()
        }

        guard let point = touches.randomElement()?.location(in: self) else {
            return
        }
        config.connectLine?.setCurrentPoint(point)
        var currentGrid: PatternLockGrid?
        for grid in grids {
            if grid.frame.contains(point) {
                currentGrid = grid
                break
            }
        }
        guard currentGrid != nil else {
            return
        }
        let isContain = connectedGrids.contains { (grid) -> Bool in
            if grid.matrix == currentGrid?.matrix {
                return true
            }else {
                return false
            }
        }
        if !isContain {
            //判断当前点和上一个点之间有没有点（仅是在一条直线上的点）
            if config.autoMediumGridsConnect && connectedGrids.last != nil {
                let tempGrids = mediumGrids(from: connectedGrids.last!.matrix, endMatrix: currentGrid!.matrix)
                if tempGrids != nil {
                    connectedGrids.append(contentsOf: tempGrids!)
                    for tempGrid in tempGrids! {
                        config.connectLine?.addGrid(tempGrid)
                        tempGrid.setStatus(.connect)
                        delegate?.lockView(self, didConnectedGrid: tempGrid)
                    }
                }
            }
            connectedGrids.append(currentGrid!)
            config.connectLine?.addGrid(currentGrid!)
            currentGrid?.setStatus(.connect)
            delegate?.lockView(self, didConnectedGrid: currentGrid!)
        }
    }

    private func touchesDidEnded() {
        if delegate?.lockViewShouldShowErrorBeforeConnectCompleted(self) == true {
            connectedGrids.forEach { $0.setStatus(.error) }
            config.connectLine?.setStatus(.error)
            isTaskDelaying = true
            delegate?.lockViewDidConnectCompleted(self)
            perform(#selector(reset), with: nil, afterDelay: config.errorDisplayDuration, inModes: [RunLoop.Mode.common])
        }else {
            reset()
            delegate?.lockViewDidConnectCompleted(self)
        }
    }

    private func mediumGrids(from startMatrix: Matrix, endMatrix: Matrix) -> [PatternLockGrid]? {
        guard abs(endMatrix.row - startMatrix.row) > 1 || abs(endMatrix.column - startMatrix.column) > 1 else {
            return nil
        }
        let mediumRowIndex = abs(endMatrix.row - startMatrix.row)
        let mediumColumnIndex = abs(endMatrix.column - startMatrix.column)
        if mediumColumnIndex != 0 && mediumRowIndex != 0 && mediumRowIndex != mediumColumnIndex {
            return nil
        }
        let mediumCount = max(mediumRowIndex - 1, mediumColumnIndex - 1)
        var resultMatrixs = [Matrix]()
        if endMatrix.column > startMatrix.column {
            if endMatrix.row > startMatrix.row {
                //endMatrix在右下方
                for index in 1...mediumCount {
                    resultMatrixs.append(Matrix(row: startMatrix.row + index, column: startMatrix.column + index))
                }
            }else if endMatrix.row == startMatrix.row {
                //endMatrix在水平方向右方
                for index in 1...mediumCount {
                    resultMatrixs.append(Matrix(row: startMatrix.row, column: startMatrix.column + index))
                }
            }else {
                //endMatrix在右上方
                for index in 1...mediumCount {
                    resultMatrixs.append(Matrix(row: startMatrix.row - index, column: startMatrix.column + index))
                }
            }
        }else if endMatrix.column == startMatrix.column {
            if endMatrix.row > startMatrix.row {
                //endMatrix在垂直方向上方
                for index in 1...mediumCount {
                    resultMatrixs.append(Matrix(row: startMatrix.row + index, column: startMatrix.column))
                }
            }else {
                //endMatrix在垂直方向下方
                for index in 1...mediumCount {
                    resultMatrixs.append(Matrix(row: startMatrix.row - index, column: startMatrix.column))
                }
            }
        }else {
            if endMatrix.row > startMatrix.row {
                //endMatrix在左下方
                for index in 1...mediumCount {
                    resultMatrixs.append(Matrix(row: startMatrix.row + index, column: startMatrix.column - index))
                }
            }else if endMatrix.row == startMatrix.row {
                //endMatrix在水平方向左方
                for index in 1...mediumCount {
                    resultMatrixs.append(Matrix(row: startMatrix.row, column: startMatrix.column - index))
                }
            }else {
                //endMatrix在左上方
                for index in 1...mediumCount {
                    resultMatrixs.append(Matrix(row: startMatrix.row - index, column: startMatrix.column - index))
                }
            }
        }
        let connectedMatixs = connectedGrids.map { $0.matrix }
        return grids.filter { (grid) -> Bool in
            if resultMatrixs.contains(grid.matrix) {
                if !connectedMatixs.contains(grid.matrix) {
                    return true
                }
            }
            return false
        }
    }
}
