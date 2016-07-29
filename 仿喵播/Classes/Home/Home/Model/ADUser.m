//
//  ADUser.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADUser.h"
#import <MJExtension/MJExtension.h>

@implementation ADUser

//转模型的时候，属性名与系统名重名
//把属性名newStar转换成系统名new
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"newStar":@"new"};
    
}
@end
