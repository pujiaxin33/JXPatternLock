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
/// 不显示圆的Line时，把lineWidthStatus设置为nil即可。
/// fillColor更精细的配置示例：normal状态不显示，connect状态显示blue，error状态显示red。代码为：`GridPropertyStatus<UIColor>.init(normal: nil, connect: .blue, error: .red)`
public struct RoundConfig {
    public let radius: CGFloat?
    public let lineWidthStatus: GridPropertyStatus<CGFloat>?
    public let lineColorStatus: GridPropertyStatus<UIColor>?
    public let fillColorStatus: GridPropertyStatus<UIColor>?

    public init(radius: CGFloat? = nil, lineWidthStatus: GridPropertyStatus<CGFloat>? = nil, lineColorStatus: GridPropertyStatus<UIColor>? = nil, fillColorStatus: GridPropertyStatus<UIColor>? = nil) {
        self.radius = radius
        self.lineWidthStatus = lineWidthStatus
        self.lineColorStatus = lineColorStatus
        self.fillColorStatus = fillColorStatus
    }

    /// 类属性，所有状态都不显示的时候使用
    static public var empty = RoundConfig()
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
            outerRound.frame = CGRect(x: (bounds.size.width - (outerRadius * 2))/2, y: (bounds.size.height - (outerRadius * 2))/2, width: outerRadius * 2, height: outerRadius * 2)
            let outerPath = UIBezierPath(ovalIn: outerRound.bounds)
            outerRound.path = outerPath.cgPath
        }
        if let innerRadius = innerRoundConfig.radius {
            innerRound.frame = CGRect(x: (bounds.size.width - (innerRadius * 2))/2, y: (bounds.size.height - (innerRadius * 2))/2, width: innerRadius * 2, height: innerRadius * 2)
            let innerPath = UIBezierPath(ovalIn: innerRound.bounds)
            innerRound.path = innerPath.cgPath
        }
        CATransaction.commit()
    }

    open func setStatus(_ status: GridStatus) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        innerRound.lineWidth = innerRoundConfig.lineWidthStatus?.map[status] ?? 0
        innerRound.fillColor = innerRoundConfig.fillColorStatus?.map[status]?.cgColor
        innerRound.strokeColor = innerRoundConfig.lineColorStatus?.map[status]?.cgColor
        outerRound.lineWidth = outerRoundConfig.lineWidthStatus?.map[status] ?? 0
        outerRound.fillColor = outerRoundConfig.fillColorStatus?.map[status]?.cgColor
        outerRound.strokeColor = outerRoundConfig.lineColorStatus?.map[status]?.cgColor
        CATransaction.commit()
    }
}
