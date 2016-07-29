//
//  ADUser.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADUser : NSObject

//直播地址
@property(nonatomic,copy)NSString *flv;

//昵称
@property(nonatomic,copy)NSString *nickname;

//照片地址
@property(nonatomic,copy)NSString *photo;

//所在地区
@property(nonatomic,copy)NSString *position;

//房间号
@property(nonatomic,copy)NSString *roomid;

//用户id
@property(nonatomic,copy)NSString *useridx;

//是否是新人
@property(nonatomic,assign)NSUInteger newStar;

//服务器号
@property(nonatomic,assign)NSUInteger serverid;

//性别
@property(nonatomic,assign)NSUInteger sex;

//等级
@property(nonatomic,assign)NSUInteger starlevel;
@end
