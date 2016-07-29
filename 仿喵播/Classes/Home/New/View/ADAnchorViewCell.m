//
//  ADAnchorViewCell.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/26.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "ADAnchorViewCell.h"



@interface ADAnchorViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverView;

@property (weak, nonatomic) IBOutlet UIImageView *star;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@end

@implementation ADAnchorViewCell

-(void)setUser:(ADUser *)user{
    
    _user = user;
    //设置封面头像
    [_coverView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    //是否是新主播
    self.star.hidden = !user.newStar;
    //地址
    [self.locationBtn setTitle:user.position forState:UIControlStateNormal];
    //主播名
    self.nickNameLabel.text = user.nickname;
    
    
}

@end
