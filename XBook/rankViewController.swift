//
//  rankViewController.swift
//  XBook
//
//  Created by 陈昆涛 on 16/3/1.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

import UIKit

class rankViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()

//        // Do any additional setup after loading the view.
//       let lable = UILabel(frame: CGRectMake(0,0,200,20))
//        lable.center = self.view.center
//        lable.textAlignment = NSTextAlignment.Center
//        //字体宽度不够 自动调整字体的大小
//        lable.adjustsFontSizeToFitWidth = true
//        //字体的类型
//        lable.font = UIFont(name: MY_FONT, size: 14)
//        lable.text = "哈哈哈哈,我是Karma!!!"
//        lable.textColor = UIColor.blackColor()
//        //添加
//        self.view.addSubview(lable)
//        
       AVUser.logOut()
        if AVUser.currentUser() == nil{
                let story = UIStoryboard(name: "Login", bundle: nil)
                let loginVC = story.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginVC, animated: true, completion: { () -> Void in
            })
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
