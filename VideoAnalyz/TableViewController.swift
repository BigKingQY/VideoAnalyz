//
//  TableViewController.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/11/30.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit
import SVProgressHUD

class TableViewController: UITableViewController, UIWebViewDelegate {
    var urlNames:Array = ["全民vip视频在线解析", "爱奇艺、乐视、腾讯优酷视频解析(推荐)", "疯狂VIP解析", "添加解析网址"]
    let urls:Array = ["http://www.qmaile.com/",
                      "http://www.5ifxw.com/vip/",
                      "http://www.v718.com/",
                      "https://www.baidu.com/"]
    var videoNames:Array = ["爱奇艺", "土豆", "优酷", "腾讯", "搜狐", "添加视频网址"]
    let videoUrls:Array = ["http://www.iqiyi.com/",
                           "http://www.tudou.com/",
                           "http://www.youku.com/",
                           "https://v.qq.com/",
                           "http://www.sohu.com/"]
    var webView: UIWebView?
    var textField: UITextField?
    var backView: UIView?
    let goBtn = UIButton(type: .custom)
    let preBtn = UIButton(type: .custom)
    let nextBtn = UIButton(type: .custom)
    var historyUrls:NSMutableArray = []
    var currentUrl: String? = nil
    var pasteboard: UIPasteboard = UIPasteboard(name: .general, create: true)!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频解析"
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.navigationController?.navigationBar.isTranslucent = false
        self.tableView.register(UINib.init(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.tableFooterView = UIView()
        self.tableView.alwaysBounceVertical = true
        self.webView = UIWebView.init(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.webView?.delegate = self
        self.webView?.scrollView.bounces = true
        self.webView?.scrollView.showsHorizontalScrollIndicator = true
        self.webView?.scrollView.isScrollEnabled = true
        self.webView?.scalesPageToFit = true
        self.textField = UITextField.init(frame: CGRect(x: 80, y: 0, width: UIScreen.main.bounds.size.width - 150, height: 40))
        self.textField?.placeholder = "正在获取网址..."
        self.backView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        self.backView?.backgroundColor = .white
        self.goBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 5, width: 60, height: 30)
        self.goBtn.setTitle("立即解析", for: .normal)
        self.goBtn.addTarget(self, action: #selector(clickGoBtn), for: .touchUpInside)
        self.goBtn.setTitleColor(.black, for: .normal)
        self.goBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.goBtn.layer.borderColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1).cgColor
        self.goBtn.layer.borderWidth = 2
        self.goBtn.layer.cornerRadius = 5
        
        self.preBtn.frame = CGRect(x: 10, y: 5, width: 30, height: 30)
        self.preBtn.tintColor = UIColor.darkGray
        self.preBtn.setImage(UIImage(named: "ic_arrow_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.preBtn.setImage(UIImage(named: "ic_arrow_back")?.withRenderingMode(.alwaysOriginal), for: .selected)
        self.preBtn.isSelected = true
        self.preBtn.isEnabled = false
        self.preBtn.addTarget(self, action: #selector(clickPreBtn), for: .touchUpInside)
        self.preBtn.imageView?.contentMode = .scaleAspectFit
        self.preBtn.layer.borderWidth = 2
        self.preBtn.layer.cornerRadius = 5
        self.preBtn.layer.borderColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1).cgColor
        
        self.nextBtn.frame = CGRect(x: 45, y: 5, width: 30, height: 30)
        self.nextBtn.tintColor = UIColor.darkGray
        self.nextBtn.setImage(UIImage(named: "ic_arrow_forward")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.nextBtn.setImage(UIImage(named: "ic_arrow_forward")?.withRenderingMode(.alwaysOriginal), for: .selected)
        self.nextBtn.isSelected = true
        self.nextBtn.isEnabled = false
        self.nextBtn.addTarget(self, action: #selector(clickNextBtn), for: .touchUpInside)
        self.nextBtn.imageView?.contentMode = .scaleAspectFit
        self.nextBtn.layer.borderWidth = 2
        self.nextBtn.layer.cornerRadius = 5
        self.nextBtn.layer.borderColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1).cgColor
        
        self.backView?.addSubview(self.goBtn)
        self.backView?.addSubview(self.preBtn)
        self.backView?.addSubview(self.nextBtn)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "回主页", style: .plain, target: self, action: #selector(clickRightItem))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.darkGray, NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)], for: .normal)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let statusView = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.main.bounds.width, height: 20))
        statusView.backgroundColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1)
        self.navigationController?.navigationBar.addSubview(statusView)
        NotificationCenter.default.addObserver(self, selector: #selector(receiverNotification), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.videoNames.count
        }else {
            return self.urlNames.count
        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
//
//        if indexPath.section == 0 {
//            cell.detailLabel.text = self.videoNames[indexPath.row]
//        }else {
//            cell.detailLabel.text = self.urlNames[indexPath.row]
//        }
        
        return cell
    }
 
    //MARK:--TabelViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            if (indexPath.row == self.videoNames.count-1) {
                self.addVideoAlertView()
            }else {
                self.loadUrlWithWebView(indexPath: indexPath)
            }
        }
        if (indexPath.section == 1) {
            if (indexPath.row == self.urlNames.count-1) {
                
            }else {
                self.loadUrlWithWebView(indexPath: indexPath)
            }
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func addVideoAlertView()  {
        let alertView = UIAlertController(title: "添加视频网址", message: "", preferredStyle: .alert)
        alertView.addTextField { (nameTextField) in
            nameTextField.placeholder = "请输入网址名字"
            }
        alertView.addTextField { (urlTextField) in
            urlTextField.placeholder = "请输入网址地址"

        }
        let ok = UIAlertAction(title: "确定", style: .default) { (action) in
            
            self.videoNames.insert("1234", at: self.videoNames.count - 1)
            let standardfault = UserDefaults.standard
            standardfault.set(self.videoNames, forKey: "videoNames")
            standardfault.synchronize()
            
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alertView.addAction(ok)
        alertView.addAction(cancel)
        present(alertView, animated: true, completion: nil)
    }
    
    func loadUrlWithWebView(indexPath: IndexPath) {
         SVProgressHUD.show()
        if !self.view.subviews.contains(self.webView!) {
            self.backView?.addSubview(self.textField!)
            self.backView?.addSubview(self.webView!)
            self.view.addSubview(self.backView!)
        }
        
        let queue = DispatchQueue.global()
        queue.async {
//            SVProgressHUD.show()
            self.webView?.stopLoading()
            if indexPath.section == 0 {
                self.webView?.loadRequest(NSURLRequest(url: URL(string: self.videoUrls[indexPath.row])!) as URLRequest)
            }else {
                self.webView?.loadRequest(NSURLRequest(url: URL(string: self.urls[indexPath.row])!) as URLRequest)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            let str = "视频网址"
            let title = NSMutableAttributedString(string: str, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)])
            
            return title.string
        }else {
            let str = "解析网址"
            let title = NSMutableAttributedString(string: str, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)])
            
            return title.string
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
  
    
    //MARK:--Click
    @objc func clickRightItem() {
        self.webView?.stopLoading()
        if self.view.subviews.contains(self.backView!) {
            self.webView?.stopLoading()
            self.backView?.removeFromSuperview()
        }else {
            let alterView = UIAlertController(title: "操作错误\n", message: "已经是主页了啊！！别闹！！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "确定", style: .default, handler: nil)
            alterView.addAction(ok)
            present(alterView, animated: true, completion: nil)
        }
    }
    
    @objc func clickGoBtn() {
        let alertView = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        for i in 0..<self.urlNames.count {
            let action = UIAlertAction(title: self.urlNames[i], style: .default, handler: { (alert) in

                self.pasteboard.string = self.textField?.text
                self.webView?.stopLoading()
                
                self.webView?.loadRequest(NSURLRequest(url: URL(string: self.urls[i])!) as URLRequest)
            })
            alertView.addAction(action)
        }
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertView.addAction(action)
        
        present(alertView, animated: true, completion: nil)
        
        
    }
    
    @objc func clickPreBtn () {
        if self.historyUrls.count != 0 {
            for i in 0..<self.historyUrls.count {
                if self.currentUrl == self.historyUrls[i] as? String {
                    if i - 1 >= 0 {
                        self.preBtn.isSelected = false
                        self.preBtn.isEnabled = true
                        self.nextBtn.isSelected = false
                        self.nextBtn.isEnabled = true
                        self.webView?.stopLoading()
                        self.webView?.loadRequest(URLRequest(url: URL(string: self.historyUrls[i-1] as! String)!))
                    }else {
                        self.preBtn.isSelected = true
                        self.preBtn.isEnabled = false
                    }
                }
            }
        }
    }
    
    @objc func clickNextBtn () {
        if self.historyUrls.count != 0 {
            for i in 0..<self.historyUrls.count {
                if self.currentUrl == self.historyUrls[i] as? String {
                    if (i + 1) < (self.historyUrls.count) {
                        self.nextBtn.isSelected = false
                        self.nextBtn.isEnabled = true
                        self.webView?.stopLoading()
                        self.webView?.loadRequest(URLRequest(url: URL(string: self.historyUrls[i+1] as! String)!))
                    }else {
                        self.nextBtn.isSelected = true
                        self.nextBtn.isEnabled = false
                    }
                }
            }
        }
    }
    
    
    //MARK:--Notification
    @objc func receiverNotification()  {
        self.webView?.frame = CGRect(x: 0, y: 40, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.textField?.frame = CGRect(x: 80, y: 0, width: UIScreen.main.bounds.size.width - 150, height: 40)
        self.backView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        self.goBtn.frame = CGRect(x: UIScreen.main.bounds.size.width - 70, y: 5, width: 60, height: 30)
        
    }
    
    //MARK:--UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("shouldStartLoadWith")
        self.textField?.text = "开始加载网页..."
        return true
    }
    
  
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.textField?.text = webView.stringByEvaluatingJavaScript(from: "document.location.href")!
        print("webViewDidStartLoad")
    }
    

    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webView.stringByEvaluatingJavaScript(from: """
        var viewPortTag=document.createElement('meta');
            viewPortTag.id='viewport';
            viewPortTag.name = 'viewport';
            viewPortTag.content = 'width=%d; initial-scale=0.5; maximum-scale=2; user-scalable=true; minimal-ui=false;';
            document.getElementsByTagName('head')[0].appendChild(viewPortTag);", (int)authWebView.bounds.size.width)
""")
        
        print("webViewDidFinishLoad")
        SVProgressHUD.dismiss()
        self.textField?.text = webView.stringByEvaluatingJavaScript(from: "document.location.href")!
        self.currentUrl = self.textField?.text
        if !self.historyUrls.contains(self.textField?.text! as Any) {
            self.historyUrls.add(self.textField?.text! as Any)
        }
        if self.historyUrls.count > 1 {
            self.preBtn.isEnabled = true
            self.preBtn.isSelected = false
        }
        if self.historyUrls.lastObject as? String == self.currentUrl {
            self.nextBtn.isEnabled = false
            self.nextBtn.isSelected = true
        }
        if self.historyUrls.firstObject as? String == self.currentUrl {
            self.preBtn.isEnabled = false
            self.preBtn.isSelected = true
        }
        if self.urls.contains(self.currentUrl!) {
            for i in 0..<self.urls.count {
                switch i {
                case 0:
                    self.webView?.stringByEvaluatingJavaScript(from: "document.getElementById('sos').value='\(String(describing: self.pasteboard.string!))';")
                    
                case 1, 2:
                    self.webView?.stringByEvaluatingJavaScript(from: "document.getElementById('url').value='\(String(describing: self.pasteboard.string!))';")
                default:
                    break
                }
            }
        }
        
//        if currentUrl == "http://www.5ifxw.com/vip/" {
//            self.webView?.stringByEvaluatingJavaScript(from: "document.getElementById('url').value='\(String(describing: self.pasteboard.string!))';")
//        }
    }
    
 
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        SVProgressHUD.dismiss()
        self.textField?.text = "加载出错了。什么破网络-_-!"
        print("didFailLoadWithError")
    }
    
}
