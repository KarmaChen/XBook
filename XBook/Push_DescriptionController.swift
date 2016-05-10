//
//  Push_DescriptionController.swift
//  XBook
//
//  Created by 陈昆涛 on 16/3/6.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

import UIKit

typealias Push_DescriptionControllerBlock = (description:String)->Void

class Push_DescriptionController: UIViewController {
    
    var textView : JVFloatLabeledTextView?
    
    var callBack : Push_DescriptionControllerBlock?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.textView = JVFloatLabeledTextView(frame: CGRectMake(8,58,SCREEN_WIDTH-16 ,SCREEN_HEIGHT - 58 - 8))
        self.view.addSubview(self.textView!)
        self.textView?.placeholder = "      你可以在这里撰写详细的评价、吐槽、介绍～～"
        self.textView?.font = UIFont(name: MY_FONT, size: 17)
        self.view.tintColor = UIColor.grayColor()
        self.textView?.becomeFirstResponder()
        
        XKeyBoard.registerKeyBoardHide(self)
        XKeyBoard.registerKeyBoardShow(self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sure(){
        self.callBack!(description: (self.textView?.text)!)
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
        
    }
    func close(){
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    /**
     *  键盘遮挡
     */
    func keyboardWillHideNotification(notification:NSNotification){
        self.textView?.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    func keyboardWillShowNotification(notification:NSNotification){
        let rect = XKeyBoard.returnKeyBoardWindow(notification)
        self.textView?.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height, 0)
        
    }

}
