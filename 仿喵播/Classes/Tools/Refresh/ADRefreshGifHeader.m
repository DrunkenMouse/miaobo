//
//  ADRefreshGifHeader.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADRefreshGifHeader.h"

@implementation ADRefreshGifHeader
-(instancetype)init{
    
    if (self = [super init]) {
        self.lastUpdatedTimeLabel.hidden = YES;
        self.stateLabel.hidden = YES;
    
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"],[UIImage imageNamed:@"reflesh2_60x55"],[UIImage imageNamed:@"reflesh3_60x55"]] forState:MJRefreshStateRefreshing];
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"],[UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]] forState:MJRefreshStatePulling];
        [self setImages:@[[UIImage imageNamed:@"reflesh1_60x55"], [UIImage imageNamed:@"reflesh2_60x55"], [UIImage imageNamed:@"reflesh3_60x55"]]  forState:MJRefreshStateIdle];

        
        
        
    }
    return self;
}








@end
