//
//  ADHotViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/23.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADHotViewController.h"
#import "ADHotLiveCell.h"
#import "ADInLive.h"
#import "ADRefreshGifHeader.h"
#import "ADTopAD.h"
#import "ADHotLiveCell.h"
#import "ADHomeADCell.h"
#import "ADWebViewController.h"
#import "ADLiveCollectionViewController.h"

@interface ADHotViewController ()

/**
    广告轮播图展示使用的XRCarouselView，下拉刷新上拉加载使用的MJ
    下拉刷新是自定义继承了MJ的RefreshGifHeader,在通过MJ的Block设置时
    Block内部会调用[[self alloc]init],所以通过继承后重写init完成初始化
 
    页数初始化为1，当获取广告数据与直播数组数据时需要作为参数发送
    上拉刷新时页数为1，并重定义直播数组，获取顶部广告与直播数组数据
    下拉加载时页数加1，并获取直播数组数据
 
    获取直播数组数据时停止上拉、下拉的刷新状态，新数据添加到当前数组
    页数减1恢复到原来值
 
    tableViewCell的第一行为广告，其余为直播展示。
    广告图片的点击是跳转到一个WebView，通过请求回来的广告信息中的URL跳转
    并设置NavTitle的titile值
 
    直播视图的图片是通过网络请求获取的图片
    直播时的视频页面是通过控制器来展示
    直播视图的点击事件通过tableView的点击事件来响应
    点击后跳转到另一个控制器展示直播(ADLiveCollectionViewController)
    展示直播的控制器是CollectionViewController类型，用于滑动切换不同主播
 
 */

/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** 直播 */
@property(nonatomic, strong) NSMutableArray *lives;
/** 广告 */
@property(nonatomic, strong) NSArray *topADS;

@end

static NSString *reuseIdentifier = @"ADHotLiveCell";
static NSString *ADReuseIdentifier = @"ADHomeADCell";

@implementation ADHotViewController

-(NSMutableArray *)lives{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setup];
}

-(void)setup{

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ADHotLiveCell class]) bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    [self.tableView registerClass:[ADHomeADCell class] forCellReuseIdentifier:ADReuseIdentifier];

    
    
    self.currentPage = 1;
    self.tableView.mj_header = [ADRefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        //获取顶部的广告
        [self getTopAD];
        [self getHotLiveList];
    }];
    
//
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getHotLiveList];
    }];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(void)getTopAD{
   
    
    [[ADNetWorkTool shareTool] GET:@"http://live.9158.com/Living/GetAD" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *result = responseObject[@"data"];
        if ([self isNotEmpty:result]) {
            self.topADS = [ADTopAD mj_objectArrayWithKeyValuesArray:result];
            [self.tableView reloadData];
        }else{
            [self showHit:@"网络异常"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHit:@"网络异常"];
    }];
    
 
    
}

-(void)getHotLiveList{
    
    [[ADNetWorkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        NSArray *result = [ADInLive mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if ([self isNotEmpty:result]) {
            [self.lives addObjectsFromArray:result];
            [self.tableView reloadData];
        }else{
            [self showHit:@"暂时没有更多最新数据"];
            //回复当前页
            self.currentPage--;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.currentPage--;
        [self showHit:@"网络异常"];
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lives.count + 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    return 465;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        ADHomeADCell *cell = [tableView dequeueReusableCellWithIdentifier:ADReuseIdentifier];
        if (self.topADS.count) {
            cell.topADs = self.topADS;
            [cell setImageClickBlock:^(ADTopAD *topAD) {
                if (topAD.link.length) {
                    ADWebViewController *web = [[ADWebViewController alloc]initWithUrlStr:topAD.link];
                    web.navigationItem.title = topAD.title;
                    [self.navigationController pushViewController:web animated:YES];
                }
            }];
        }
        return cell;
    }
    
    ADHotLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (self.lives.count) {
        ADInLive *live = self.lives[indexPath.row - 1];
        cell.live = live;
    }
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ADLiveCollectionViewController *liveVc = [[ADLiveCollectionViewController alloc]init];
    liveVc.lives = self.lives;
    liveVc.currentIndex = indexPath.row -1;
    [self presentViewController:liveVc animated:YES completion:nil];
    
}













@end
