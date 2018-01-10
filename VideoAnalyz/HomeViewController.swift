//
//  HomeViewController.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/12/8.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit
import SVProgressHUD
import Masonry

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var collectionView:UICollectionView?
    lazy var dataArray: NSMutableArray = {()-> NSMutableArray in
        let arr = NSMutableArray(contentsOfFile: Bundle.main.path(forResource: "video.plist", ofType: nil)!)
        return arr!
    }()
    var webView: UIWebView?
    var backView: UIView?
    var toolBarView:UIView = UIView()
    var addBtn = UIButton(type: .system)
    lazy var addVC:AddView = {()-> AddView in
        return AddView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "视频解析"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_info"), style: .plain, target: self, action: #selector(clickRightItem))
        self.setView()
    }

    func setView()  {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 100, height: 80)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = (UIScreen.main.bounds.size.width - layout.itemSize.width * 3 - 20) / 3
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-44), collectionViewLayout: layout)
        self.collectionView?.backgroundColor = .white
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.view.addSubview(self.collectionView!)
        self.view.addSubview(self.toolBarView)
        self.toolBarView.addSubview(self.addBtn)
        self.toolBarView.backgroundColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1)
        
        self.addBtn.setImage(UIImage(named: "ic_add"), for: .normal)
        self.addBtn.setTitle("添加", for: .normal)
        self.addBtn.tintColor = UIColor.darkGray
        self.addBtn.addTarget(self, action: #selector(clickAddBtn(_:)), for: .touchUpInside)
        self.collectionView?.mas_makeConstraints({ (make) in
            make?.top.equalTo()(self.view)
            make?.left.equalTo()(self.view)
            make?.right.equalTo()(self.view)
            make?.bottom.equalTo()(self.view)?.setOffset(-44)
        })
        self.toolBarView.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.view)
            make?.right.equalTo()(self.view)
            make?.bottom.equalTo()(self.view)
            make?.height.equalTo()(44)
        }
        self.addBtn.mas_makeConstraints { (make) in
            make?.center.equalTo()(self.toolBarView)
            make?.height.equalTo()(self.toolBarView)
            make?.width.equalTo()(self.toolBarView)
        }
    }

    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        let dic = self.dataArray[indexPath.row] as! NSDictionary
        cell.iconIV.image = UIImage(named: dic.value(forKey: "logo") as! String)
        cell.title.text = dic.value(forKey: "urlName") as? String
        
        return cell
    }
    
    //MARK:--UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.loadUrlWithWebView(indexPath: indexPath)
    }
    
    //MARK:--Custom_Function
    func addVideoAlertView()  {
        let alertView = UIAlertController(title: "添加视频网址", message: "", preferredStyle: .alert)
        alertView.addTextField { (nameTextField) in
            nameTextField.placeholder = "请输入网址名字"
        }
        alertView.addTextField { (urlTextField) in
            urlTextField.placeholder = "请输入网址地址"
            
        }
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            
            self.dataArray.insert("1234", at: self.dataArray.count - 1)
            let standardfault = UserDefaults.standard
            standardfault.set(self.dataArray, forKey: "videoNames")
            standardfault.synchronize()
            
            self.collectionView?.reloadData()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alertView.addAction(ok)
        alertView.addAction(cancel)
        present(alertView, animated: true, completion: nil)
    }
    
    func loadUrlWithWebView(indexPath: IndexPath) {
        SVProgressHUD.show()
        let webVC = WebViewController(nibName: "WebViewController", bundle: nil)
        let dic = self.dataArray[indexPath.row] as! NSDictionary
        
        present(UINavigationController(rootViewController: webVC), animated: true) {
            
            webVC.webView.loadRequest(URLRequest(url: URL(string: dic.value(forKey: "url") as! String)!))
        }
    }
    
    //MARK:--Click
    @objc func clickRightItem() {
        
    }
    
    @objc func clickClose() {
        self.addVC.removeFromSuperview()
        self.view.alpha = 1;
    }
    
    @objc func clickSure() {
        
    }
    
    @objc func clickAddBtn(_ sender: UIButton) {
        self.addVC.sureBtn.addTarget(self, action: #selector(clickSure), for: .touchUpInside)
        self.addVC.closeBtn.addTarget(self, action: #selector(clickClose), for: .touchUpInside)
        self.view.alpha = 0.5
        UIApplication.shared.keyWindow?.addSubview(self.addVC)
    }
    
}
