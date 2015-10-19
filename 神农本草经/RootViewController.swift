//
//  RootViewController.swift
//  神农本草经
//
//  Created by Yuxiang Tang on 9/16/15.
//  Copyright (c) 2015 Yuxiang Tang. All rights reserved.
//

import UIKit
import CoreData


class RootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    
    //var searchBar: UISearchBar!
    var searchController: UISearchController!
    var mainTableView: UITableView!
    var tableViewCellIdentifier = "cell1"
    var selectedRowIndex: Int!
    var selectedSection: Int!
    var currentCellLabelHeight: CGFloat!
    var enableCell = true
    
    //var cancelCellButton: UIButton!
    var currentHerbName: String!
    var currentCellYStart: CGFloat!
    var currentCellYEnd: CGFloat!
    
    var filteredResult = [String]()
    var searchActive = false
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
    
    // raw user data
    let names = [
        "丹沙",
        "云母",
        "玉泉",
        "石钟乳",
        "涅石",
        "消石",
        "朴消",
        "滑石",
        "石胆",
        "空青",
        "曾青",
        "禹余粮",
        "太乙余粮",
        "白石英",
        "紫石英",
        "青石、赤石、黄石、白石、黑石脂等",
        "白青",
        "扁青",
        "最后"
     //   "zzz"
    ]
    
    
    
    class User: NSObject {
        let name: String
        var section: Int?
        
        init(name: String) {
            self.name = name
        }
    }
    
    class Section {
        var users: [User] = []
        
        func addUser(user: User) {
            self.users.append(user)
        }
    }
    
    let collation = UILocalizedIndexedCollation.currentCollation()
        as! UILocalizedIndexedCollation
    
    var _sections: [Section]?
    
    var sections: [Section] {
        // return if already initialized
        if self._sections != nil {
            return self._sections!
        }
        
        
        // create users from the name list
        var users: [User] = names.map { name in
            var user = User(name: name)
            user.section = self.collation.sectionForObject(user, collationStringSelector: "name")
            return user
        }
        
        // create empty sections
        var sections = [Section]()
        for i in 0..<self.collation.sectionIndexTitles.count {
            sections.append(Section())
        }
        
        // put each user in a section
        for user in users {
            sections[user.section!].addUser(user)
        }
        
        // sort each section
        for section in sections {
            section.users = self.collation.sortedArrayFromArray(section.users, collationStringSelector: "name") as! [User]
        }
        
        self._sections = sections
        
        return self._sections!
        
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.searchBar = UISearchBar()
//        self.searchBar = UISearchBar(frame: CGRectMake(0, 0, self.screenWidth, 40))
//        self.searchBar.delegate = self
//        self.searchBar.placeholder = "搜索药材名称"
//        self.view.addSubview(self.searchBar)
        
    
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.frame = CGRectMake(0, 0, self.screenWidth, 40)
        self.searchController.searchBar.placeholder = "搜索药材名称"
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.tintColor = UIColor.blackColor()
        self.searchController.searchBar.barTintColor = UIColor(red: 208 / 255, green: 208 / 255, blue: 208 / 255, alpha: 0.2)
        //self.definesPresentationContext = true
        self.searchController.searchBar.delegate = self
        self.searchController.definesPresentationContext = false
        self.navigationItem.titleView = self.searchController.searchBar
        
        
        self.mainTableView = UITableView(frame: CGRectMake(0, 0
            , self.screenWidth, self.screenHeight), style: UITableViewStyle.Plain)
        self.mainTableView.registerClass(MyTableViewCell.classForCoder(), forCellReuseIdentifier: self.tableViewCellIdentifier)
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = .None
        self.view.addSubview(self.mainTableView)
        //self.mainTableView.tableHeaderView = self.searchController.searchBar
        
        var rightBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "goToSettings:")
        self.mainTableView.sectionIndexColor = UIColor(red: 194 / 255, green: 204 / 255, blue: 208 / 255, alpha: 1.0)
        
        //self.navigationController?.navigationItem.rightBarButtonItem = rightBarItem
        //self.navigationController?.navigationItem.setRightBarButtonItem(rightBarItem, animated: true)
        self.navigationItem.rightBarButtonItem = rightBarItem
        
        self.navigationController?.navigationBar.topItem?.title = "神农本草经"
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 246 / 255, green: 232 / 255, blue: 222 / 255, alpha: 1.0)
        
    
//        self.cancelCellButton = UIButton(frame: CGRectMake(0, 0, self.screenWidth, self.mainTableView.contentSize.height))
//        self.cancelCellButton.backgroundColor = UIColor.clearColor()
//        self.cancelCellButton.addTarget(self, action: "cancelCell:", forControlEvents: UIControlEvents.TouchUpInside)
//        self.mainTableView.addSubview(self.cancelCellButton)
//        self.cancelCellButton.hidden = true
        
        
        
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "tapToCancel:")
        tapGesture.cancelsTouchesInView = false
        self.mainTableView.addGestureRecognizer(tapGesture)
        
        
        
//        println(self.sections.count)
//        println(self.collation.sectionTitles)
//        println(self.sections[25].users.count)
        
    }
    
    
    
    func tapToCancel(recognizer: UITapGestureRecognizer){
        var tapLocation = recognizer.locationInView(self.mainTableView)
        
        if self.currentCellYStart != nil && self.currentCellYEnd != nil {
            if tapLocation.y > self.currentCellYEnd || tapLocation.y < self.currentCellYStart {
                self.cancelCell()
                self.currentCellYStart = nil
                self.currentCellYEnd = nil
            }
        }
        
    }
    
    func goToSettings(){
        println("settings")
    }
    
    
    func cancelCell(){
        println("cancel")
        self.selectedSection = nil
        self.selectedRowIndex = nil
        self.mainTableView.reloadData()
        //self.cancelCellButton.hidden = true
    }
    
    
    func convertPinyin(myPinyin: NSString)-> Character {
        var firstHanzi = myPinyin.characterAtIndex(0)
        var firstChar = pinyinFirstLetter(firstHanzi)
        var intConvert: Int = Int(firstChar)
        var myChar = Character(UnicodeScalar(intConvert))
        return myChar
    }
    
    func goToDetailPage(sender: UIButton){
        if self.currentHerbName != nil {
            self.searchController.active = false
            var detailPage = IndividualViewController()
            detailPage.herbName = self.currentHerbName
            println(self.currentHerbName)
            self.navigationController?.pushViewController(detailPage, animated: true)
        }
    
    }
    
    
    /*----------------tableView delegate---------------*/

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive {
            return self.filteredResult.count
        }
        return self.sections[section].users.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.searchActive {
            return 1
        }
        return self.sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //println("data source update")
        //println(self.mainTableView.numberOfRowsInSection(25))
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.tableViewCellIdentifier, forIndexPath: indexPath) as! MyTableViewCell
        
        if self.searchActive {
            cell.herbTitle.text = self.filteredResult[indexPath.row]
        }else {
            let user = self.sections[indexPath.section].users[indexPath.row]
            cell.herbTitle.text = user.name
        }
        cell.herbTitle.frame.size.width = self.widthForLabel(cell.herbTitle.text!, font: UIFont.systemFontOfSize(18), height: cell.herbTitle.frame.height)
        cell.herbDes.text = herbData[cell.herbTitle.text!]
        cell.herbDes.hidden = true
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.backgroundColor = UIColor(red: 224 / 255, green: 238 / 255, blue: 232 / 255, alpha: 1.0)
        cell.checkDetail.hidden = true
        
        if self.selectedRowIndex != nil {
            if self.selectedRowIndex == indexPath.row && self.selectedSection == indexPath.section{
                cell.herbDes.hidden = false
                cell.herbDes.frame.size.height = self.heightForLabel(herbData[cell.herbTitle.text!]!, font: UIFont.systemFontOfSize(13), width: cell.herbDes.frame.width)
                self.currentCellLabelHeight = cell.herbDes.frame.height
                if cell.herbTitle.frame.width > 70 {
                    self.currentCellLabelHeight = self.currentCellLabelHeight + cell.herbTitle.frame.height + 5
                }
                cell.backgroundColor = self.getCellColor(cell.herbTitle.text!)
                cell.checkDetail.hidden = false
                cell.checkDetail.frame.origin.y = cell.herbDes.frame.height / 2 - 10
                cell.checkDetail.addTarget(self, action: "goToDetailPage:", forControlEvents: UIControlEvents.TouchUpInside)
                self.currentHerbName = cell.herbTitle.text!
                self.currentCellYStart = cell.frame.origin.y
                self.currentCellYEnd = cell.frame.origin.y + cell.frame.height
                cell.herbDes.reloadInputViews()
                //println(cell.herbDes.frame)
            }
        }
        
        if cell.herbTitle.frame.width > 70 {
            cell.herbDes.frame.origin.y = cell.herbTitle.frame.origin.y + cell.herbTitle.frame.height + 5
            cell.checkDetail.frame.origin.y = cell.checkDetail.frame.origin.y + cell.herbTitle.frame.height
        } else {
            cell.herbDes.frame.origin.y = 5
        }
        

        
        
        return cell
        
        
    }
    
    func getCellColor(herbName: String)->UIColor{
        if herbState[herbName] != nil {
        var cellState: Int = herbState[herbName]!
        
        switch cellState {
        case 0:
            //寒
            return UIColor(red: 115 / 255, green: 151 / 255, blue: 171 / 255, alpha: 1.0)
        case 1:
            //小寒
            
            return UIColor(red: 161 / 255, green: 175 / 255, blue: 201 / 255, alpha: 1.0)
        case 2:
            //微寒
            return UIColor(red: 194 / 255, green: 204 / 255, blue: 208 / 255, alpha: 1.0)
        case 3:
            //平
            return UIColor(red: 224 / 255, green: 238 / 255, blue: 232 / 255, alpha: 1.0)
        case 4:
            //微温
            return UIColor(red: 255 / 255, green: 179 / 255, blue: 167 / 255, alpha: 1.0)
        case 5:
            //小温
            return UIColor(red: 239 / 255, green: 122 / 255, blue: 130 / 255, alpha: 1.0)
        case 6:
            //温
            return UIColor(red: 203 / 255, green: 58 / 255, blue: 86 / 255, alpha: 1.0)
        default:
            break
        }
        }
        return UIColor(red: 224 / 255, green: 238 / 255, blue: 232 / 255, alpha: 1.0)
    }
    
    func widthForLabel(text:String, font: UIFont, height: CGFloat)->CGFloat {
        let label = UILabel(frame: CGRectMake(0, 0, CGFloat.max, height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height + 10
        
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRectMake(0, 0, tableView.bounds.width, 30))
        headerView.backgroundColor = UIColor(red: 194 / 255, green: 204 / 255, blue: 208 / 255, alpha: 0.2)
        var titleLabel = UILabel(frame: CGRectMake(5, 8, 20, 20))
        if !self.sections[section].users.isEmpty {
            titleLabel.text = self.collation.sectionTitles[section]as? String
        }
        headerView.addSubview(titleLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if !self.sections[section].users.isEmpty {
            return self.collation.sectionTitles[section]as? String
        }
        return ""
    }

    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return self.collation.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return self.collation.sectionForSectionIndexTitleAtIndex(index)
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        self.selectedRowIndex = indexPath.row
        self.selectedSection = indexPath.section
        println("select a row")
        
        if self.searchController.active {
            //self.searchController.active = false
            //self.searchActive = false
            self.searchController.searchBar.resignFirstResponder()
            self.searchController.dimsBackgroundDuringPresentation = true
        }
        
        self.mainTableView.beginUpdates()
        self.mainTableView.endUpdates()
        self.mainTableView.reloadData()
        let cell = self.mainTableView.cellForRowAtIndexPath(indexPath) as! MyTableViewCell
//        println(cell.herbTitle.frame)
//        println(cell.herbDes.frame)
        
        
        
        
        let visibleCells = self.mainTableView.visibleCells() as! [MyTableViewCell]
        for myCell in visibleCells {
                if myCell !== cell {
                    myCell.alpha = 0.3
                }
        }
        
        return indexPath
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (self.selectedRowIndex != nil && self.selectedRowIndex == indexPath.row && self.selectedSection == indexPath.section){
            if self.currentCellLabelHeight != nil {
                //self.cancelCellButton.frame.size.height = self.mainTableView.contentSize.height
                //self.cancelCellButton.hidden = false
                return self.currentCellLabelHeight + 10
            }
            return 100
        }
        return 44

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("hahah")
        if self.searchController.active {
            self.searchController.searchBar.resignFirstResponder()
        }
       // self.searchController.active = false
        self.selectedRowIndex = nil
        self.selectedSection = nil
        self.mainTableView.reloadData()
        self.currentCellYEnd = nil
        self.currentCellYStart = nil
            //self.cancelCellButton.hidden = true
        
    }
    
    
    /*----------------tableView delegate---------------*/
    
    //UISearchBarDelegate
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        //self.searchActive = true
        if self.selectedRowIndex != nil {
            self.selectedRowIndex = nil
            self.selectedSection = nil
            self.mainTableView.reloadData()
        }
        println("search bar text did begin editing")
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        //self.searchActive = false
        println("search bar text did end editing")
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        self.searchActive = false
//        self.searchBar.resignFirstResponder()
        println("search bar cancel button clicked")
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        println("search clicked")
//        self.searchActive = false
//        self.searchBar.resignFirstResponder()
    }
//
//    
//    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
//        if searchBar.text != nil {
//            println("search bar text changed")
//            self.searchActive = true
//            self.mainTableView.reloadData()
//
//        }
        
    }
    
    //delegate for UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    
        self.searchController.dimsBackgroundDuringPresentation = false
        
        var searchText = searchController.searchBar.text
        self.filteredResult = self.names.filter(){(name: String) -> Bool in
            var stringMatch = name.rangeOfString(searchText)
            return stringMatch != nil
        }
        
        self.searchActive = true
        
        if self.filteredResult.count != 0 {
            println("reload tableview")
            println(self.filteredResult)
        }
        
        if searchController.searchBar.text == "" {
            self.searchActive = false
        }
        
        self.mainTableView.reloadData()
        //println(self.searchController.searchBar.text)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.searchController.searchBar.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //self.searchController.active = false
        //self.searchController.searchBar.hidden = true
    }
    

}
