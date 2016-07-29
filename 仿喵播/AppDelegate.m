//
//  AppDelegate.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/21.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "AppDelegate.h"
#import "ADLoginViewController.h"
#import "Reachability.h"
#import "ADTopWindow.h"

@interface AppDelegate (){
    
    Reachability *_reacha;
    NetWorkStates _preStatus;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //主页为ADLoginViewControlle
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ADLoginViewController alloc]init];
    
    [self.window makeKeyAndVisible];
    
    [self checkNetworkStates];
    
    NSLog(@"网络状态码:----->%ld", [ADNetWorkTool getNetworkStates]);

    
    
    return YES;
}

#pragma mark - 实时监听网络状态
-(void)checkNetworkStates{
    
    //通过通知中心注册监听Reachability提供的kReachabilityChangedNotification
    //实时监听网络状态网络变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    //给Reachbility注册一个地址host地址为百度
    _reacha = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    //开始监听
    [_reacha startNotifier];
}


//每当网络状态发生改变时就调用此方法
-(void)networkChange{
    NSString *tips;
    //获取当网络状态,如果与上次相同就不提示
    NetWorkStates currentStates = [ADNetWorkTool getNetworkStates];
    if (currentStates == _preStatus) {
        return;
    }
    //如果不同就保存当期网络状态
    _preStatus = currentStates;
    switch (currentStates) {
        case NetWorkStatesNone:
            tips = @"当前无网络，请检查您的网络状态";
            break;
        case NetWorkStates2G:
            tips = @"切换到了2G网络";
            break;
        case NetWorkStates3G:
            tips = @"切换到了3G网络";
            break;
        case NetWorkStates4G:
            tips = @"切换到了4G网络";
            break;
        case NetWorkStatesWIFI:
            tips = nil;
            break;
        default:
            break;
    }

    //弹窗提示用户网络状态已经改变
    if (tips.length) {
        [[[UIAlertView alloc]initWithTitle:@"喵萝" message:tips delegate:nil cancelButtonTitle:@"好的~" otherButtonTitles:nil, nil] show];
    }
    
}


#pragma mark - app成为焦点
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // 给状态栏添加一个按钮可以进行点击, 可以让屏幕上的scrollView滚到最顶部
    [ADTopWindow show];
}




@end
