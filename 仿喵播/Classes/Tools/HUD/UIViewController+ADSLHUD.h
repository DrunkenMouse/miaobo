//
//  UIViewController+ADSLHUD.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MBProgressHUD.h>

@interface UIViewController (ADSLHUD)/** HUD */
///**
// *  提示信息
// *
// *  @param view 显示在哪个view
// *  @param hint 提示
// */
@property(nonatomic,weak,readonly) MBProgressHUD *HUD;
-(void)showHudInView:(UIView *)view hint:(NSString *)hint;
-(void)showHudInView:(UIView *)view hint:(NSString *)hint yoffset:(float)yOffset;
///**
// *  隐藏
// */
-(void)hideHud;
///**
// *  提示信息 mode:MBProgressHUDModeText
// *
// *  @param hint 提示
// */
-(void)showHit:(NSString *)hint;
-(void)showHit:(NSString *)hint inView:(UIView *)view;
// 从默认(showHint:)显示的位置再往上(下)yOffset
-(void)showHit:(NSString *)hint yOffset:(float)yOffset;

@end
