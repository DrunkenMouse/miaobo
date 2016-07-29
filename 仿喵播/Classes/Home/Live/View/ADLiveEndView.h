//
//  ADLiveEndView.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/25.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADLiveEndView : UIView

+(instancetype)liveEndView;
/** 查看其他主播 */
@property(nonatomic, copy) void (^lookOtherBlock)();
/** 退出 */
@property(nonatomic, copy) void (^quitBlock)();

@end
