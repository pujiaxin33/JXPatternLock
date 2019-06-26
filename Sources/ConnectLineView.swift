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
    public var lineNormalColor: UIColor = UIColor.lightGray
    public var lineErrorColor: UIColor = UIColor.red
    public var lineWidth: CGFloat = 3
    public var isTriangleHidden: Bool = true {
        didSet {
            if !isTriangleHidden {
                triangles = [CAShapeLayer]()
            }
        }
    }
    public var triangleNormalColor: UIColor = UIColor.lightGray
    public var triangleErrorColor: UIColor = UIColor.red
    /// 距离GridView的中心偏移量
    public var triangleOffset: CGFloat = 20
    //   /\    -
    //  /  \   height
    //  ----   -
    // | width |
    public var triangleHeight: CGFloat = 8
    public var triangleWidth: CGFloat = 15

    private var currentPoint: CGPoint?
    private lazy var connectedGridViews: [PatternLockGrid] = { [PatternLockGrid]() }()
    private var triangles: [CAShapeLayer]?
    private let line: CAShapeLayer = CAShapeLayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
        line.fillColor = nil
        layer.addSublayer(line)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setStatus(_ status: ConnectLineStatus) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        line.lineWidth = lineWidth
        switch status {
            case .normal:
                line.strokeColor = lineNormalColor.cgColor
                triangles?.forEach { $0.fillColor = triangleNormalColor.cgColor }
            case .error:
                currentPoint = nil
                drawLine()
                line.strokeColor = lineErrorColor.cgColor
                triangles?.forEach { $0.fillColor = triangleErrorColor.cgColor }
        }
        CATransaction.commit()
    }

    public func addGrid(_ grid: PatternLockGrid) {
        connectedGridViews.append(grid)
        drawLine()
    }

    public func addPoint(_ point: CGPoint) {
        currentPoint = point
        drawLine()
    }

    public func reset() {
        currentPoint = nil
        line.path = nil
        connectedGridViews.removeAll()
        triangles?.forEach { $0.removeFromSuperlayer() }
        triangles?.removeAll()
        setStatus(.normal)
    }

    func drawLine() {
        guard connectedGridViews.isEmpty == false else {
            return
        }
        triangles?.forEach { $0.removeFromSuperlayer() }
        triangles?.removeAll()
        let path = UIBezierPath()
        for (index, gridView) in connectedGridViews.enumerated() {
            if index == 0 {
                path.move(to: gridView.center)
            }else {
                path.addLine(to: gridView.center)
            }
            if !isTriangleHidden {
                if connectedGridViews.count - 1 == index && currentPoint != nil {
                    //最后一个
                    addTriangle(from: gridView.center, to: currentPoint!)
                }else if connectedGridViews.count > index + 1  {
                    let nextGridView = connectedGridViews[index + 1]
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
        trianglePath.fill()
        triangle.path = trianglePath.cgPath
        triangle.anchorPoint = CGPoint(x: 0, y: 0.5)
        triangle.frame.origin.x -= triangle.bounds.width/2
        triangle.fillColor = triangleNormalColor.cgColor

        let xDistance = to.x - from.x
        let yDistance = to.y - from.y
        let degress = atan2(yDistance, xDistance)
        triangle.setAffineTransform(CGAffineTransform(rotationAngle: degress))
        layer.addSublayer(triangle)
        triangles?.append(triangle)
    }
}
