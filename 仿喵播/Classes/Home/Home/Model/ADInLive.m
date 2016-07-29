//
//  ADInLive.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADInLive.h"

@implementation ADInLive

-(UIImage *)starImage{
    if (self.starlevel) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"girl_star%ld_40x19",self.starlevel]];
    }
    return nil;
}
@end
