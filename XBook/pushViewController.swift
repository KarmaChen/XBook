//
//  pushViewController.swift
//  XBook
//
//  Created by 陈昆涛 on 16/3/1.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

import UIKit

class pushViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,SWTableViewCellDelegate {
    
    var dataArray = NSMutableArray()
    
    var tableView:UITableView?
    
    var navigationView:UIView!
    
    var swipIndexPath:NSIndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setNavigationBar()

        // 初始化tableview
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        self.tableView?.registerClass(pushBook_Cell.classForCoder(), forCellReuseIdentifier: "cell")
        self.tableView?.tableFooterView = UIView()
        
        //初始化上啦和下拉
        self.tableView?.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("headerRefresh"))
        self.tableView?.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: Selector("footerRefresh"))
        
        //进来马上加载
        self.tableView?.mj_header.beginRefreshing()


    }
    override func viewDidAppear(animated: Bool) {
        self.navigationView.hidden = false
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //在navigationbar添加按钮
    func setNavigationBar(){
        navigationView = UIView(frame: CGRectMake(0,-20,SCREEN_WIDTH,65))
        //把navigationView放到navigationBar上
        self.navigationController?.navigationBar.addSubview(navigationView)
        let addBookBtn = UIButton(frame: CGRectMake(20,20,SCREEN_WIDTH,45))
        //设置按钮的属性
        addBookBtn.setImage(UIImage(named: "plus circle"), forState: .Normal)
        addBookBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        addBookBtn.setTitle("    新建书评", forState: .Normal)
        addBookBtn.titleLabel?.font = UIFont(name: MY_FONT, size: 15)
        //按钮文字现实居左
        addBookBtn.contentHorizontalAlignment = .Left
        //添加动作
        addBookBtn.addTarget(self, action: Selector("pushNewBook"), forControlEvents: .TouchUpInside)
        //按钮添加到navigationView里
        navigationView.addSubview(addBookBtn)

    }
    func pushNewBook(){
        let vc = pushNewBookController()
        GeneralFactory.addTitleWithTile(vc, title1: "关闭" ,title2: "发布")
        self.presentViewController(vc, animated: true){ () -> Void in
            
        }
        
    }
    /**
     *  UITabelViewDelegate   UITableViewDataSource
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? pushBook_Cell
        cell?.rightUtilityButtons = self.returnRightBtn()
        cell?.delegate = self
        
        let dict = self.dataArray[indexPath.row] as? AVObject
        
        cell?.BookName?.text = "《"+(dict!["BookName"] as! String)+"》:"+(dict!["title"] as! String)
        cell?.Editor?.text = "作者:"+(dict!["BookEditor"] as! String)
        
        let date = dict!["createdAt"] as? NSDate
        let format = NSDateFormatter()
        format.dateFormat = "yyyy-MM-dd hh:mm"
        cell?.more?.text = format.stringFromDate(date!)
        
        let coverFile = dict!["cover"] as? AVFile
        cell?.cover?.sd_setImageWithURL(NSURL(string: (coverFile?.url)!), placeholderImage: UIImage(named: "Cover"))
        
        
        return cell!
    }
    func returnRightBtn()->[AnyObject]{
        let btn1 = UIButton(frame: CGRectMake(0,0,88,88))
        btn1.backgroundColor = UIColor.orangeColor()
        btn1.setTitle("编辑", forState: .Normal)
        
        let btn2 = UIButton(frame:CGRectMake(0,0,88,88))
        btn2.backgroundColor = UIColor.redColor()
        btn2.setTitle("删除", forState: .Normal)
        
        return [btn1,btn2]
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        
        let vc = BookDetailViewController()
        vc.BookObject = self.dataArray[indexPath.row] as? 	AVObject
        //隐藏下面的tablebar
        hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    /**
     SWTableViewCellDelegate
     */
    //只能展开一个
    func swipeableTableViewCell(cell: SWTableViewCell!, scrollingToState state: SWCellState) {
        let indexPath = self.tableView?.indexPathForCell(cell)
        if state == .CellStateRight{
            if self.swipIndexPath != nil && self.swipIndexPath?.row != indexPath?.row {
                let swipedCell = self.tableView?.cellForRowAtIndexPath(self.swipIndexPath!) as? pushBook_Cell
                swipedCell?.hideUtilityButtonsAnimated(true)
            }
            self.swipIndexPath = indexPath
        }else if state == .CellStateCenter{
            self.swipIndexPath = nil
        }
    }
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int) {
        //点击按钮隐藏
        cell.hideUtilityButtonsAnimated(true)
        
        let indexPath = self.tableView?.indexPathForCell(cell)
        let object = self.dataArray[indexPath!.row] as? AVObject
        
        if index  == 0{
            //编辑
            let vc = pushNewBookController()
            GeneralFactory.addTitleWithTile(vc, title1: "关闭", title2: "发布")
            vc.fixType = "fix"
            vc.BookObject = object
            vc.fixBook()
            self.presentViewController(vc, animated: true, completion: { () -> Void in
                
            })

            
        }else{
            ProgressHUD.show("")
            
            let discussQuery = AVQuery(className: "discuss")
            discussQuery.whereKey("BookObject", equalTo: object)
            discussQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for Book in results {
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                }
            })
            
            let loveQuery = AVQuery(className: "Love")
            loveQuery.whereKey("BookObject", equalTo: object)
            loveQuery.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                for Book in results {
                    let BookObject = Book as? AVObject
                    BookObject?.deleteInBackground()
                }
            })
            
            object?.deleteInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    ProgressHUD.showSuccess("删除成功")
                    self.dataArray.removeObjectAtIndex((indexPath?.row)!)
                    self.tableView?.reloadData()
                    
                    
                }else{
                    
                }
            })
            
            
        }
        
        
    }
    /**
     *  上拉加载 、 下拉刷新
     */
    func headerRefresh(){
        let query = AVQuery(className: "Book")
        //更新时间最新在上
        query.orderByDescending("createdAt")
        //一次性返回几个
        query.limit = 20
        //跳过几个 上啦加载时使用
        query.skip = 0
        //自己点评的
        query.whereKey("user", equalTo: AVUser.currentUser())
        //
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_header.endRefreshing()
            
            self.dataArray.removeAllObjects()
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
            
        }
        
    }
    func footerRefresh(){
        let query = AVQuery(className: "Book")
        query.orderByDescending("createdAt")
        query.limit = 20
        query.skip = self.dataArray.count
        query.whereKey("user", equalTo: AVUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
            self.tableView?.mj_footer.endRefreshing()
            
            self.dataArray.addObjectsFromArray(results)
            self.tableView?.reloadData()
            
        }
        
    }

    
	
}
