//
//  RotateImageGridView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class RotateImageGridView: ImageGridView {

    public override func setStatus(_ status: GridStatus) {
        super.setStatus(status)

        switch status {
        case .normal:
            print("清除动画")
            imageView.layer.removeAllAnimations()
        case .connect:
            print("开启动画")
            let anim = CABasicAnimation(keyPath: "transform.rotation.z")
            anim.duration = 1
            anim.toValue = NSNumber(value: Float.pi * 2)
            anim.repeatCount = Float.infinity
            imageView.layer.add(anim, forKey: "rotate")
        case .error:
            print("nothing")
        }
    }

}
