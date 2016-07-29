//
//  MainViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "MainViewController.h"
#import "ADHomeViewController.h"
#import "ADProfileController.h"
#import "ADShowTimeViewController.h"
#import "ADNavigationController.h"
#import "UIDevice+ADExtension.h"
#import <AVFoundation/AVFoundation.h>

/**
 
    tabbarController搭建的页面，中间即为开启直播
    开启直播时需判断摄像头可否使用，麦克风可否使用，当前机型是否支持
    通过UIDevice的utsname获得手机型号,因为型号与通常描述不太相同,可通过延展类转换
    模拟器不支持直播功能
    通过UIImagePickerController判断是否有摄像头
    通过AVAuthorizationStatus判断摄像头权限
    通过AVAudioSession判断是否有麦克风权限
 
    一切就绪即可开启
 */

@interface MainViewController ()<UITabBarControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    
    [self setup];
    
}

-(void)setup{
    
    [self addChildViewController:[[ADHomeViewController alloc] init]imageNamd:@"toolbar_home"];
    
    UIViewController *showTime = [[UIViewController alloc]init];
    showTime.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:showTime imageNamd:@"toolbar_live"];
    
    [self addChildViewController:[[ADProfileController alloc] init] imageNamd:@"toolbar_me"];
}


-(void)addChildViewController:(UIViewController *)childController imageNamd:(NSString *)imageName{
    
    ADNavigationController *nav = [[ADNavigationController alloc]initWithRootViewController:childController];
    
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",imageName]];
    //设置图片居中，这儿需要注意top和bottom必须绝对值一样大
    childController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    //设置个人中心的导航栏为透明的
    if ([childController isKindOfClass:[ADProfileController class]]) {
        [nav.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.shadowImage = [[UIImage alloc]init];
        nav.navigationBar.translucent = YES;
        
    }
    [self addChildViewController:nav];
    
}


#pragma mark - 重写tbabar的选择方法
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
   
    
    //tabBar的子控制器默认会有一个，所以要减去两个才会得到第二个
    //也就是中间直播的界面
    if ([tabBarController.childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count-2) {
        
        //通过对UIDevice的延展类判断当前机型，模拟器则不允许调用
        if([[UIDevice deviceVersion] isEqualToString:@"iPhone Simulator"]){
            [self showInfo:@"请用真机进行测试,此模块不支持模拟器测试"];
            return NO;
        }
        

        //判断是否有摄像头
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showInfo:@"你的设备没有摄像头或相关的驱动，不能直播"];
            return NO;
        }
        
        //判断是否有摄像头权限
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted||authorizationStatus == AVAuthorizationStatusDenied) {
            [self showInfo:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
            return NO;
        }

        
        // 开启麦克风权限
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted){
                if (granted) {
                    return YES;
                }else{
                    [self showInfo:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                    return NO;
                }
            }];
        }
        
        //一切准备就绪,开启直播页面
        ADShowTimeViewController *showTimeVc = [UIStoryboard storyboardWithName:NSStringFromClass([ADShowTimeViewController class]) bundle:nil].instantiateInitialViewController;
        [self presentViewController:showTimeVc animated:YES completion:nil];
        return NO;
       
        
    }
    
    
    return YES;
}



@end
