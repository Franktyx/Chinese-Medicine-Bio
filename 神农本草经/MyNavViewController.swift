//
//  MyNavViewController.swift
//  神农本草经
//
//  Created by Yuxiang Tang on 9/16/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit

class MyNavViewController: UINavigationController {

    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override init(rootViewController: UIViewController){
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nil, bundle: nil)
    }

    
}
