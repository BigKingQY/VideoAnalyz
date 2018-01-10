//
//  AddView.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/12/8.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit
import Masonry

class AddView: UIView {
    var backView = UIView()
    var closeBtn = UIButton(type: .custom)
    var titleLabel:UILabel = {()->UILabel in
        let label = UILabel()
        label.text = "添加"
        label.backgroundColor = UIColor.yellow
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        return label
    }()
    var segmentCotrol = UISegmentedControl(items: ["添加视频网址", "添加解析网址"])
    var nameTextField = UITextField()
    var urlTextField = UITextField()
    var urlIdTextField = UITextField()
    var sureBtn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadView()
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadView() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.addSubview(self.backView)
        self.backView.addSubview(self.closeBtn)
        self.backView.addSubview(self.titleLabel)
        self.backView.addSubview(self.segmentCotrol)
        self.backView.addSubview(self.nameTextField)
        self.backView.addSubview(self.urlTextField)
        self.backView.addSubview(self.urlIdTextField)
        self.backView.addSubview(sureBtn)
        
        self.backView.backgroundColor = .white
        self.closeBtn.tintColor = UIColor.darkGray
        self.closeBtn.layer.cornerRadius = 15
        self.closeBtn.clipsToBounds = true
        self.closeBtn.backgroundColor = UIColor.yellow
        self.closeBtn.setImage(UIImage(named: "ic_close"), for: .normal)

        self.segmentCotrol.selectedSegmentIndex = 0
        self.nameTextField.placeholder = "请输入网址名字"
        self.urlTextField.placeholder = "请输入网址"
        self.urlIdTextField.placeholder = "请输入解析网址地址栏id"
        self.sureBtn.setTitle("确定", for: .normal)
        self.sureBtn.backgroundColor = UIColor.yellow
        self.sureBtn.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.backView.mas_makeConstraints { (make) in
            make?.center.equalTo()(self)
            make?.width.equalTo()(280)
            make?.height.equalTo()(325)
        }
        self.closeBtn.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.backView)
            make?.right.equalTo()(self.backView)
            make?.width.equalTo()(30)
            make?.height.equalTo()(30)
        }
        self.titleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.backView)?.setOffset(30)
            make?.left.equalTo()(self.backView)?.setOffset(30)
            make?.right.equalTo()(self.backView)?.setOffset(-30)
            make?.height.equalTo()(25)
        }
        self.segmentCotrol.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.setOffset(20);
            make?.left.equalTo()(self.titleLabel);
            make?.right.equalTo()(self.titleLabel);
            make?.height.equalTo()(30);
        }

        self.nameTextField.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.segmentCotrol.mas_bottom)?.setOffset(20)
            make?.left.equalTo()(self.titleLabel)
            make?.right.equalTo()(self.titleLabel)
            make?.height.equalTo()(30)
        }
        self.urlTextField.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.nameTextField.mas_bottom)?.setOffset(15)
            make?.left.equalTo()(self.titleLabel)
            make?.right.equalTo()(self.titleLabel)
            make?.height.equalTo()(30)
        }
        self.urlIdTextField.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.urlTextField.mas_bottom)?.setOffset(15)
            make?.left.equalTo()(self.titleLabel)
            make?.right.equalTo()(self.titleLabel)
            make?.height.equalTo()(30)
        }
        self.sureBtn.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.backView)?.setOffset(-20)
            make?.left.equalTo()(self.titleLabel)
            make?.right.equalTo()(self.titleLabel)
            make?.height.equalTo()(40)
        }
        
    }
}
