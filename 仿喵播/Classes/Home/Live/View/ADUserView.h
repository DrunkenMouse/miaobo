//
//  ADUserView.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/25.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADUser;

@interface ADUserView : UIView
+(instancetype)userView;
/** 点击关闭 */
@property(nonatomic, copy) void (^closeBlock)();
/** 用户信息 */
@property(nonatomic, strong) ADUser *user;

@end
