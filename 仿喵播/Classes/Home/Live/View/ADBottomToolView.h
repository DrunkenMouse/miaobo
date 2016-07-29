//
//  ADBottomToolView.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//
//直播间底部的工具栏

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,LiveToolType) {
    LiveToolTypePublicTalk,
    LiveToolTypePrivateTalk,
    LiveToolTypeGift,
    LiveToolTypeRank,
    LiveToolTypeShare,
    LiveToolTypeClose
};

@interface ADBottomToolView : UIView

//点击工具栏
@property(nonatomic, copy)void (^clickToolBlock)(LiveToolType type);

@end
