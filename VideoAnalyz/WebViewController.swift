//
//  WebViewController.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/12/4.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit
import SVProgressHUD
import Masonry

class WebViewController: UIViewController, UIWebViewDelegate {

    
    var toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 44, width: UIScreen.main.bounds.size.width, height: 44))
    @IBOutlet weak var webView: UIWebView!
    lazy var dataArray: NSMutableArray = {()-> NSMutableArray in
        let arr = NSMutableArray(contentsOfFile: Bundle.main.path(forResource: "analyz.plist", ofType: nil)!)
        return arr!
    }()
    lazy var alertView:AlertView = {() ->AlertView in
        return AlertView(frame: self.view.bounds)
    }()
    var historyUrls:NSMutableArray = []
    var currentUrl: String? = nil
    var pasteboard: UIPasteboard = UIPasteboard(name: .general, create: true)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_web"), style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_refresh"), style: .plain, target: self, action: #selector(clickRefreshBtn))
   
        self.toolBar.backgroundColor = UIColor(red: 1, green: 217.0/255, blue: 68.0/255, alpha: 1)
        self.toolBar.tintColor = UIColor.darkGray
        
        let fixSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let item1 = UIBarButtonItem(image: UIImage(named: "ic_arrow_back"), style: .plain, target: self, action: #selector(clickBackBtn))
        let item2 = UIBarButtonItem(image: UIImage(named: "ic_arrow_forward"), style: .plain, target: self, action: #selector(clickPreBtn))
        let item3 = UIBarButtonItem(image: UIImage(named: "ic_menu"), style: .plain, target: self, action: #selector(clickMenuBtn))
        let item4 = UIBarButtonItem(image: UIImage(named: "ic_content_copy"), style: .plain, target: self, action: #selector(clickCopyBtn))
        let item5 = UIBarButtonItem(image: UIImage(named: "ic_build"), style: .plain, target: self, action: #selector(clickBuildBtn))
        let item6 = UIBarButtonItem(image: UIImage(named: "ic_home"), style: .plain, target: self, action: #selector(goBackHome))
        
        self.toolBar.items = [fixSpace, item1, fixSpace, item2, fixSpace, item3, fixSpace, item4, fixSpace, item5, fixSpace,item6, fixSpace]
        self.view.addSubview(self.toolBar)
        
        self.webView?.scrollView.bounces = true
        self.webView?.scrollView.showsHorizontalScrollIndicator = true
        self.webView?.scrollView.isScrollEnabled = true
        self.webView?.scalesPageToFit = true
        self.webView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(reseviedURL(_:)), name: NSNotification.Name(rawValue: "SelectUrlNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reseviedCancel), name: NSNotification.Name(rawValue: "SelectCancelNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    //MARK:--UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("shouldStartLoadWith")
        SVProgressHUD.dismiss()
        self.title = "开始加载网页..."
        
        return true
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.title = webView.stringByEvaluatingJavaScript(from: "document.location.href")!
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
        
        self.title = webView.stringByEvaluatingJavaScript(from: "document.location.href")!
//        self.title = webView.stringByEvaluatingJavaScript(from: "document.title")!
        self.currentUrl = webView.stringByEvaluatingJavaScript(from: "document.location.href")!
        if !self.historyUrls.contains(self.currentUrl as Any) {
            self.historyUrls.add(self.currentUrl as Any)
        }
        for i in 0..<self.dataArray.count {
            if (self.dataArray[i] as! NSDictionary).value(forKey: "url") as? String == self.currentUrl {
                let urlId = (self.dataArray[i] as! NSDictionary).value(forKey: "urlId") as? String
                self.webView?.stringByEvaluatingJavaScript(from: "document.getElementById('\(String(describing: urlId!))').value='\(String(describing: self.pasteboard.string!))';")
                break;
            }
        }
        
        
        //        if currentUrl == "http://www.5ifxw.com/vip/" {
        //            self.webView?.stringByEvaluatingJavaScript(from: "document.getElementById('url').value='\(String(describing: self.pasteboard.string!))';")
        //        }
    }
    
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        SVProgressHUD.dismiss()
        self.title = "加载出错了。什么破网络-_-!"
        print("didFailLoadWithError")
      
    }
    
    

    //MARK:--Click
    @objc func goBackHome() {
        let alterView = UIAlertController(title: "回主页\n", message: "确定要返回主页么？", preferredStyle: .alert)
        let ok = UIAlertAction(title: "确定", style: .default) { (_) in
            if self.webView.isLoading {
                self.webView.stopLoading()
            }
            if SVProgressHUD.isVisible() {
                SVProgressHUD.dismiss()
            }
            self.dismiss(animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alterView.addAction(ok)
        alterView.addAction(cancel)
        present(alterView, animated: true, completion: nil)
    }

    
    @objc func clickBackBtn() {
        if self.historyUrls.count > 0 {
            for i in 0..<self.historyUrls.count {
                if self.currentUrl == self.historyUrls[i] as? String {
                    if (i-1) >= 0 {
                       self.webView?.loadRequest(NSURLRequest(url: URL(string: self.historyUrls[i-1] as! String)!) as URLRequest)
                    }
                    
                }
                if self.currentUrl == self.historyUrls.firstObject as? String {
                    
                    SVProgressHUD.showError(withStatus: "前面已经没有了")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            }
        }
    }
    @objc func clickPreBtn() {
        if self.historyUrls.count > 0 {
            for i in 0..<self.historyUrls.count {
                if self.currentUrl == self.historyUrls[i] as? String {
                    if (i+1) <= self.historyUrls.count-1 {
                        self.webView?.loadRequest(NSURLRequest(url: URL(string: self.historyUrls[i+1] as! String)!) as URLRequest)
                    }
                }
                if self.currentUrl == self.historyUrls.lastObject as? String {
                    
                    SVProgressHUD.showError(withStatus: "后面已经没有了")
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            }
        }
    }
    @objc func clickRefreshBtn() {
        if self.webView.isLoading {
            self.webView.stopLoading()
        }
        self.webView?.loadRequest(NSURLRequest(url: URL(string: self.currentUrl!)!) as URLRequest)
    }
    @objc func clickMenuBtn() {
        SVProgressHUD.showInfo(withStatus: "别点了。这个功能还没想好做什么")
        SVProgressHUD.dismiss(withDelay: 1)
    }
    @objc func clickCopyBtn() {
        if self.currentUrl != nil {
            self.pasteboard.string = self.currentUrl
            
            SVProgressHUD.showSuccess(withStatus: "当前网址已复制到粘贴板")
            SVProgressHUD.dismiss(withDelay: 1)
        }
    }
    @objc func clickBuildBtn() {
        if self.currentUrl != nil{
            let arr = NSArray(contentsOfFile: Bundle.main.path(forResource: "analyz.plist", ofType: nil)!)
            let urlArr:NSMutableArray = []
            for dic in arr! {
                urlArr.add((dic as! NSDictionary).value(forKey: "url") as Any)
            }
            if !urlArr.contains(self.currentUrl as Any) {
                self.pasteboard.string = self.currentUrl
            }
        }
        UIView.animate(withDuration: 0.8) {
            self.view.alpha = 0.5
            UIApplication.shared.keyWindow?.addSubview(self.alertView)
        }
        
    }
    
    //MARK:--Notification
    @objc func reseviedURL(_ noti: Notification)  {
        if self.webView.isLoading {
            self.webView.stopLoading()
        }
        self.view.alpha = 1
        
        self.webView.loadRequest(URLRequest(url: URL(string: noti.userInfo?.values.first as! String)!))
    }
    
    @objc func reseviedCancel() {
        self.view.alpha = 1
    }
    
    @objc func deviceOrientationDidChange(_ orientation:UIDeviceOrientation) {
        self.toolBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 44, width: UIScreen.main.bounds.size.width, height: 44)
        self.alertView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    }
    
    
}
