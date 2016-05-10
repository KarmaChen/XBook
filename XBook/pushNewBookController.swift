//
//  pushNewBookController.swift
//  XBook
//
//  Created by 陈昆涛 on 16/3/2.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

import UIKit

class pushNewBookController: UIViewController,BookTitleDelegate,PhotoPickerDelegate,VPImageCropperDelegate,UITableViewDelegate,UITableViewDataSource{
    
    var BookTitle:BookTitleView?
    
    var tableView:UITableView?
    
    var titleArray:Array<String> = []
    
    var Book_Title = ""
    
    var Score: LDXScore?
    
    var type = "文学"
    
    var detailType = "文学"
    
    var Book_Description = ""
    
    //编辑
    var BookObject:AVObject?
    
    
    var fixType:String?
    

    /**
     表示是否现实星星
     */
    var showScore = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.BookTitle = BookTitleView(frame: CGRectMake(0, 40, SCREEN_WIDTH, 160))
        self.BookTitle?.delegate = self
        self.view.addSubview(self.BookTitle!)
        
         self.tableView = UITableView(frame: CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT - 200), style: .Grouped)
        
        
        //后面内容的线消失
        self.tableView?.tableFooterView = UIView()
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        //添加一个cell
        self.tableView?.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.backgroundColor = UIColor(colorLiteralRed: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        self.view.addSubview(self.tableView!)
        
        self.titleArray = ["标题","评分","分类","书评"]
        
        
       //评分
        self.Score = LDXScore(frame: CGRectMake(100,10,100,22))
        self.Score?.isSelect = true
        self.Score?.normalImg = UIImage(named: "btn_star_evaluation_normal")
        self.Score?.highlightImg = UIImage(named: "btn_star_evaluation_press")
        self.Score?.max_star = 5
        self.Score?.show_star = 5
       
        
        /**
        注册通知
        */
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("pushCallBack:"), name: "pushCallBack", object: nil)
        
    }

    /**
     编辑
     */
    func fixBook(){
        if self.fixType == "fix" {
            self.BookTitle?.BookName?.text = self.BookObject!["BookName"] as? String
            self.BookTitle?.BookEditor?.text = self.BookObject!["BookEditor"] as? String
            let coverFile = self.BookObject!["cover"] as? AVFile
            coverFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                self.BookTitle?.BookCover?.setImage(UIImage(data: data), forState: .Normal)
            })
            
            self.Book_Title = (self.BookObject!["title"] as? String)!
            self.type = (self.BookObject!["type"] as? String)!
            self.detailType = (self.BookObject!["detailType"] as? String)!
            self.Book_Description = (self.BookObject!["description"] as? String)!
            self.Score?.show_star = (Int)((self.BookObject!["score"] as? String)!)!
            if self.Book_Description != "" {
                self.titleArray.append("")
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //检查是否发生内存泄露
    deinit{
        print("内存没泄露")
        /**
        移除通知
        */
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //pushBookNotification
    func pushCallBack(notification:NSNotification){
        let dict = notification.userInfo
        if (String(dict!["success"]!)) == "true" {
            if self.fixType == "fix" {
                ProgressHUD.showSuccess("修改成功")
            }else{
                ProgressHUD.showSuccess("上传成功")
            }
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                
            })
        }else{
            ProgressHUD.showError("上传失败")
        }
    }    /**
     BookTitleDelegate
    */
    func choiceCover() {
        let vc = PhotoPickerViewController()
        vc.delegate = self
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
        
    }
    
    func getImageFromPicker(image: UIImage) {
    //对图片进行剪裁
        let CroVC = VPImageCropperViewController(image: image, cropFrame: CGRectMake(0, 100, SCREEN_HEIGHT, SCREEN_WIDTH*1.27), limitScaleRatio: 3)
        CroVC.delegate = self
        self.presentViewController(CroVC, animated: true) { () -> Void in
            
        }
    }
    //取消剪裁的方法
    func imageCropperDidCancel(cropperViewController: VPImageCropperViewController!) {
        cropperViewController.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    //完成剪裁的方法
    func imageCropper(cropperViewController: VPImageCropperViewController!, didFinished editedImage: UIImage!) {
        self.BookTitle?.BookCover?.setImage(editedImage, forState: .Normal)
        cropperViewController.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    
    
    
    func close(){
        self.dismissViewControllerAnimated(true){ () ->Void in
        }
    }
    func sure(){
        let dict = [
            "BookName":(self.BookTitle?.BookName?.text)!,
            "BookEditor":(self.BookTitle?.BookEditor?.text)!,
            "BookCover":(self.BookTitle?.BookCover?.currentImage)!,
            "title":self.Book_Title,
            "score":String((self.Score?.show_star)!),
            "type":self.type,
            "detailType":self.detailType,
            "description":self.Book_Description,
        ]
        ProgressHUD.show("")
        
        if self.fixType == "fix" {
            pushBook.pushBookInBack(dict, object: self.BookObject!)
        }else{
            
            let object = AVObject(className: "Book")
            pushBook.pushBookInBack(dict, object: object)
        }
        
    }
    
    /**®
     *  UITableViewDelegate  &&  UITableViewDataSource
     */
    //返回几个size
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //每个section有几行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    //返回一个UIViewCell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //用这个初始化 左边和右边就默认有一个lable
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
      /**
        * 队列的方法了来初始化 默认上面什么都没有
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        */
        //cell要重用 所以必须先remove掉它先前的内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        //有边有个小箭头
        if(indexPath.row != 1){
            cell.accessoryType = .DisclosureIndicator
        }
        cell.textLabel?.text = self.titleArray[indexPath.row]
        cell.textLabel?.font = UIFont(name: MY_FONT, size: 15)
        cell.detailTextLabel?.font = UIFont(name:MY_FONT, size: 13)
        
        var row  = indexPath.row
        if self.showScore && row > 1{
            row--
        }
        switch row{
        case 0 :
            cell.detailTextLabel?.text = self.Book_Title
            break
        case 2 :
            cell.detailTextLabel?.text = self.type + "->" + self.detailType
            break
        case 4 :
            cell.accessoryType = .None
            let commentView = UITextView(frame: CGRectMake(4,4,SCREEN_WIDTH-8,80))
            commentView.text = self.Book_Description
            commentView.font = UIFont(name: MY_FONT, size: 14)
            commentView.editable = false
            cell.contentView.addSubview(commentView)
        default:
            break
        }
        
        /**
        判断是否需要在第二行添加小星星
        
        */
        if self.showScore && indexPath.row == 2 {
            cell.contentView.addSubview(self.Score!)
        }

        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if showScore && indexPath.row >= 5 {
            return 88
        }else if !self.showScore && indexPath.row >= 4 {
            return 88
        }else{
            return 44
        }
    }

    //点击动作
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        var row = indexPath.row
        if self.showScore && row>=1 {
            row -= 1
        }
        switch row {
        case 0:
            self.tableViewSelectTitle()
            break
        case 1:
            self.tableViewSelectScore()
            break
        case 2:
            self.tableViewSelectType()
            break
        case 3:
            self.tableViewSelectDescription()
            break
        default:
            break
            
        }
        
    }
    
    /**
     *  选择标题
     */
    func tableViewSelectTitle(){
        let vc  = Push_TitleController()
        GeneralFactory.addTitleWithTile(vc)
        vc.callBack = ({(Title:String)-> Void in
            self.Book_Title = Title
            self.tableView?.reloadData()
        
        })
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
    }
    /**
     *  选择评分
     */
    func tableViewSelectScore(){
        //点击插入CELL
        self.tableView?.beginUpdates()
        
        
        let tempIndexPath = [NSIndexPath(forRow: 2, inSection: 0)]
        if self.showScore{
            self.titleArray.removeAtIndex(2)
           self.tableView?.deleteRowsAtIndexPaths(tempIndexPath, withRowAnimation: .Right)
            self.showScore = false
        }else{
        self.tableView?.insertRowsAtIndexPaths(tempIndexPath, withRowAnimation: .Automatic)
        self.titleArray.insert("", atIndex: 2)
        self.showScore = true
        }
        
        
        
        self.tableView?.endUpdates()
        
    }
    /**
     *  选择分类
     */
    func tableViewSelectType(){
        let vc  = Push_TypeController()
        GeneralFactory.addTitleWithTile(vc)
        
        let btn1 = vc.view.viewWithTag(1234) as? UIButton
        let btn2 = vc.view.viewWithTag(1235) as? UIButton
        btn1?.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        btn2?.setTitleColor(RGB(38, g: 82, b: 67), forState: .Normal)
        vc.type = self.type
        vc.detailType = self.detailType
        vc.callBack = ({(type:String,detailType:String)->Void in
            self.type = type
            self.detailType = detailType
            self.tableView?.reloadData()
        
        
        })
        
        
        
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
            
        }
        
    
    /**
     *  选择书评
     */
    func tableViewSelectDescription(){
        let vc  = Push_DescriptionController()
        GeneralFactory.addTitleWithTile(vc)
        vc.textView?.text = self.Book_Description
        vc.callBack = ({(description:String)-> Void in
            self.Book_Description = description
            if self.titleArray.last == ""{
                self.titleArray.removeLast()
            }
            if description != ""{
                self.titleArray.append("")
            }
            self.tableView?.reloadData()
        
        })
        self.presentViewController(vc, animated: true) { () -> Void in
            
        }
                }
        
    }

    
    
    


