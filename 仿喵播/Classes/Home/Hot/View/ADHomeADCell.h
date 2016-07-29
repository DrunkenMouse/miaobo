//
//  ADHomeADCell.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XRCarouselView/XRCarouselView.h"

@class ADTopAD;
@interface ADHomeADCell : UITableViewCell<XRCarouselViewDelegate>

//顶部AD数组
@property(nonatomic,strong) NSArray *topADs;
//点击图片的block
@property(nonatomic,copy) void (^imageClickBlock)(ADTopAD *topAD);

@end
