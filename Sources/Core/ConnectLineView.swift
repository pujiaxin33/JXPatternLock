//
//  ConnectLineView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

/// 所有的配置项都是静态配置，配置好之后再更新是没有效果的！！！
open class ConnectLineView: UIView, ConnectLine {
    public var lineColorStatus: ConnectLinePropertyStatus<UIColor> = .init(normal: .lightGray, error: .red)
    public var lineWidth: CGFloat = 3
    // lineColor和lineWidth通过上面属性配置，比如lineJoin、lineDashPattern等属性，通过该闭包自定义
    public var lineOtherConfig: ((CAShapeLayer) -> ())? {
        didSet {
            lineOtherConfig?(line)
        }
    }
    public var isTriangleHidden: Bool = true {
        didSet {
            if !isTriangleHidden {
                triangles = [CAShapeLayer]()
            }
        }
    }
    public var triangleColorStatus: ConnectLinePropertyStatus<UIColor> = .init(normal: .lightGray, error: .red)
    /// 距离GridView的中心偏移量
    public var triangleOffset: CGFloat = 20
    //   /\    -
    //  /  \   height
    //  ----   -
    // | width |
    public var triangleHeight: CGFloat = 8
    public var triangleWidth: CGFloat = 15

    private var currentPoint: CGPoint?
    private lazy var connectedGrids: [PatternLockGrid] = { [PatternLockGrid]() }()
    private var triangles: [CAShapeLayer]?
    private let line: CAShapeLayer = CAShapeLayer()
    private var currentStatus = ConnectLineStatus.normal

    deinit {
        lineOtherConfig = nil
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
        line.fillColor = nil
        line.lineJoin = .round
        line.lineCap = .round
        layer.addSublayer(line)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setStatus(_ status: ConnectLineStatus) {
        currentStatus = status
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        line.lineWidth = lineWidth
        line.strokeColor = lineColorStatus.map[status]?.cgColor
        triangles?.forEach { $0.fillColor = triangleColorStatus.map[status]?.cgColor }
        if status == .error {
            currentPoint = nil
            drawLine()
        }
        CATransaction.commit()
    }

    open func addGrid(_ grid: PatternLockGrid) {
        connectedGrids.append(grid)
        drawLine()
    }

    open func setCurrentPoint(_ point: CGPoint) {
        currentPoint = point
        drawLine()
    }

    open func reset() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        currentStatus = .normal
        currentPoint = nil
        line.path = nil
        connectedGrids.removeAll()
        triangles?.forEach { $0.removeFromSuperlayer() }
        triangles?.removeAll()
        setStatus(.normal)
        CATransaction.commit()
    }

    func drawLine() {
        guard !connectedGrids.isEmpty else {
            return
        }
        triangles?.forEach { $0.removeFromSuperlayer() }
        triangles?.removeAll()
        let path = UIBezierPath()
        for (index, gridView) in connectedGrids.enumerated() {
            if index == 0 {
                path.move(to: gridView.center)
            }else {
                path.addLine(to: gridView.center)
            }
            if !isTriangleHidden {
                if connectedGrids.count - 1 == index && currentPoint != nil {
                    //最后一个
                    addTriangle(from: gridView.center, to: currentPoint!)
                }else if connectedGrids.count > index + 1  {
                    let nextGridView = connectedGrids[index + 1]
                    addTriangle(from: gridView.center, to: nextGridView.center)
                }
            }

        }
        if currentPoint != nil {
            path.addLine(to: currentPoint!)
        }
        line.path = path.cgPath
    }

    private func addTriangle(from: CGPoint, to: CGPoint) {
        let triangle = CAShapeLayer()
        triangle.frame = CGRect(x: from.x, y: from.y - triangleWidth/2, width: triangleOffset + triangleHeight, height: triangleWidth)
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: triangleOffset, y: 0))
        trianglePath.addLine(to: CGPoint(x: triangle.bounds.width, y: triangle.bounds.height/2))
        trianglePath.addLine(to: CGPoint(x: triangleOffset, y: triangle.bounds.height))
        triangle.path = trianglePath.cgPath
        triangle.anchorPoint = CGPoint(x: 0, y: 0.5)
        triangle.frame.origin.x -= triangle.bounds.width/2
        triangle.fillColor = triangleColorStatus.map[currentStatus]?.cgColor

        let xDistance = to.x - from.x
        let yDistance = to.y - from.y
        let degress = atan2(yDistance, xDistance)
        triangle.setAffineTransform(CGAffineTransform(rotationAngle: degress))
        layer.addSublayer(triangle)
        triangles?.append(triangle)
    }
}
