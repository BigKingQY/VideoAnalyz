//
//  HomeCollectionViewController.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/12/4.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit
import SVProgressHUD
import Masonry


private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController {
    
    lazy var dataArray: NSMutableArray = {()-> NSMutableArray in
        let arr = NSMutableArray(contentsOfFile: Bundle.main.path(forResource: "video.plist", ofType: nil)!)
        
        return arr!
    }()
    var webView: UIWebView?
    var backView: UIView?
    var toolBarView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        
//        collectionView?.collectionViewLayout = layout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        let layout = UICollectionViewFlowLayout.init()
//        layout.itemSize = CGSize(width: 100, height: 80)
//        layout.minimumInteritemSpacing = 15
//        layout.minimumLineSpacing = (UIScreen.main.bounds.size.width - layout.itemSize.width * 3 - 20) / 3
//        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
//        collectionView?.collectionViewLayout = layout
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavigationBar()
    
        // Register cell classes
        self.collectionView!.register(UINib.init(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        
    }
    
    
    func setNavigationBar() {
        self.title = "视频解析"
        self.collectionView?.backgroundColor = .white
        
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.dataArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HomeCollectionViewCell
        let dic = self.dataArray[indexPath.row] as! NSDictionary
        cell.iconIV.image = UIImage(named: dic.value(forKey: "logo") as! String)
        cell.title.text = dic.value(forKey: "urlName") as? String
    
        return cell
    }
    
    //MARK:--UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
    
    
    
    
}
