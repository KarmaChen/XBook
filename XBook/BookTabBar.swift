//
//  BookTabBar.swift
//  XBook
//
//  Created by 陈昆涛 on 16/3/12.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

import UIKit
protocol BookTabBarDelegate{
    func comment()
    func commentController()
    func likeBook(btn:UIButton)
    func shareAction()
}

class BookTabBar: UIView {
    var delegate: BookTabBarDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        let imageName = ["Pen 4","chat 3","heart","box outgoing"]
        for var i = 0 ;i<4;i++ {
            let btn = UIButton(frame: CGRectMake(CGFloat(i)*frame.size.width/4,0,frame.size.width/4,frame.size.height))
            btn.setImage(UIImage(named: imageName[i]), forState: .Normal)
            self.addSubview(btn)
            btn.tag = i
            btn.addTarget(self, action: Selector("BookTabbarAction:"), forControlEvents: .TouchUpInside)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetRGBStrokeColor(context,231/255,231/255,231/255,1)
        for var i = 1;i<4;i++ {
            CGContextMoveToPoint(context, CGFloat(i)*rect.size.width/4, rect.size.height*0.1)
            CGContextAddLineToPoint(context, CGFloat(i)*rect.size.width/4, rect.size.height*0.9)
        }
        CGContextMoveToPoint(context, 8, 0)
        CGContextAddLineToPoint(context, rect.size.width - 8, 0)
        CGContextStrokePath(context)
    }
    /**
     *  BookTabBarDelegate
     */
    func BookTabbarAction(btn:UIButton){
        switch(btn.tag){
        case 0:
            delegate?.comment()
            break
        case 1:
            delegate?.commentController()
            break
        case 2:
            delegate?.likeBook(btn)
            break
        case 3:
            delegate?.shareAction()
            break
        default:
            break
        }
        
    }
    



}
