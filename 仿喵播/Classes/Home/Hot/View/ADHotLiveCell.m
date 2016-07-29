//
//  ADHotLiveCell.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADHotLiveCell.h"
#import "ADInLive.h"
#import "UIImage+ADExtension.h"
//SDWebImage
#import <UIImageView+WebCache.h>

@interface ADHotLiveCell()

@property (weak, nonatomic) IBOutlet UIImageView *HeadImageView;

@property (weak, nonatomic) IBOutlet UILabel *ChaoYangeLabel;

@property (weak, nonatomic) IBOutlet UILabel *NameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *StartView;

@property (weak, nonatomic) IBOutlet UIButton *LocationBtn;

@property (weak, nonatomic) IBOutlet UIImageView *BigPicView;

@end

@implementation ADHotLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setLive:(ADInLive *)live{
    
    _live = live;
    [self.HeadImageView sd_setImageWithURL:[NSURL URLWithString:live.smallpic] placeholderImage:[UIImage imageNamed:@"placeholder_head"] options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        image = [UIImage circleImage:image borderColor:[UIColor redColor] borderWidth:1];
        self.HeadImageView.image = image;
    }];
    
    self.NameLabel.text = live.myname;
    //如果没有地址，给个默认的地址
    if (!live.gps.length) {
        live.gps = @"喵星";
    }
   
    
    [self.LocationBtn setTitle:live.gps forState:UIControlStateNormal];
    [self.BigPicView sd_setImageWithURL:[NSURL URLWithString:live.bigpic] placeholderImage:[UIImage imageNamed:@"profile_user_414x414"]];
    self.StartView.image = live.starImage;
    self.StartView.hidden = !live.starlevel;
    
    //设置当前观众数量
    NSString *fullChaoyang = [NSString stringWithFormat:@"%ld人在看",live.allnum];
    NSRange range = [fullChaoyang rangeOfString:[NSString stringWithFormat:@"%ld",live.allnum]];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:fullChaoyang];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:range];
    [attr addAttribute:NSForegroundColorAttributeName value:KeyColor range:range];
    self.ChaoYangeLabel.attributedText = attr;
    
}




@end
