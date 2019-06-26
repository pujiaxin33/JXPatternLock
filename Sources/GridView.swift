//
//  GridView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/24.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

/// 圆的配置：
/// 不想要的配置设置为nil即可。
/// 比如不显示内圆时，把radius设置nil即可。
/// 不显示圆的strokeLine时，把strokeLineWidthStatus设置为你能即可。
/// fillColor更精细的配置示例：normal状态不显示，connect状态显示blue，error状态显示red。代码为：`GridPropertyStatus<UIColor>.init(normal: nil, connect: .blue, error: .red)`
public struct RoundConfig {
    public var radius: CGFloat?
    public var strokeLineWidthStatus: GridPropertyStatus<CGFloat>?
    public var fillColorStatus: GridPropertyStatus<UIColor>?
    public var strokeColorStatus: GridPropertyStatus<UIColor>?

    public init(radius: CGFloat?, strokeLineWidthStatus: GridPropertyStatus<CGFloat>?, fillColorStatus: GridPropertyStatus<UIColor>?, strokeColorStatus: GridPropertyStatus<UIColor>?) {
        self.radius = radius
        self.strokeLineWidthStatus = strokeLineWidthStatus
        self.fillColorStatus = fillColorStatus
        self.strokeColorStatus = strokeColorStatus
    }

    /// 类属性，所有状态都不显示的时候使用
    static public var empty: RoundConfig { return RoundConfig.init(radius: nil, strokeLineWidthStatus: nil, fillColorStatus: nil, strokeColorStatus: nil) }
}

open class GridView: UIView, PatternLockGrid {
    public var identifier: String = ""
    public var matrix: Matrix = Matrix.zero
    public var innerRoundConfig: RoundConfig = RoundConfig.empty
    public var outerRoundConfig: RoundConfig = RoundConfig.empty
    public let innerRound: CAShapeLayer
    public let outerRound: CAShapeLayer

    public override init(frame: CGRect) {
        outerRound = CAShapeLayer()
        innerRound = CAShapeLayer()
        super.init(frame: frame)

        backgroundColor = .clear
        //外圆的视图层级在下面，内圆的视图层级在上面
        layer.addSublayer(outerRound)
        layer.addSublayer(innerRound)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if let outerRadius = outerRoundConfig.radius {
            let outerRect = CGRect(x: (bounds.size.width - (outerRadius * 2))/2, y: (bounds.size.height - (outerRadius * 2))/2, width: outerRadius * 2, height: outerRadius * 2)
            let outerPath = UIBezierPath(ovalIn: outerRect)
            outerRound.path = outerPath.cgPath
        }
        if let innerRadius = innerRoundConfig.radius {
            let innerRect = CGRect(x: (bounds.size.width - (innerRadius * 2))/2, y: (bounds.size.height - (innerRadius * 2))/2, width: innerRadius * 2, height: innerRadius * 2)
            let innerPath = UIBezierPath(ovalIn: innerRect)
            innerRound.path = innerPath.cgPath
        }
        CATransaction.commit()
    }

    public func setStatus(_ status: GridStatus) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        innerRound.lineWidth = innerRoundConfig.strokeLineWidthStatus?.map[status] ?? 0
        innerRound.fillColor = innerRoundConfig.fillColorStatus?.map[status]?.cgColor
        innerRound.strokeColor = innerRoundConfig.strokeColorStatus?.map[status]?.cgColor
        outerRound.lineWidth = outerRoundConfig.strokeLineWidthStatus?.map[status] ?? 0
        outerRound.fillColor = outerRoundConfig.fillColorStatus?.map[status]?.cgColor
        outerRound.strokeColor = outerRoundConfig.strokeColorStatus?.map[status]?.cgColor
        CATransaction.commit()
    }
}
