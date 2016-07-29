//
//  ADLiveCollectionViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADLiveCollectionViewController.h"
#import "ADLiveViewCell.h"
#import "ADRefreshGifHeader.h"
#import "ADLiveFlowLayout.h"
#import "ADUser.h"
#import "ADUserView.h"


/**
    当前collectionView展示时只有一个item,即为直播的界面内容
    详细设置在ADLiveViewCell中
 
    通过currentIndex来区分当前是哪一个页面，lives数组获取直播数据皆由外界赋值
    init初始化时即设置flowLayout,设置下拉刷新时操作为结束当前刷新
    而后currentIndex+1,若此时currentIndex等于lives.count代表是最后一个主播
    则currentIndex变为0，刷新当前collectionView
 
    用户的点击事件通过通知发布与接收，控制器负责接收通知后执行操作。
    操作为通过点语法生成一个userView,附带有点击关注等信息,通过 
    CGAffineTransformMakeScale与UIView动画结合完成动画效果
    先在点语法里令其初始化缩小为0.01倍而后点击事件中通过
    CGAffineTransformIdentify还原大小完成动画效果
    关闭事件通过block来调用
 
    直播的显示页面通过自定义cell(ADLiveViewCell)来展示
 
 */


@interface ADLiveCollectionViewController ()
/** 用户信息 */
@property(nonatomic, weak) ADUserView *userView;

@end

@implementation ADLiveCollectionViewController

static NSString * const reuseIdentifier = @"ADLiveViewCell";

-(instancetype)init{
    return [super initWithCollectionViewLayout:[[ADLiveFlowLayout alloc]init]];
}

-(ADUserView *)userView{
    
    if (!_userView) {
        
        ADUserView *userView = [ADUserView userView];
        [self.collectionView addSubview:userView];
        _userView = userView;
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
            make.width.equalTo(@(ALinScreenWidth));
            make.height.equalTo(@(ALinScreenHeight));
        }];
     
        userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        [userView setCloseBlock:^{
           
            [UIView animateWithDuration:0.5 animations:^{
                self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            } completion:^(BOOL finished) {
                [self.userView removeFromSuperview];
                self.userView = nil;
            }];
        }];
        
    }
    
    
    return _userView;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[ADLiveViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    ADRefreshGifHeader *header = [ADRefreshGifHeader headerWithRefreshingBlock:^{
       
        [self.collectionView.mj_header endRefreshing];
        self.currentIndex++;
        if (self.currentIndex == self.lives.count) {
            self.currentIndex = 0;
        }
        [self.collectionView reloadData];
    }];
    
    header.stateLabel.hidden = NO;
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStateIdle];
    self.collectionView.mj_header = header;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickUser:) name:kNotifyClickUser object:nil];
}

-(void)clickUser:(NSNotification *)notify{
    if (notify.userInfo[@"user"] != nil) {
        ADUser *user = notify.userInfo[@"user"];
        self.userView.user = user;
        [UIView animateWithDuration:0.5 animations:^{
            self.userView.transform = CGAffineTransformIdentity;
        }];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ADLiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.parentVc = self;
    cell.live = self.lives[self.currentIndex];
    
    //关联主播，若当前主播为最后一个则关联为第一个
    //否则就是下一个主播
    NSUInteger relateIndex = self.currentIndex;
    if (self.currentIndex +1 == self.lives.count) {
        relateIndex = 0;
    }else{
        relateIndex += 1;
    }

    cell.relateLive = self.lives[relateIndex];
    [cell setClickRelatedLive:^{
        self.currentIndex += 1;
        [self.collectionView reloadData];
    }];
    
    return cell;
}



@end
