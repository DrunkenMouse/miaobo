//
//  ADLiveViewCell.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/25.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADInLive,ADUser;
@interface ADLiveViewCell : UICollectionViewCell

/** 直播 */
@property(nonatomic, strong) ADInLive *live;
/** 相关的直播或者主播 */
@property(nonatomic, strong) ADInLive *relateLive;
/** 父控制器 */
@property(nonatomic, weak) UIViewController *parentVc;
/** 点击关联主播 */
@property(nonatomic, copy) void (^clickRelatedLive)();
@end
