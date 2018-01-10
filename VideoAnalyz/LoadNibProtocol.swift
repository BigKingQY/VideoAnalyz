//
//  LoadNibProtocol.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/12/4.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import Foundation


protocol LoadNibProtocol {
}
extension LoadNibProtocol where Self : UIView {
    //在协议里面不允许定义class 只能定义static
    static func loadNib(_ nibNmae :String? = nil) -> Self{
        print("\(self)")
        return Bundle.main.loadNibNamed(nibNmae ?? "\(self)", owner: nil, options: nil)?.first as! Self
    }
}

