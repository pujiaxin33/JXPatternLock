//
//  GridView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/24.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

public struct RoundPropertyStatus<T> {
    public var map: [GridStatus: T] = [GridStatus: T]()
//    public var normal: T?
//    public var connect: T?
//    public var error: T?
    public init(normal: T?, connect: T?, error: T?) {
//        self.normal = normal
//        self.connect = connect
//        self.error = error
        map[.normal] = normal
        map[.connect] = connect
        map[.error] = error
    }
}

public struct RoundConfig {
    public var radius: CGFloat
    public var strokeLineWidthStatus: RoundPropertyStatus<CGFloat>
    public var fillColorStatus: RoundPropertyStatus<UIColor>?
    public var strokeColorStatus: RoundPropertyStatus<UIColor>?

    public init(radius: CGFloat, strokeLineWidthStatus: RoundPropertyStatus<CGFloat>, fillColorStatus: RoundPropertyStatus<UIColor>?, strokeColorStatus: RoundPropertyStatus<UIColor>?) {
        self.radius = radius
        self.strokeLineWidthStatus = strokeLineWidthStatus
        self.fillColorStatus = fillColorStatus
        self.strokeColorStatus = strokeColorStatus
    }
}

open class GridView: UIView, PatternLockGrid {
    public var identifier: String = ""
    public var matrix: Matrix = Matrix.zero
    public var innerRoundConfig: RoundConfig = RoundConfig(radius: 10, strokeLineWidthStatus: RoundPropertyStatus<CGFloat>.init(normal: 1, connect: nil, error: nil), fillColorStatus: RoundPropertyStatus<UIColor>(normal: UIColor.lightGray, connect: UIColor.blue, error: UIColor.red), strokeColorStatus: nil)
    public var outerRoundConfig: RoundConfig = RoundConfig(radius: 20, strokeLineWidthStatus: RoundPropertyStatus<CGFloat>.init(normal: 0, connect: nil, error: nil), fillColorStatus: RoundPropertyStatus<UIColor>(normal: nil, connect: UIColor.blue.withAlphaComponent(0.3), error: UIColor.red.withAlphaComponent(0.3)), strokeColorStatus: nil)
    private var innerRound: CAShapeLayer!
    private var outerRound: CAShapeLayer!

    public override init(frame: CGRect) {
        super.init(frame: frame)

        //外圆的视图层级在下面，内圆的视图层级在上面
        outerRound = CAShapeLayer()
        layer.addSublayer(outerRound)
        innerRound = CAShapeLayer()
        layer.addSublayer(innerRound)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = bounds.size.height/2
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let outerRect = CGRect(x: (bounds.size.width - (outerRoundConfig.radius * 2))/2, y: (bounds.size.height - (outerRoundConfig.radius * 2))/2, width: outerRoundConfig.radius * 2, height: outerRoundConfig.radius * 2)
        let outerPath = UIBezierPath(ovalIn: outerRect)
        outerRound.path = outerPath.cgPath

        let innerRect = CGRect(x: (bounds.size.width - (innerRoundConfig.radius * 2))/2, y: (bounds.size.height - (innerRoundConfig.radius * 2))/2, width: innerRoundConfig.radius * 2, height: innerRoundConfig.radius * 2)
        let innerPath = UIBezierPath(ovalIn: innerRect)
        innerRound.path = innerPath.cgPath
        CATransaction.commit()
    }

    public func setStatus(_ status: GridStatus) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        innerRound.lineWidth = innerRoundConfig.strokeLineWidthStatus.map[status] ?? 0
        innerRound.fillColor = innerRoundConfig.fillColorStatus?.map[status]?.cgColor
        innerRound.strokeColor = innerRoundConfig.strokeColorStatus?.map[status]?.cgColor
        outerRound.lineWidth = outerRoundConfig.strokeLineWidthStatus.map[status] ?? 0
        outerRound.fillColor = outerRoundConfig.fillColorStatus?.map[status]?.cgColor
        outerRound.strokeColor = outerRoundConfig.strokeColorStatus?.map[status]?.cgColor
//        switch status {
//        case .normal:
//            innerRound.lineWidth = innerRoundConfig.strokeLineWidthStatus.normal ?? 0
//            innerRound.fillColor = innerRoundConfig.fillColorStatus?.normal?.cgColor
//            innerRound.strokeColor = innerRoundConfig.strokeColorStatus?.normal?.cgColor
//            outerRound.lineWidth = outerRoundConfig.strokeLineWidthStatus.normal ?? 0
//            outerRound.fillColor = outerRoundConfig.fillColorStatus?.normal?.cgColor
//            outerRound.strokeColor = outerRoundConfig.strokeColorStatus?.normal?.cgColor
//        case .connect:
//            innerRound.lineWidth = innerRoundConfig.strokeLineWidthStatus.connect ?? 0
//            innerRound.fillColor = innerRoundConfig.fillColorStatus?.connect?.cgColor
//            innerRound.strokeColor = innerRoundConfig.strokeColorStatus?.connect?.cgColor
//            outerRound.lineWidth = outerRoundConfig.strokeLineWidthStatus.connect ?? 0
//            outerRound.fillColor = outerRoundConfig.fillColorStatus?.connect?.cgColor
//            outerRound.strokeColor = outerRoundConfig.strokeColorStatus?.connect?.cgColor
//        case .error:
//            innerRound.lineWidth = innerRoundConfig.strokeLineWidthStatus.error ?? 0
//            innerRound.fillColor = innerRoundConfig.fillColorStatus?.error?.cgColor
//            innerRound.strokeColor = innerRoundConfig.strokeColorStatus?.error?.cgColor
//            outerRound.lineWidth = outerRoundConfig.strokeLineWidthStatus.error ?? 0
//            outerRound.fillColor = outerRoundConfig.fillColorStatus?.error?.cgColor
//            outerRound.strokeColor = outerRoundConfig.strokeColorStatus?.error?.cgColor
//        }
        CATransaction.commit()
    }
}
