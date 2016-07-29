//
//  ADLiveCollectionViewController.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADInLive;


@interface ADLiveCollectionViewController : UICollectionViewController
/** 直播 */
@property(nonatomic, strong) NSArray *lives;
/** 当前的index */
@property(nonatomic, assign) NSUInteger currentIndex;

@end
