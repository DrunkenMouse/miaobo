//
//  ADHomeViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADHomeViewController.h"
#import "ADSelectedView.h"
#import "ADHotViewController.h"
#import "ADNewStarViewController.h"
#import "ADCareViewController.h"
#import "ADWebViewController.h"



@interface ADHomeViewController ()<UIScrollViewDelegate>

/**顶部选择视图*/
@property(nonatomic,assign) ADSelectedView *selectedView;
//UIScroolView
@property(nonatomic, weak) UIScrollView *scrollView;
//热播
@property(nonatomic,weak) ADHotViewController *hotVc;
//最新主播
@property(nonatomic,weak) ADNewStarViewController *starVc;
//关注主播
@property(nonatomic, weak) ADCareViewController *careVc;


@end

@implementation ADHomeViewController
/**
    顶部是UIView挂载三个按钮，通过按钮的点击事件来切换underLine的位置
    通过setSelectedType来保存滑动选中的按钮与按钮代表的Type值
    同时通过Block来调用方法，滚动底部的ScrollView过一半即为下一页
 
 
    底部是ScrollView,其宽度是屏幕宽*3,通过将最新最热关心三个控制器加到自身
    与将控制器的View加到ScrollView上达到显示的目的
    若滚动切换界面，则滚动结束后需设置导航栏的underLine位置与

    皇冠的点击是跳转到一个WebView,WebView通过一个UIViewController展示
    通过自定义初始化方法设置WebView的内容，并通过点语法调用创建WebView
    达到当前控制器可一句代码完成创建并显示
    由于顶部的导航栏是通过navBar的add方法添加，所以显示前要先将顶部导航栏移除并置空
 
 */


- (void)loadView
{
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //屏幕宽*3
    view.contentSize = CGSizeMake(ALinScreenWidth * 3, 0);
    view.backgroundColor = [UIColor whiteColor];
    // 去掉滚动条
    view.showsVerticalScrollIndicator = NO;
    view.showsHorizontalScrollIndicator = NO;
    // 设置分页
    view.pagingEnabled = YES;
    // 设置代理
    view.delegate = self;
    // 去掉弹簧效果
    view.bounces = NO;
    
    CGFloat height = ALinScreenHeight - 49;
    
    // 添加子视图
    ADHotViewController *hot = [[ADHotViewController alloc] init];
    hot.view.frame = [UIScreen mainScreen].bounds;
    hot.view.height = height;
    [self addChildViewController:hot];
    [view addSubview:hot.view];
    _hotVc = hot;
    
    
    ADNewStarViewController *newStar = [[ADNewStarViewController alloc] init];
    newStar.view.frame = [UIScreen mainScreen].bounds;
    newStar.view.x = ALinScreenWidth;
    newStar.view.height = height;
    [self addChildViewController:newStar];
    [view addSubview:newStar.view];
    _starVc = newStar;
    
    ADCareViewController *care = [UIStoryboard storyboardWithName:NSStringFromClass([ADCareViewController class]) bundle:nil].instantiateInitialViewController;
    care.view.frame = [UIScreen mainScreen].bounds;
    care.view.x = ALinScreenWidth * 2;
    care.view.height = height;
    [self addChildViewController:care];
    [view addSubview:care.view];
    _careVc = care;
    
    self.view = view;
    self.scrollView = view;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 基本设置
    [self setup];
}

- (void)setup
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_15x14"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"head_crown_24x24"] style:UIBarButtonItemStyleDone target:self action:@selector(rankCrown)];
    [self setupTopMenu];
}


- (void)rankCrown
{
    ADWebViewController *web = [[ADWebViewController alloc] initWithUrlStr:@"http://live.9158.com/Rank/WeekRank?Random=10"];
    web.navigationItem.title = @"排行";
    [_selectedView removeFromSuperview];
    _selectedView = nil;
    [self.navigationController pushViewController:web animated:YES];
}

-(void)setupTopMenu
{
    // 设置顶部选择视图
    ADSelectedView *selectedView = [[ADSelectedView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    selectedView.x = 45;
    selectedView.width = ALinScreenWidth - 45 * 2;
    [selectedView setSelectedBlock:^(HomeType type) {
        [self.scrollView setContentOffset:CGPointMake(type * ALinScreenWidth, 0) animated:YES];
    }];
    [self.navigationController.navigationBar addSubview:selectedView];
    _selectedView = selectedView;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat page = scrollView.contentOffset.x / ALinScreenWidth;
    CGFloat offsetX = scrollView.contentOffset.x / ALinScreenWidth * (self.selectedView.width * 0.5 - Home_Seleted_Item_W * 0.5 - 15);
    self.selectedView.underLine.x = 15 + offsetX;
    if (page == 1 ) {
        self.selectedView.underLine.x = offsetX + 10;
    }else if (page > 1){
        self.selectedView.underLine.x = offsetX + 5;
    }
    //滚动过一半就代表到达下一页
    self.selectedView.selectedType = (int)(page + 0.5);
}

@end
