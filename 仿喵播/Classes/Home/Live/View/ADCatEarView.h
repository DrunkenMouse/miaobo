//
//  ADCatEarView.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/25.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADInLive;

@interface ADCatEarView : UIView
/** 主播/主播 */
@property(nonatomic, strong) ADInLive *live;

+(instancetype)catEarView;
@end
