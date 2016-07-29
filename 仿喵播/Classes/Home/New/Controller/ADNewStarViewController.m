//
//  ADNewStarViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/26.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADNewStarViewController.h"
#import "ADUser.h"
#import "ADAnchorViewCell.h"
#import "ADHomeFlowLayout.h"
#import "ADRefreshGifHeader.h"
#import "ADLiveCollectionViewController.h"
#import "ADInLive.h"

@interface ADNewStarViewController ()

/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *anchors;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation ADNewStarViewController

static NSString * const reuseIdentifier = @"NewStarCell";


-(NSMutableArray *)anchors{
    if (!_anchors) {
        _anchors = [NSMutableArray array];
    }
    return _anchors;
}

-(instancetype)init{
    
    return [super initWithCollectionViewLayout:[[ADHomeFlowLayout alloc] init]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

-(void)setup{
    
    //默认当前页从1开始的
    self.currentPage = 1;
    //注册cell
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ADAnchorViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
  
    //设置header和footer
    self.collectionView.mj_header = [ADRefreshGifHeader headerWithRefreshingBlock:^{
       
        self.currentPage = 1;
        self.anchors = [NSMutableArray array];
        [self getAnchorsList];
        
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getAnchorsList];
    }];
    [self.collectionView.mj_header beginRefreshing];
  
    
}


-(void)getAnchorsList{
    
    [[ADNetWorkTool shareTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSString *statuMsg = responseObject[@"msg"];
        //如果数据已经加载完毕,没有更多数据
        if ([statuMsg isEqualToString:@"fail"]) {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            [self showHit:@"暂时没有更多最新数据"];
            //回复当前页
            self.currentPage -- ;
        }else{
            [responseObject[@"data"][@"list"] writeToFile:@"/Users/apple/Desktop/user.plist" atomically:YES];
            NSArray *result = [ADUser mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (result.count) {
                [self.anchors addObjectsFromArray:result];
                [self.collectionView reloadData];
            }
        }
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.currentPage--;
        [self showHit:@"网络异常"];
    }];
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return  self.anchors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ADAnchorViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.user = self.anchors[indexPath.item];
    return cell;
    
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ADLiveCollectionViewController *liveVc = [[ADLiveCollectionViewController alloc]init];
    
    NSMutableArray *array = [NSMutableArray array];
    for (ADUser *user in self.anchors) {
        ADInLive *live = [[ADInLive alloc]init];
        live.bigpic = user.photo;
        live.myname = user.nickname;
        live.smallpic = user.photo;
        live.gps = user.position;
        live.useridx = user.useridx;
        live.allnum = arc4random_uniform(2000);
        live.flv = user.flv;
        [array addObject:live];
    }
    liveVc.lives = array;
    liveVc.currentIndex = indexPath.item;
    [self presentViewController:liveVc animated:YES completion:nil];
}



@end
