//
//  IndividualViewController.swift
//  神农本草经
//
//  Created by Yuxiang Tang on 10/9/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit


class IndividualViewController: UIViewController {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var mainScrollView: UIScrollView!
    
    var herbName: String!
    var herbTitle: UILabel!
    var herbDes: UILabel!
    var herbQuotes: UILabel!
    
    var herbType: UIButton!
    var herbQuality: UIButton!
    
    var backCard: UIView!
    
    var rootViewController = RootViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationItem.title = self.herbName
        
        self.mainScrollView = UIScrollView(frame: CGRectMake(0, 0, self.screenWidth, self.screenHeight))
        self.mainScrollView.backgroundColor = self.rootViewController.getCellColor(self.herbName)
        self.view.addSubview(self.mainScrollView)
        
        self.backCard = UIView(frame: CGRectMake(10, 74, self.screenWidth - 20, self.screenHeight - 20 - 64))
        self.backCard.backgroundColor = UIColor(white: 1.0, alpha: 0.4)
        self.backCard.layer.cornerRadius = 10
        self.backCard.clipsToBounds = true
        self.view.addSubview(self.backCard)
        
        self.herbTitle = UILabel(frame: CGRectMake(60, 30, 200, 40))
        self.herbTitle.text = self.herbName
        self.herbTitle.layer.cornerRadius = 5
        self.herbTitle.clipsToBounds = true
//        self.herbTitle.layer.borderColor = UIColor.blueColor().CGColor
//        self.herbTitle.layer.borderWidth = 2.0
        self.herbTitle.font = UIFont.boldSystemFontOfSize(16)
        self.herbTitle.numberOfLines = 0
        self.herbTitle.frame.size.height = self.rootViewController.heightForLabel(self.herbName, font: UIFont.boldSystemFontOfSize(16), width: 200)
        self.backCard.addSubview(self.herbTitle)
        
        self.herbQuality = UIButton(frame: CGRectMake(280, 30, 50, 30))
        self.herbQuality.backgroundColor = UIColor(red: 33 / 255, green: 166 / 255, blue: 117 / 255, alpha: 0.8)
        self.herbQuality.layer.cornerRadius = 10
        self.herbQuality.clipsToBounds = true
        self.herbQuality.setTitle("上品", forState: UIControlState.Normal)
        self.herbQuality.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        self.herbQuality.titleLabel?.textAlignment = .Center
        self.herbQuality.layer.borderWidth = 3
        self.herbQuality.layer.borderColor = UIColor.clearColor().CGColor
        
        self.herbQuality.layer.shadowColor = UIColor.blackColor().CGColor
        self.herbQuality.layer.shadowOffset = CGSizeMake(0, 3)
        self.herbQuality.layer.shadowRadius = 10
        self.herbQuality.layer.shadowOpacity = 1.0
        self.backCard.addSubview(self.herbQuality)
        
        self.herbType = UIButton(frame: CGRectMake(280, 65, 50, 30))
        self.herbType.backgroundColor = UIColor(red: 228 / 255, green: 198 / 255, blue: 208 / 255, alpha: 0.8)
        self.herbType.layer.cornerRadius = 10
        self.herbType.clipsToBounds = true
        self.herbType.setTitle("玉石", forState: UIControlState.Normal)
        self.herbType.titleLabel?.font = UIFont.boldSystemFontOfSize(13)
        self.herbType.titleLabel?.textAlignment = .Center
        
        self.herbType.layer.shadowOpacity = 1.0
        self.herbType.layer.shadowColor = UIColor.lightGrayColor().CGColor
        self.herbType.layer.shadowRadius = 10
        self.herbType.layer.shadowOffset = CGSizeMake(0, 3)

        self.backCard.addSubview(self.herbType)
        
        self.herbDes = UILabel(frame: CGRectMake(self.screenWidth / 2 - 150, 100, 300, 100))
        self.herbDes.text = herbData[herbName]
        self.herbDes.font = UIFont.systemFontOfSize(15)
        self.herbDes.numberOfLines = 0
        self.herbDes.frame.size.height = self.rootViewController.heightForLabel(herbData[herbName]!, font: UIFont.systemFontOfSize(15), width: 300)
        self.backCard.addSubview(self.herbDes)
        
        self.herbQuotes = UILabel(frame: CGRectMake(self.screenWidth / 2 - 150, self.herbDes.frame.origin.y + self.herbDes.frame.height + 10, 300, 100))
        self.herbQuotes.text = herbQuoteData[herbName]
        self.herbQuotes.font = UIFont.systemFontOfSize(15)
        self.herbQuotes.numberOfLines = 0
        
        self.herbQuotes.frame.size.height = self.rootViewController.heightForLabel(herbQuoteData[self.herbName]!, font: UIFont.systemFontOfSize(15), width: 300)
        self.backCard.addSubview(self.herbQuotes)
        
    }
}
