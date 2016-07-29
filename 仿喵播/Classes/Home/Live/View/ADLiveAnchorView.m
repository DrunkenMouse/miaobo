//
//  ADLiveAnchorView.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADLiveAnchorView.h"
#import "ADInLive.h"
#import "ADUser.h"
#import "UIImage+ADExtension.h"
#import <UIImageView+WebCache.h>

@interface ADLiveAnchorView()

@property (weak, nonatomic) IBOutlet UIView *anchorView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *peopleScrollView;

@property (weak, nonatomic) IBOutlet UIButton *giftView;

@property(strong, nonatomic) NSTimer *timer;
@property(strong, nonatomic) NSArray *chaoYangeUsers;

@end


@implementation ADLiveAnchorView

-(NSArray *)chaoYangeUsers{
    if (!_chaoYangeUsers) {
        
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]];
        
        _chaoYangeUsers = [ADUser mj_objectArrayWithKeyValuesArray:array];
    }
    return _chaoYangeUsers;
}


+(instancetype)liveAnchorView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}


-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self maskViewToBounds:self.anchorView];
    [self maskViewToBounds:self.headImageView];
    [self maskViewToBounds:self.careBtn];
    [self maskViewToBounds:self.giftView];
    
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:KeyColor size:self.careBtn.size] forState:UIControlStateNormal];
 
    [self.careBtn setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:self.careBtn.size] forState:UIControlStateSelected];
    [self setupChangeyang];
    //默认是关闭的
    [self Device:self.careBtn];
}



-(void)maskViewToBounds:(UIView *)view{
  
    view.layer.cornerRadius = view.height * 0.5;
    view.layer.masksToBounds = YES;
    
}

static int randomNum = 0;

-(void)setLive:(ADInLive *)live{
    
    _live = live;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:live.smallpic]placeholderImage:[UIImage imageNamed:@"placeholder_head"]];

    self.nameLabel.text = live.myname;
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人",live.allnum];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateNum) userInfo:nil repeats:YES];
    self.headImageView.userInteractionEnabled = YES;
    [self.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChangYang:)]];
    
}

-(void)updateNum{
    
    randomNum += arc4random_uniform(5);
    self.peopleLabel.text = [NSString stringWithFormat:@"%ld人",self.live.allnum + randomNum];
    [self.giftView setTitle:[NSString stringWithFormat:@"猫粮:%u 娃娃:%u",1993045 + randomNum,124593 + randomNum] forState:UIControlStateNormal];
    
    
}

-(void)setupChangeyang{
    
    self.peopleScrollView.contentSize = CGSizeMake((self.peopleScrollView.height + DefaultMargin) * self.chaoYangeUsers.count + DefaultMargin, 0);
    
    CGFloat width = self.peopleScrollView.height - 10;
    CGFloat x = 0;
    for (int i = 0; i < self.chaoYangeUsers.count; i++) {
        x = 0 + (DefaultMargin + width) * i;
        UIImageView * userView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 5, width, width)];
      
        userView.layer.cornerRadius = width * 0.5;
        userView.layer.masksToBounds = YES;
        ADUser *user = self.chaoYangeUsers[i];
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:user.photo] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                userView.image = [UIImage circleImage:image borderColor:[UIColor whiteColor] borderWidth:1];
                
            });
            
        }];
       
        //设置监听
        userView.userInteractionEnabled = YES;
        [userView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickChangYang:)]];
        userView.tag = i;
        [self.peopleScrollView addSubview:userView];
    }
    
}


-(void)clickChangYang:(UITapGestureRecognizer *)tapGes{
  
    if (tapGes.view == self.headImageView) {
        
        ADUser *user = [[ADUser alloc]init];
        user.nickname = self.live.myname;
        user.photo = self.live.bigpic;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"user" : user}];
        
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyClickUser object:nil userInfo:@{@"user" : self.chaoYangeUsers[tapGes.view.tag]}];
    }
}



- (IBAction)Device:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    if (self.clickDeviceShow) {
        self.clickDeviceShow(sender.selected);
    }
    
}




@end
