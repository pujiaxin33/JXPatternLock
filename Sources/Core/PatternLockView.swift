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
    public var map: [GridStatus: T] = [GridStatus: T]()
    public init(normal: T?, connect: T?, error: T?) {
        map[.normal] = normal
        map[.connect] = connect
        map[.error] = error
    }
}

/// ConnectLine不同的状态显示不同的参数
public struct ConnectLinePropertyStatus<T> {
    public var map: [ConnectLineStatus: T] = [ConnectLineStatus: T]()
    public init(normal: T?, error: T?) {
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
    var matrix: Matrix { get }
    var gridSize: CGSize { get }
    var connectLine: ConnectLine? { get }
    var connectLineHierarchy: ConnectLineHierarchy { get }
    var errorDisplayDuration: TimeInterval { get }
    var initGridClosure: (Matrix) -> (PatternLockGrid) { get }
}

public protocol PatternLockViewDelegate: AnyObject {
    func lockView(_ lockView: PatternLockView, didConnectedGrid grid: PatternLockGrid)
    func lockViewShouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool
    func lockViewDidConnectCompleted(_ lockView: PatternLockView)
}

open class PatternLockView: UIView {
    public weak var delegate: PatternLockViewDelegate?
    internal let config: PatternLockViewConfig
    internal lazy var gridViews: [PatternLockGrid] = { [PatternLockGrid]() }()
    internal lazy var connectedGridViews: [PatternLockGrid] = { [PatternLockGrid]() }()
    private var isTaskDelaying = false

    public init(config: PatternLockViewConfig) {
        self.config = config
        super.init(frame: CGRect.zero)

        for rowIndex in 0..<config.matrix.row {
            for columnIndex in 0..<config.matrix.column {
                let gridView =  config.initGridClosure(Matrix(row: rowIndex, column: columnIndex))
                gridView.setStatus(.normal)
                gridView.matrix = Matrix(row: rowIndex, column: columnIndex)
                gridView.identifier = "\(gridView.matrix.row * config.matrix.column + gridView.matrix.column)"
                addSubview(gridView)
                gridViews.append(gridView)
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
        gridViews.forEach { (gridView) in
            gridView.frame = CGRect(x: CGFloat(gridView.matrix.column) * (horizantalSpacing + config.gridSize.width), y: CGFloat(gridView.matrix.row) * (verticalSpacing + config.gridSize.height), width: config.gridSize.width, height: config.gridSize.height)
        }
        config.connectLine?.frame = bounds
    }

    //MARK: - Event
    @objc public func reset() {
        isTaskDelaying = false
        connectedGridViews.forEach { $0.setStatus(.normal) }
        connectedGridViews.removeAll()
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
        var currentGridView: PatternLockGrid?
        for gridView in gridViews {
            if gridView.frame.contains(point) {
                currentGridView = gridView
                break
            }
        }
        guard currentGridView != nil  else {
            return
        }
        let isContain = connectedGridViews.contains { (gridView) -> Bool in
            if gridView.matrix == currentGridView?.matrix {
                return true
            }else {
                return false
            }
        }
        if !isContain {
            connectedGridViews.append(currentGridView!)
            config.connectLine?.addGrid(currentGridView!)
            currentGridView?.setStatus(.connect)
            delegate?.lockView(self, didConnectedGrid: currentGridView!)
        }
    }

    private func touchesDidEnded() {
        if delegate?.lockViewShouldShowErrorBeforeConnectCompleted(self) == true {
            connectedGridViews.forEach { $0.setStatus(.error) }
            config.connectLine?.setStatus(.error)
            isTaskDelaying = true
            delegate?.lockViewDidConnectCompleted(self)
            perform(#selector(reset), with: nil, afterDelay: config.errorDisplayDuration, inModes: [RunLoop.Mode.common])
        }else {
            reset()
            delegate?.lockViewDidConnectCompleted(self)
        }
    }
}
