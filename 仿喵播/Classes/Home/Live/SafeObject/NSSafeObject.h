//
//  NSSafeObject.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/25.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSafeObject : NSObject


-(instancetype)initWithObject:(id)object;
-(instancetype)initWithObject:(id)object withSelector:(SEL)selector;
-(void)excute;

@end
