//
//  AddViewController.swift
//  VideoAnalyz
//
//  Created by Administrator on 2017/12/8.
//  Copyright © 2017年 Administrator. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    var segment: UISegmentedControl?
    let backView = UIView()
    var nameTextField:UITextField?
    var urlTextField:UITextField?
    var urlIdTextField:UITextField?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
