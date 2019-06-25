//
//  ConnectLineView.swift
//  JXPatternLock
//
//  Created by jiaxin on 2019/6/25.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import Foundation

class ConnectLineView: UIView, ConnectLine {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setStatus(_ status: ConnectLineStatus) {

    }
    func appendPoint(_ point: CGPoint) {

    }
}
