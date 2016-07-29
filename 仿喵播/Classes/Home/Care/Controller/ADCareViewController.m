
//
//  ADCareViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/26.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADCareViewController.h"

@interface ADCareViewController ()
@property (weak, nonatomic) IBOutlet UIButton *toSeeBtn;

@end

@implementation ADCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.toSeeBtn.layer.borderWidth = 1;
    self.toSeeBtn.layer.borderColor = KeyColor.CGColor;
    self.toSeeBtn.layer.cornerRadius = self.toSeeBtn.height * 0.5;
    [self.toSeeBtn.layer masksToBounds];
    
    [self.toSeeBtn setTitleColor:KeyColor forState:UIControlStateNormal];
}
- (IBAction)toSeeWorld:(UIButton *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyToseeBigWorld object:nil];
}


@end
