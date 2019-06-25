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

public enum GridStatus {
    case normal
    case connect
    case error
}

public enum ConnectLineStatus {
    case normal
    case error
}

public protocol PatternLockGrid: UIView {
    var matrix: Matrix { set get }
    var identifier: String { set get }
    func setStatus(_ status: GridStatus)
}

public protocol ConnectLine: UIView {
    func setStatus(_ status: ConnectLineStatus)
    func addGrid(_ grid: PatternLockGrid)
    func addPoint(_ point: CGPoint)
    func reset()
}

public protocol PatternLockViewConfig {
    var matrix: Matrix { get }
    var gridSize: CGSize { get }
    var connectLine: ConnectLine { get }
    var gridViewClosure: (Matrix) -> (PatternLockGrid) { get }
}

public protocol PatternLockViewDelegate: AnyObject {
    func locakView(_ lockView: PatternLockView, didConnectedGrid grid: PatternLockGrid)
    func shouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool
    func connectDidCompleted(_ lockView: PatternLockView)
}

open class PatternLockView: UIView {
    public weak var delegate: PatternLockViewDelegate?
    /// 单位秒
    public var errorDisplayDuration: TimeInterval = 0.25
    /// 强引用，请勿让持有PatternLockView的类遵从PatternLockViewConfig，这会造成循环引用。请使用一个单独的类来遵从PatternLockViewConfig协议。
    public let config: PatternLockViewConfig
    internal lazy var gridViews: [PatternLockGrid] = { [PatternLockGrid]() }()
    internal lazy var connectedGridViews: [PatternLockGrid] = { [PatternLockGrid]() }()
    private var isTaskDelaying = false

    public init(config: PatternLockViewConfig) {
        self.config = config
        super.init(frame: CGRect.zero)

        for rowIndex in 0..<config.matrix.row {
            for columnIndex in 0..<config.matrix.column {
                let gridView =  config.gridViewClosure(Matrix(row: rowIndex, column: columnIndex))
                gridView.setStatus(.normal)
                gridView.matrix = Matrix(row: rowIndex, column: columnIndex)
                gridView.identifier = "\(gridView.matrix.row * config.matrix.column + gridView.matrix.column)"
                addSubview(gridView)
                gridViews.append(gridView)
            }
        }

        config.connectLine.setStatus(.normal)
        addSubview(config.connectLine)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(connectDidCompleted), object: nil)
        }
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
    }

    //MARK: - Event
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
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(connectDidCompleted), object: nil)
//            resetStatus()
//            isTaskDelaying = false
            connectDidCompleted()
        }

        guard let point = touches.randomElement()?.location(in: self) else {
            return
        }
        config.connectLine.addPoint(point)
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
            config.connectLine.addGrid(currentGridView!)
            currentGridView?.setStatus(.connect)
            delegate?.locakView(self, didConnectedGrid: currentGridView!)
        }
    }

    private func touchesDidEnded() {
        if delegate?.shouldShowErrorBeforeConnectCompleted(self) == true {
            connectedGridViews.forEach { $0.setStatus(.error) }
            config.connectLine.setStatus(.error)
            isTaskDelaying = true
            perform(#selector(connectDidCompleted), with: nil, afterDelay: errorDisplayDuration, inModes: [RunLoop.Mode.common])
        }else {
            connectDidCompleted()
        }
    }

    @objc private func connectDidCompleted() {
        isTaskDelaying = false
        resetStatus()
        delegate?.connectDidCompleted(self)
    }

    private func resetStatus() {
        connectedGridViews.forEach { $0.setStatus(.normal) }
        connectedGridViews.removeAll()
        config.connectLine.reset()
    }
}
