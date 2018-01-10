//
//  AlertView.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/12/4.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit
import SVProgressHUD
import Masonry

class AlertView: UIView, UITableViewDelegate, UITableViewDataSource {

//    @IBOutlet var view: UIView!
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var cancelBtn: UIButton!
    
    let bgView:UIView = UIView()
    let backView:UIView = UIView()
    let tableView:UITableView = UITableView()
    let titleLabel:UILabel = UILabel()
    let cancelBtn:UIButton = UIButton(type: .custom)
    
    
    lazy var dataArray: NSMutableArray = {()-> NSMutableArray in
        let arr = NSMutableArray(contentsOfFile: Bundle.main.path(forResource: "analyz.plist", ofType: nil)!)
        return arr!
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        loadFromXib()
        self.setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        loadFromXib()
        self.setView()
        fatalError("init(coder:) has not been implemented")
    }
//    
//    override func layoutSubviews() {
//        self.setView()
//        self.layoutIfNeeded()
//    }
    
    func setView() {
        self.addSubview(self.bgView)
        self.backView.addSubview(self.titleLabel)
        self.backView.addSubview(self.tableView)
        self.backView.addSubview(self.cancelBtn)
        self.addSubview(self.backView)
        self.backView.backgroundColor = .white
        self.cancelBtn.setTitle("取消", for: .normal)
        self.cancelBtn.addTarget(self, action: #selector(clickCancel(_:)), for: .touchUpInside)
        self.cancelBtn.titleLabel?.textColor = .black
        self.titleLabel.text = "选择要解析的网址"
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.backgroundColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1)
    
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.cancelBtn.layer.backgroundColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1).cgColor
        self.cancelBtn.layer.cornerRadius = 5
        
        self.backView.mas_makeConstraints { (make) in
            make?.height.equalTo()(325)
            make?.centerY.equalTo()(self)
            make?.left.equalTo()(self)?.setOffset(40)
            make?.right.equalTo()(self)?.setOffset(-40)
           make?.centerX.equalTo()(self)
        }
        
        self.bgView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self)
            make?.left.equalTo()(self)
            make?.right.equalTo()(self)
            make?.bottom.equalTo()(self)
        }
        self.titleLabel.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.backView)?.setOffset(20)
            make?.left.equalTo()(self.backView)?.setOffset(20)
            make?.right.equalTo()(self.backView)?.setOffset(-20)
            make?.height.equalTo()(40)
        }
        self.tableView.mas_makeConstraints { (make) in
            make?.top.equalTo()(self.titleLabel.mas_bottom)?.setOffset(20)
            make?.left.equalTo()(self.backView)
            make?.right.equalTo()(self.backView)
            make?.bottom.equalTo()(self.cancelBtn.mas_top)?.setOffset(-20)
        }
        self.cancelBtn.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.backView)?.setOffset(30)
            make?.right.equalTo()(self.backView)?.setOffset(-30)
            make?.height.equalTo()(40)
            make?.bottom.equalTo()(self.backView)?.setOffset(-20)
        }
    }
    
//    func loadFromXib() -> Void {
//        view = Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)?.last as! UIView
//        self.addSubview(view)
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.tableFooterView = UIView()
//        self.cancelBtn.layer.backgroundColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1).cgColor
//        self.cancelBtn.layer.cornerRadius = 5
//    }
    
    //MARK:--DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let dic = self.dataArray[indexPath.row] as! NSDictionary
        cell.textLabel?.text = dic.value(forKey: "urlName") as? String
        cell.textLabel?.textAlignment = NSTextAlignment.center
        
        return cell
    }
    
    //MARK:--Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.row != self.dataArray.count - 1 {
            let dic = self.dataArray[indexPath.row] as! NSDictionary
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectUrlNotification"), object: nil, userInfo: ["url":dic.value(forKey: "url") as Any])
            SVProgressHUD.show()
            self.removeFromSuperview()
        }else {
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    
    @objc func clickCancel(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SelectCancelNotification"), object: nil, userInfo: nil)
        self.removeFromSuperview()
        
    }
    
    
}
