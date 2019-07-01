//
//  ShadowGridView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class ShadowGridView: GridView {
    public var shadowOpacityStatus: GridPropertyStatus<Float> = GridPropertyStatus<Float>.init(normal: nil, connect: 0.6, error: 0.6)
    public var shadowColorStatus: GridPropertyStatus<UIColor> = GridPropertyStatus<UIColor>.init(normal: nil, connect: .black, error: .red)
    public var shadowOffset: CGSize = CGSize.zero
    public var shadowRadius: CGFloat = 5

    override open func setStatus(_ status: GridStatus) {
        super.setStatus(status)

        outerRound.shadowOffset = shadowOffset
        outerRound.shadowRadius = shadowRadius
        outerRound.shadowOpacity = shadowOpacityStatus.map[status] ?? 0
        outerRound.shadowColor = shadowColorStatus.map[status]?.cgColor
    }
}
