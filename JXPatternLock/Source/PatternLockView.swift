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

    public static func == (lhs: Matrix, rhs: Matrix) -> Bool {
        if lhs.row == rhs.row && lhs.column == rhs.column {
            return true
        }
        return false
    }

    public static var zero: Matrix { return Matrix(row: 0, column: 0) }

    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
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

public protocol PatternLockGridView: UIView {
    var matrix: Matrix { set get }
    func setStatus(_ status: GridStatus)
}

public protocol ConnectLine: UIView {
    func appendPoint(_ point: CGPoint)
    func setStatus(_ status: ConnectLineStatus)
}

//typealias PatternLockGridView = PatternLockGrid & UIView

public protocol PatternLockViewConfig {
    var matrix: Matrix { get }
    var gridSize: CGSize { get }
    func lockView(_ lockView: PatternLockView, gridViewAt matrix: Matrix) -> PatternLockGridView
    func lineColor(in lockView: PatternLockView) -> UIColor
    func lineWidth(in lockView: PatternLockView) -> CGFloat
}

public protocol PatternLockViewDelegate: AnyObject {
    func locakView(_ lockView: PatternLockView, didConnectedGridAt matrix: Matrix)
    func shouldShowErrorBeforeConnectCompleted(_ lockView: PatternLockView) -> Bool
    func connectDidCompleted(_ lockView: PatternLockView)
}

open class PatternLockView: UIView {
    public weak var delegate: PatternLockViewDelegate?
    private let matrix: Matrix
    private let gridSize: CGSize
    /// 强引用，请勿让持有PatternLockView的类遵从PatternLockViewConfig，这会造成循环引用。请使用一个单独的类来遵从PatternLockViewConfig协议。
    private let config: PatternLockViewConfig
    private lazy var gridViews: [PatternLockGridView] = { [PatternLockGridView]() }()
    private lazy var connectedGridViews: [PatternLockGridView] = { [PatternLockGridView]() }()
    private var currentPoint: CGPoint?
    private lazy var line: CAShapeLayer = { CAShapeLayer() }()

    public init(config: PatternLockViewConfig) {
        self.matrix = config.matrix
        self.gridSize = config.gridSize
        self.config = config
        super.init(frame: CGRect.zero)

        for rowIndex in 0..<matrix.row {
            for columnIndex in 0..<matrix.column {
                let gridView =  config.lockView(self, gridViewAt: Matrix(row: rowIndex, column: columnIndex))
                gridView.matrix = Matrix(row: rowIndex, column: columnIndex)
                addSubview(gridView)
                gridViews.append(gridView)
            }
        }
        line.strokeColor = config.lineColor(in: self).cgColor
        line.lineWidth = config.lineWidth(in: self)
        line.fillColor = nil
        layer.insertSublayer(line, at: 0)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        var horizantalSpacing: CGFloat = 0
        if matrix.column > 1 {
            horizantalSpacing = (bounds.size.width - CGFloat(matrix.column) * gridSize.width)/CGFloat(matrix.column - 1)
        }
        var verticalSpacing: CGFloat = 0
        if matrix.row > 1 {
            verticalSpacing = (bounds.size.width - CGFloat(matrix.row) * gridSize.height)/CGFloat(matrix.row - 1)
        }
        gridViews.forEach { (gridView) in
            gridView.frame = CGRect(x: CGFloat(gridView.matrix.column) * (horizantalSpacing + gridSize.width), y: CGFloat(gridView.matrix.row) * (verticalSpacing + gridSize.height), width: gridSize.width, height: gridSize.height)
        }
    }

    func drawLine() {
        let path = UIBezierPath()
        for (index, gridView) in connectedGridViews.enumerated() {
            if index == 0 {
                path.move(to: gridView.center)
            }else {
                path.addLine(to: gridView.center)
            }
        }
        if currentPoint != nil {
            path.addLine(to: currentPoint!)
        }
        line.path = path.cgPath
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
        guard let point = touches.randomElement()?.location(in: self) else {
            return
        }
        currentPoint = point
        drawLine()
        var currentGridView: PatternLockGridView?
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
            currentGridView?.setStatus(.connect)
            delegate?.locakView(self, didConnectedGridAt: currentGridView!.matrix)
        }
    }

    private func touchesDidEnded() {
        if delegate?.shouldShowErrorBeforeConnectCompleted(self) == true {
            connectedGridViews.forEach { $0.setStatus(.error) }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            line.strokeColor = UIColor.red.cgColor
            CATransaction.commit()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                self.connectDidCompleted()
            }
        }else {
            connectDidCompleted()
        }
    }

    private func connectDidCompleted() {
        connectedGridViews.forEach { $0.setStatus(.normal) }
        connectedGridViews.removeAll()
        currentPoint = nil
        line.path = nil
        line.strokeColor = self.config.lineColor(in: self).cgColor
        delegate?.connectDidCompleted(self)
    }
}
