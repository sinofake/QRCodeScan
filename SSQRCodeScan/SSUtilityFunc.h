//
//  UtilityFunc.h
//  QRCode
//
//  Created by zhucuirong on 14/12/12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SS_HORIZONTAL_LENGTH(l) round(l/1242.f * SCREEN_WIDTH)
#define SS_VERTICAL_LENGTH(l) round(l/2208.f * SCREEN_HEIGHT)

typedef NS_ENUM(NSInteger, SSEdgeInsetsType) {
    SSEdgeInsetsTypeTop         = 0,
    SSEdgeInsetsTypeLeft        = 1,
    SSEdgeInsetsTypeBottom      = 2,
    SSEdgeInsetsTypeRight       = 3,
    SSEdgeInsetsTypeLeftTop     = 4,
    SSEdgeInsetsTypeLeftBottom  = 5,
    SSEdgeInsetsTypeRightTop    = 6,
    SSEdgeInsetsTypeRightBottom = 7
};

@interface SSUtilityFunc : NSObject

+ (UIEdgeInsets)edgeInsetsWithType:(SSEdgeInsetsType)type viewSize:(CGSize)viewSize subsidiaryViewSize:(CGSize)subsidiaryViewSize margin:(CGFloat)margin;

@end
