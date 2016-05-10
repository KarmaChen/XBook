//
//  AppDelegate.swift
//  XBook
//
//  Created by 陈昆涛 on 16/3/1.
//  Copyright © 2016年 陈昆涛. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder,UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        /**
        设置ShareSDK
        */
        ShareSDK.registerApp("1077060a9dba8", activePlatforms: [SSDKPlatformType.SubTypeWechatSession.rawValue,SSDKPlatformType.SubTypeWechatTimeline.rawValue], onImport: { (platForm) -> Void in
            switch platForm {
            case SSDKPlatformType.TypeWechat:
                ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                break
            default:
                break
            }
            
            
            }) { (platfrom, appInfo) -> Void in
                switch platfrom{
                case SSDKPlatformType.TypeWechat:
                    appInfo.SSDKSetupWeChatByAppId("wx1c0c1a1bf0a95f23", appSecret: "a6a0ea2405b9a97edc649b6162d1fac8")
                default:
                    break
                }
        }

        //设置leancloud
        AVOSCloud.setApplicationId("XfTHxdI2AcqEmFBsggsCyLo7-gzGzoHsz", clientKey: "jRoJsK13wQfAK0g4K2jeFzPL")

        
        //导航栏 坐标 左右 上下 宽度 高度
        self.window = UIWindow(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT))
        let tarbarController = UITabBarController()
        let rankController = UINavigationController(rootViewController: rankViewController())
        let searchController = UINavigationController(rootViewController: searchViewController())
        let pushController = UINavigationController(rootViewController: pushViewController())
        let circleController = UINavigationController(rootViewController:circleViewController())
        let moreController = UINavigationController(rootViewController: moreViewController())
        
        tarbarController.viewControllers = [rankController,searchController,pushController,circleController,moreController]
        
        let tabbarItem1 = UITabBarItem(title:"排行榜",image: UIImage(named: "bio"),selectedImage: UIImage(named: "bio_red"))
        
        let tabbarItem2 = UITabBarItem(title:"发现",image: UIImage(named: "timer 2"),selectedImage: UIImage(named: "timer 2_red"))
        
        let tabbarItem3 = UITabBarItem(title:"",image: UIImage(named: "pencil"),selectedImage: UIImage(named: "pencil_red"))
        
        let tabbarItem4 = UITabBarItem(title:"圈子",image: UIImage(named: "users two-2"),selectedImage: UIImage(named: "users® two-2_red"))
        
        let tabbarItem5 = UITabBarItem(title:"更多",image: UIImage(named: "more"),selectedImage: UIImage(named: "more_red"))
        
        rankController.tabBarItem = tabbarItem1
        searchController.tabBarItem = tabbarItem2
        pushController.tabBarItem = tabbarItem3
        circleController.tabBarItem = tabbarItem4
        moreController.tabBarItem = tabbarItem5
        //设置选中的一个颜色
        rankController.tabBarController?.tabBar.tintColor = MAIN_RED
        
        //把页面显示出来
        self.window?.rootViewController = tarbarController
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

