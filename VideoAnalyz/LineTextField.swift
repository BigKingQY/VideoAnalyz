//
//  LineTextField.swift
//  WuliuSiJi
//
//  Created by Administrator on 2017/11/23.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit

class LineTextField: UITextField {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.black.cgColor)
        context?.fill(CGRect(x: 0, y: self.frame.height - 0.5, width: self.frame.width, height: 0.5))
    }
}
