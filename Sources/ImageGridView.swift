//
//  ImageGridView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/26.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class ImageGridView: UIView, PatternLockGrid {
    public var identifier: String = ""
    public var matrix: Matrix = Matrix.zero
    public var imageSize: CGSize = CGSize(width: 50, height: 50)
    public var imageStatus: GridPropertyStatus<UIImage>?
    public let imageView: UIImageView

    override init(frame: CGRect) {
        imageView = UIImageView()
        super.init(frame: frame)

        addSubview(imageView)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        imageView.bounds = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        imageView.center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        imageView.layer.cornerRadius = imageView.bounds.size.height/2
        imageView.layer.masksToBounds = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setStatus(_ status: GridStatus) {
        imageView.image = imageStatus?.map[status]
    }
}
