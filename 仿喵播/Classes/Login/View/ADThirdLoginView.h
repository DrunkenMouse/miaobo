//
//  ADThirdLoginView.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/21.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginType) {
    
    LoginTypeSina,
    LoginTypeQQ,
    LoginTypeWechat
    
};
@interface ADThirdLoginView : UIView
//点击按钮
@property(nonatomic, copy) void (^clickLogin)(LoginType type);

@end
