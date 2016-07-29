//
//  ADSelectedView.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/23.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,HomeType) {
    
    HomeTypeHot, //热门
    HomeTypeNew, //最新
    HomeTypeCare //关注
    
};
@interface ADSelectedView : UIView
//选中了
@property(nonatomic, copy) void (^selectedBlock)(HomeType type);
//下划线
@property(nonatomic,weak,readonly)UIView *underLine;
//设置滑动选中的按钮
@property(nonatomic,assign)HomeType selectedType;


@end



