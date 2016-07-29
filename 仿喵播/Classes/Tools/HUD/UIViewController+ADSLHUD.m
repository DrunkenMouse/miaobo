//
//  UIViewController+ADSLHUD.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "UIViewController+ADSLHUD.h"
#import <objc/runtime.h>
static const void *HUDKey = &HUDKey;

@implementation UIViewController (ADSLHUD)
#pragma mark - 动态绑定HUD属性

-(MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HUDKey);
}

-(void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - 方法实现


//非动画形式展示,showHudInView
//无论通过何种方式创建出来非动画形式的HUD都会保存在自定义的内存空间里
-(void)showHudInView:(UIView *)view hint:(NSString *)hint{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:view];
    HUD.labelText = hint;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
    
}


-(void)showHudInView:(UIView *)view hint:(NSString *)hint yoffset:(float)yOffset{
    MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:view];
    HUD.labelText = hint;
    HUD.margin = 10.f;
    HUD.yOffset += yOffset;
    [view addSubview:HUD];
    [HUD show:YES];
    [self setHUD:HUD];
}


//动画模式showHit,开启动画模式并默认两秒后隐藏且移除

//纯展示hint内容时，即没有指定View,通过APP代理获取window，而后显示在window上
//显示模式为纯文本模式，拒绝用户交互，并设置两秒后隐藏，隐藏时从父控件移除
-(void)showHit:(NSString *)hint{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
    
}

-(void)showHit:(NSString *)hint inView:(UIView *)view{
    
    //显示提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    [view addSubview:hud];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud show:YES];
    [hud hide:YES afterDelay:2];
    
}

-(void)showHit:(NSString *)hint yOffset:(float)yOffset{
    //显示提示信息
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = hint;
    hud.margin = 10.f;
    hud.yOffset += yOffset;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:2];
    
    
}
-(void)hideHud{
    [[self HUD]hide:YES];
}



@end
