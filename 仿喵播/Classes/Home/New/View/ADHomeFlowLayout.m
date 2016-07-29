//
//  ADHomeFlowLayout.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/26.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADHomeFlowLayout.h"

@implementation ADHomeFlowLayout


-(void)prepareLayout{
    [super prepareLayout];
    
    
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    CGFloat wh = (ALinScreenWidth - 3) / 3.0;
    self.itemSize = CGSizeMake(wh, wh);
    self.minimumLineSpacing = 1;
    self.minimumInteritemSpacing = 1;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.alwaysBounceVertical = YES;
}

@end
