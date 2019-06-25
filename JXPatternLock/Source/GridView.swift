//
//  GridView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/24.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

public struct ColorConfig {
    public var normalColor: UIColor?
    public var connectColor: UIColor?
    public var errorColor: UIColor?
    public init(normalColor: UIColor?, connectColor: UIColor?, errorColor: UIColor?) {
        self.normalColor = normalColor
        self.connectColor = connectColor
        self.errorColor = errorColor
    }
    public static var empty: ColorConfig = { ColorConfig.init(normalColor: nil, connectColor: nil, errorColor: nil) }()
}

public struct RoundConfig {
    public var radius: CGFloat
    public var strokeLineWidth: CGFloat
    public var fillColorConfig: ColorConfig
    public var strokeColorConfig: ColorConfig
    public init(radius: CGFloat, strokeLineWidth: CGFloat, fillColorConfig: ColorConfig, strokeColorConfig: ColorConfig) {
        self.radius = radius
        self.strokeLineWidth = strokeLineWidth
        self.fillColorConfig = fillColorConfig
        self.strokeColorConfig = strokeColorConfig
    }
//    public var normalFillColor: UIColor
//    public var connectedFillColor: UIColor
//    public var errorFillColor: UIColor
//    public var normalStrokeColor: UIColor
//    public var connectedStrokeColor: UIColor
//    public var errorStrokeColor: UIColor
}

open class GridView: UIView, PatternLockGridView {
    public var matrix: Matrix = Matrix.zero
    public var innerRoundConfig: RoundConfig = RoundConfig(radius: 10, strokeLineWidth: 0, fillColorConfig: ColorConfig(normalColor: UIColor.lightGray, connectColor: UIColor.blue, errorColor: UIColor.red), strokeColorConfig: ColorConfig.empty)
    public var outerRoundConfig: RoundConfig = RoundConfig(radius: 20, strokeLineWidth: 0, fillColorConfig: ColorConfig(normalColor: nil, connectColor: UIColor.blue.withAlphaComponent(0.3), errorColor: UIColor.red.withAlphaComponent(0.3)), strokeColorConfig: ColorConfig.empty)
    private var innerRound: CAShapeLayer!
    private var outerRound: CAShapeLayer!


    public override init(frame: CGRect) {
        super.init(frame: frame)

        //外圆的视图层级在下面，内圆的视图层级在上面
        outerRound = CAShapeLayer()
        layer.addSublayer(outerRound)
        innerRound = CAShapeLayer()
        layer.addSublayer(innerRound)
        setStatus(.normal)
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
        switch status {
        case .normal:
            innerRound.fillColor = innerRoundConfig.fillColorConfig.normalColor?.cgColor
            innerRound.strokeColor = innerRoundConfig.strokeColorConfig.normalColor?.cgColor
            outerRound.fillColor = outerRoundConfig.fillColorConfig.normalColor?.cgColor
            outerRound.strokeColor = outerRoundConfig.strokeColorConfig.normalColor?.cgColor
        case .connect:
            innerRound.fillColor = innerRoundConfig.fillColorConfig.connectColor?.cgColor
            innerRound.strokeColor = innerRoundConfig.strokeColorConfig.connectColor?.cgColor
            outerRound.fillColor = outerRoundConfig.fillColorConfig.connectColor?.cgColor
            outerRound.strokeColor = outerRoundConfig.strokeColorConfig.connectColor?.cgColor
        case .error:
            innerRound.fillColor = innerRoundConfig.fillColorConfig.errorColor?.cgColor
            innerRound.strokeColor = innerRoundConfig.strokeColorConfig.errorColor?.cgColor
            outerRound.fillColor = outerRoundConfig.fillColorConfig.errorColor?.cgColor
            outerRound.strokeColor = outerRoundConfig.strokeColorConfig.errorColor?.cgColor
        }
        CATransaction.commit()
    }
}
