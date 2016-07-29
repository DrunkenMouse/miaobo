//
//  ADTopWindow.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADTopWindow.h"

@implementation ADTopWindow

//通过一次执行声明一个按钮
//并将按钮添加到当前状态栏上
//按钮被点击时通过递归找到当前显示的scrollView滚动到最顶端
static UIButton *btn_;
+ (void)initialize
{
    UIButton *btn = [[UIButton alloc]initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    [btn addTarget:self action:@selector(windowClick) forControlEvents:UIControlEventTouchUpInside];
    [[self statusBarView]addSubview:btn];
    btn.hidden = YES;
    btn_ = btn;
    
}


#pragma mark - 获取当前状态栏的方法
+(UIView *)statusBarView{
    
    UIView *statusBar = nil;
    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73,0x74,0x61,0x75,0x73,0x42,0x61,0x72} length:9];

    NSString *key = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
    
    id object = [UIApplication sharedApplication];
    
    if([object respondsToSelector:NSSelectorFromString(key)]) {
            statusBar = [object valueForKey:key];
        
    }
    return statusBar;
}

#pragma mark - 隐藏/显示按钮
+(void)show{
    btn_.hidden = NO;
}

+(void)hide{
    btn_.hidden = YES;
}

#pragma mark - 监听窗口点击
+ (void)windowClick{
    
//    NSLog(@"点击了最顶部...");
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
    
}

+(void)searchScrollViewInView: (UIView *)superView{
    
    
    for (UIScrollView *subview in superView.subviews) {
        //如果是scrollView滚动到最顶部
        if ([subview isKindOfClass:[UIScrollView class]]&&subview.isShowingOnKeyWindow) {
            
            CGPoint offset = subview.contentOffset;
            offset.y = -subview.contentInset.top;
            [subview setContentOffset:offset animated:YES];
        }
        //继续查找子控件
        [self searchScrollViewInView:subview];
    }
    
}

@end
