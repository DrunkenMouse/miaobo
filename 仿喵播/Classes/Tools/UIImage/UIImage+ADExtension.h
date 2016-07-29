//
//  UIImage+ADExtension.h
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ADExtension)
/**
 *  生成一张高斯模糊的图片
 *
 *  @param image 原图
 *  @param blur  模糊程度 (0~1)
 *
 *  @return 高斯模糊图片
 */
+(UIImage *)blurImage:(UIImage *)image blur:(CGFloat)blur;

/**
 *  根据颜色生成一张图片
 *
 *  @param color 颜色
 *  @param size  图片大小
 *
 *  @return 图片
 */
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  生成圆角的图片
 *
 *  @param originImage 原始图片
 *  @param borderColor 边框原色
 *  @param borderWidth 边框宽度
 *
 *  @return 圆形图片
 */
+(UIImage *)circleImage:(UIImage *)originImage borderColor:(UIColor*)borderColor borderWidth:(CGFloat)borderWidth;

@end
