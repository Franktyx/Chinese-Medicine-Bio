//
//  MyTableViewCell.swift
//  神农本草经
//
//  Created by Yuxiang Tang on 9/17/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit


protocol TableViewCellDelegate {
    func cellDidBeginEditing(editingCell: MyTableViewCell)
    func cellDidEndEditing(editingCell: MyTableViewCell)
}

class MyTableViewCell: UITableViewCell {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var myDelegate: TableViewCellDelegate?
    var myButton: UIButton!
    var checkDetail: UIButton!
    
    var herbDes: UILabel!
    var herbTitle: UILabel!

    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.myButton = UIButton(frame: CGRectMake(0, 0, self.screenWidth, self.bounds.height))
        self.myButton.addTarget(self, action: "showData:", forControlEvents: UIControlEvents.TouchUpInside)
        self.myButton.backgroundColor = UIColor.clearColor()
        //self.addSubview(self.myButton)
        
        self.herbTitle = UILabel(frame: CGRectMake(25, 5, 70, 50))
        self.herbTitle.textAlignment = .Left
        self.herbTitle.font = UIFont.systemFontOfSize(18)
        //self.herbTitle.backgroundColor = UIColor.redColor()
        self.addSubview(self.herbTitle)
        
        self.herbDes = UILabel(frame: CGRectMake(80, 5, 230, 50))
        self.herbDes.textColor = UIColor.blackColor()
        self.herbDes.textAlignment = NSTextAlignment.Left
        self.herbDes.font = UIFont.systemFontOfSize(13)
        //self.herbDes.font = UIFont(name: "Helvetica Neue", size: 14)
        //self.herbDes.backgroundColor = UIColor.redColor()
        self.herbDes.numberOfLines = 0
        self.addSubview(self.herbDes)
        
        self.checkDetail = UIButton(frame: CGRectMake(self.bounds.width, 10, 20, 20))
        self.checkDetail.setBackgroundImage(UIImage(named: "arrow"), forState: UIControlState.Normal)
        //self.checkDetail.setTitle("注解", forState: UIControlState.Normal)
        self.checkDetail.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.checkDetail.layer.cornerRadius = 5
        self.checkDetail.clipsToBounds = true
        self.checkDetail.backgroundColor = UIColor.clearColor()
        self.addSubview(self.checkDetail)
        
        self.backgroundColor = UIColor(red: 224 / 255, green: 238 / 255, blue: 232 / 255, alpha: 1.0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.herbDes.sizeToFit()
    }
    
    func showData(sender: UIButton){
        if self.myDelegate != nil {
            self.myDelegate!.cellDidBeginEditing(self)
        } else {
            println("myDelegate is nil")
        }
    }
    
    
    
}
