//
//  UtilityFunc.h
//  QRCode
//
//  Created by zhucuirong on 14/12/12.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <Foundation/Foundation.h>

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

typedef NS_ENUM(NSInteger, SSCreditCardEncryptType) {
    SSCreditCardEncryptTypeIDCard,//身份证号码
    SSCreditCardEncryptTypeNotIDCard,//非身份证证件
    SSCreditCardEncryptTypeCreditCardNumber,//信用卡号
    SSCreditCardEncryptTypeValidDate,//有效期
    SSCreditCardEncryptTypeHolderName//持卡人姓名
};


@interface SSUtilityFunc : NSObject

+ (UIEdgeInsets)edgeInsetsWithType:(SSEdgeInsetsType)type viewSize:(CGSize)viewSize subsidiaryViewSize:(CGSize)subsidiaryViewSize margin:(CGFloat)margin;


@end
