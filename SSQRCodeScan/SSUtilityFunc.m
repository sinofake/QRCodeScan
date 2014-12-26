//
//  UtilityFunc.m
//  QRCode
//
//  Created by zhucuirong on 14/12/12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "SSUtilityFunc.h"

@implementation SSUtilityFunc

+ (UIEdgeInsets)edgeInsetsWithType:(SSEdgeInsetsType)type viewSize:(CGSize)viewSize subsidiaryViewSize:(CGSize)subsidiaryViewSize margin:(CGFloat)margin {
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero;
    
    CGFloat horizontalDelta = (viewSize.width - subsidiaryViewSize.width)/2.f - margin;
    
    CGFloat vertivalDelta = (viewSize.height - subsidiaryViewSize.height)/2.f - margin;
    
    int horizontalSignFlag = 1;
    int verticalSignFlag = 1;
    
    switch (type) {
        case SSEdgeInsetsTypeTop:
        {
            horizontalSignFlag = 0;
            verticalSignFlag = -1;
        }
            break;
        case SSEdgeInsetsTypeLeft:
        {
            horizontalSignFlag = -1;
            verticalSignFlag = 0;
        }
            break;
        case SSEdgeInsetsTypeBottom:
        {
            horizontalSignFlag = 0;
            verticalSignFlag = 1;
        }
            break;
        case SSEdgeInsetsTypeRight:
        {
            horizontalSignFlag = 1;
            verticalSignFlag = 0;
        }
            break;
        case SSEdgeInsetsTypeLeftTop:
        {
            horizontalSignFlag = -1;
            verticalSignFlag = -1;
        }
            break;
        case SSEdgeInsetsTypeLeftBottom:
        {
            horizontalSignFlag = -1;
            verticalSignFlag = 1;
        }
            break;
        case SSEdgeInsetsTypeRightTop:
        {
            horizontalSignFlag = 1;
            verticalSignFlag = -1;
        }
            break;
        case SSEdgeInsetsTypeRightBottom:
        {
            horizontalSignFlag = 1;
            verticalSignFlag = 1;
        }
            break;
            
        default:
            break;
    }
    edgeInsets = UIEdgeInsetsMake(vertivalDelta * verticalSignFlag, horizontalDelta * horizontalSignFlag, -vertivalDelta * verticalSignFlag, -horizontalDelta * horizontalSignFlag);
    return edgeInsets;
}


@end
