//
//  RotateImageGridView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class RotateImageGridView: ImageGridView {
    public var animationDuration: TimeInterval = 1

    public override func setStatus(_ status: GridStatus) {
        super.setStatus(status)

        switch status {
        case .normal:
            imageView.layer.removeAllAnimations()
            break
        case .connect:
            let anim = CABasicAnimation(keyPath: "transform.rotation.z")
            anim.duration = CFTimeInterval(animationDuration)
            anim.toValue = NSNumber(value: Float.pi * 2)
            anim.repeatCount = Float.infinity
            imageView.layer.add(anim, forKey: "rotate")
        case .error:
            break
        }
    }

}
