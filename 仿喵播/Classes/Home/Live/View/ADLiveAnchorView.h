//
//  ADLiveAnchorView.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//
//直播间主播相关的视图

#import <UIKit/UIKit.h>
@class  ADInLive;
@class ADUser;


@interface ADLiveAnchorView : UIView

+(instancetype)liveAnchorView;

//主播
@property(nonatomic, strong) ADUser *user;

//直播
@property(nonatomic, strong)ADInLive *live;

//点击开关
@property(nonatomic, copy)void (^clickDeviceShow)(BOOL selected);

@end
