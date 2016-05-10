//
//  Push_TitleController.swift
//  XBook
//
//  Created by 陈昆涛 on 16/3/6.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

import UIKit

typealias Push_TitleCallBack = (Title:String)->Void
class Push_TitleController: UIViewController {
    /**
     实现回调
     1、Block闭包
     2、Delegate
     3、通知  NSNOtifecation
     */
    
    var textField:UITextField?
    
    var callBack:Push_TitleCallBack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.textField = UITextField(frame: CGRectMake(15,60,SCREEN_WIDTH - 30,30))
        //边框
        self.textField?.borderStyle = .RoundedRect
        //提示
        self.textField?.placeholder = "书评标题"
        self.textField?.font = UIFont(name: MY_FONT, size: 15)
        self.view.addSubview(self.textField!)
        
        self.textField?.becomeFirstResponder()

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func sure(){
        self.callBack?(Title:self.textField!.text!)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }

        
    }
    func close(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
}
