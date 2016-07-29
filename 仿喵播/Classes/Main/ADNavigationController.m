//
//  ADNavigationController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADNavigationController.h"

@interface ADNavigationController ()

@end

@implementation ADNavigationController


//类第一次调用的时候被调用，且只调用一次
//适合做一次性操作
+(void)initialize{
    UINavigationBar *Bar = [UINavigationBar appearance];
    [Bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
}


//重写push方法，给子控制器自定义返回按钮并隐藏底部bar
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //push后，如果子控件存在隐藏底部Bar导航栏
    if (self.childViewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //自定义返回按钮
        UIButton *btn = [[UIButton alloc]init];
        [btn setImage:[UIImage imageNamed:@"back_9x16"] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
        //如果自定义返回按钮后，滑动返回可能失效，需添加以下代码
        __weak typeof(viewController)Weakself =  viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
    }
    
    [super pushViewController:viewController animated:animated];
    
    
    
}

//返回时要判断返回后的界面是dismiss到达，还是push到达
-(void)back{
    //判断两种情况:push 和present
    //如果导航栏存在一个正在present或已经present的View
    //且子控制器只有当前这一个，则此时手势代表返回
    //否则为push
    if ((self.presentedViewController || self.presentingViewController)&& self.childViewControllers.count == 1){
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self popViewControllerAnimated:YES];
    }
}













@end
