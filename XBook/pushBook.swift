//
//  pushBook.swift
//  XBook
//
//  Created by 陈昆涛 on 16/3/9.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

import UIKit

class pushBook: NSObject	 {
    static func pushBookInBack(dict:NSDictionary,object:AVObject){
        
        object.setObject(dict["BookName"], forKey: "BookName")
        object.setObject(dict["BookEditor"], forKey: "BookEditor")
        object.setObject(dict["title"], forKey: "title")
        object.setObject(dict["score"], forKey: "score")
        object.setObject(dict["type"], forKey: "type")
        object.setObject(dict["detaileType"], forKey: "detaileType")
        object.setObject(dict["description"], forKey: "description")
        //指明用户
        object.setObject(AVUser.currentUser(), forKey: "user")
        //获取image
        let image = dict["BookCover"] as? UIImage
        //将图片转化为NSDATa类型
        let coverFile = AVFile(data: UIImagePNGRepresentation(image!))
        coverFile.saveInBackgroundWithBlock{(success,error) ->Void in
            //如果保存成功
            if success{
                object.setObject(coverFile, forKey: "cover")
                object.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success{
                         NSNotificationCenter.defaultCenter().postNotificationName("pushCallBack", object: nil, userInfo: ["success":"true"])
                    }else{
                         NSNotificationCenter.defaultCenter().postNotificationName("pushCallBack", object: nil, userInfo: ["success":"flase"])
                    }
                })

            }else{
                 NSNotificationCenter.defaultCenter().postNotificationName("pushCallBack", object: nil, userInfo: ["success":"false"])
            }
            
        }
        
    }
}
