//
//  HomeCollectionViewCell.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/12/4.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var iconIV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.iconIV.layer.cornerRadius = 10
        self.iconIV.clipsToBounds = true
        
    }

}
