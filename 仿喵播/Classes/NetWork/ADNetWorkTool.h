//
//  ADNetWorkTool.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, NetWorkStates) {
    NetWorkStatesNone,//没有网络
    NetWorkStates2G, //2G
    NetWorkStates3G, //3G
    NetWorkStates4G, //4G
    NetWorkStatesWIFI //WIFI
};
@interface ADNetWorkTool : AFHTTPSessionManager
+(instancetype)shareTool;

//判断网络类型
+(NetWorkStates)getNetworkStates;
@end
