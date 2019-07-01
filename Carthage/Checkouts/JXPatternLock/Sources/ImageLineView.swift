//
//  ImageLineView.swift
//  Example
//
//  Created by jiaxin on 2019/6/27.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

open class ImageLineView: UIView, ConnectLine {
    private let imageStatus: ConnectLinePropertyStatus<UIImage>
    private var grids = [PatternLockGrid]()
    private var imageViews = [UIImageView]()
    private var currenPoint: CGPoint?
    private var currentStatus = ConnectLineStatus.normal

    public init(imageStatus: ConnectLinePropertyStatus<UIImage>) {
        self.imageStatus = imageStatus
        super.init(frame: .zero)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setStatus(_ status: ConnectLineStatus) {
        currentStatus = status
        if status == .error {
            currenPoint = nil
            drawLine()
        }
    }

    public func addGrid(_ grid: PatternLockGrid) {
        grids.append(grid)
        drawLine()
    }

    public func setCurrentPoint(_ point: CGPoint) {
        currenPoint = point
        drawLine()
    }

    public func reset() {
        currentStatus = .normal
        grids.removeAll()
        currenPoint = nil
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
    }

    func drawLine() {
        imageViews.forEach { $0.removeFromSuperview() }
        imageViews.removeAll()
        for (index, grid) in grids.enumerated() {
            var nextGrid: PatternLockGrid?
            if index + 1 < grids.count {
                nextGrid = grids[index + 1]
            }
            if let nextGrid = nextGrid {
                addLine(from: grid.center, to: nextGrid.center)
            }else if currenPoint != nil {
                addLine(from: grid.center, to: currenPoint!)
            }
        }
    }

    private func addLine(from: CGPoint, to: CGPoint) {
        let image = imageStatus.map[currentStatus]
        let imageView = UIImageView(image: image?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .tile))
        imageView.layer.allowsEdgeAntialiasing = true
        imageView.layer.contentsScale = UIScreen.main.scale
        let xDistance = Double(to.x - from.x)
        let yDistance = Double(to.y - from.y)
        let hypotenuse = sqrt((pow(xDistance, 2) + pow(yDistance, 2)))
        let imageHeight = (image?.size.height ?? 0) / UIScreen.main.scale
        imageView.frame = CGRect(x: from.x, y: from.y - imageHeight / 2, width: CGFloat(hypotenuse), height: imageHeight)
        let degress = atan2(yDistance, xDistance)
        imageView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        imageView.frame.origin.x -= imageView.bounds.size.width/2
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat(degress))
        addSubview(imageView)
        imageViews.append(imageView)
    }
}
