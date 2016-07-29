//
//  ADHomeADCell.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADHomeADCell.h"
#import "ADTopAD.h"

@implementation ADHomeADCell

/**
    广告的展示是自己写的轮播图
    通过代理方法响应图片的点击事件,在点击事件里通过block执行点击操作
 */
-(void)setTopADs:(NSArray *)topADs{
    
    _topADs = topADs;
    
    NSMutableArray *imageUrls = [NSMutableArray array];
    
    for (ADTopAD *topAD in topADs) {
        [imageUrls addObject:topAD.imageUrl];
    }

    XRCarouselView *view = [XRCarouselView carouselViewWithImageArray:imageUrls describeArray:nil];
    view.time = 2.0;
    view.delegate = self;
    view.frame = self.contentView.bounds;
    [self.contentView addSubview:view];
    
}

#pragma mark - XRCarouselViewDelegate
-(void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index{
    if (self.imageClickBlock) {
        self.imageClickBlock(self.topADs[index]);
    }
}


@end
