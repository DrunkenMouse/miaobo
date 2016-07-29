//
//  ADNetWorkTool.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADNetWorkTool.h"

@implementation ADNetWorkTool


static ADNetWorkTool * _manager;
+(instancetype)shareTool{
    
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _manager = [ADNetWorkTool manager];
        
        //设置超时时间
        _manager.requestSerializer.timeoutInterval = 5.f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    });
    
    return _manager;
}

//判断网络类型
+(NetWorkStates)getNetworkStates{
    
    NSArray *subviews = [[[[UIApplication sharedApplication] valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"]subviews];
    //保存网络状态
    NetWorkStates states = NetWorkStatesNone;
#pragma mark --------------------------
    for (id child in subviews) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType = [[child valueForKeyPath:@"dataNetworkType"] intValue];
            
            switch (networkType) {
                case 0:
                    //无网模式
                    states = NetWorkStatesNone;
                    break;
                case 1:
                    states = NetWorkStates2G;
                    break;
                case 2:
                    states = NetWorkStates3G;
                    break;
                case 3:
                    states = NetWorkStates4G;
                    break;
                case 5:
                    states = NetWorkStatesWIFI;
                    break;
                default:
                    break;
            }
        }
    }
    //根据状态选择
    return states;
}
@end
