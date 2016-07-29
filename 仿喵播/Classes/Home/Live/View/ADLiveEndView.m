//
//  ADLiveEndView.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/25.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADLiveEndView.h"

@interface ADLiveEndView()

@property (weak, nonatomic) IBOutlet UIButton *quitBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookOtherBtn;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;

@end

@implementation ADLiveEndView


-(void)awakeFromNib{
    
    [super awakeFromNib];
    [self maskRadius:self.quitBtn];
    [self maskRadius:self.lookOtherBtn];
    [self maskRadius:self.careBtn];

}

+(instancetype)liveEndView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

-(void)maskRadius:(UIButton *)btn{
    
    btn.layer.cornerRadius = btn.height * 0.5;
    btn.layer.masksToBounds = YES;
    if (btn != self.careBtn) {
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = KeyColor.CGColor;
        
    }
}



- (IBAction)care:(UIButton *)sender {
    [sender setTitle:@"关注成功" forState:UIControlStateNormal];
}

- (IBAction)lookOther:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.lookOtherBlock) {
        self.lookOtherBlock();
    }
}

- (IBAction)quit:(UIButton *)sender {

    if (self.quitBlock) {
        self.quitBlock();
    }
}

@end
