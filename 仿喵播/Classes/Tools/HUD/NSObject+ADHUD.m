//
//  NSObject+ADHUD.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/22.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "NSObject+ADHUD.h"

@implementation NSObject (ADHUD)

-(void)showInfo:(NSString *)info{
    
    if ([self isKindOfClass:[UIViewController class]] || [self isKindOfClass:[UIView class]]) {
        [[[UIAlertView alloc]initWithTitle:@"喵播" message:info delegate:nil cancelButtonTitle:@"好~" otherButtonTitles:nil, nil]show];
    }
    
}

@end
