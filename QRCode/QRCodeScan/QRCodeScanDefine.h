//
//  QRCodeScanDefine.h
//  QRCode
//
//  Created by zhucuirong on 15/7/1.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#ifndef QRCode_QRCodeScanDefine_h
#define QRCode_QRCodeScanDefine_h

#define QRCode_UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define QRCode_SCREEN_BOUNDS                      [[UIScreen mainScreen]                                                                                                              bounds]
#define QRCode_SCREEN_WIDTH                       [[UIScreen mainScreen]                                                                                                           bounds].size.width
#define QRCode_SCREEN_HEIGHT                      [[UIScreen mainScreen]                                                                                                           bounds].size.height

#define QRCode_HORIZONTAL_LENGTH(l) round(l/1242.f * QRCode_SCREEN_WIDTH)
#define QRCode_VERTICAL_LENGTH(l) round(l/2208.f * QRCode_SCREEN_HEIGHT)

//整个扫描框的大小
#define QRCode_SCAN_BOX_FRAME       CGRectMake(185/1242.f * QRCode_SCREEN_WIDTH, 486/2208.f * QRCode_SCREEN_HEIGHT, QRCode_SCREEN_WIDTH - (185/1242.f * QRCode_SCREEN_WIDTH)*2.f, QRCode_SCREEN_WIDTH - (185/1242.f * QRCode_SCREEN_WIDTH)*2.f)

//里面扫描区域到扫描框的Padding
#define QRCode_SCAN_PADDING  QRCode_HORIZONTAL_LENGTH(43)

//红线上下扫动的区域
#define QRCode_SCAN_AREA_FRAME  UIEdgeInsetsInsetRect(QRCode_SCAN_BOX_FRAME, UIEdgeInsetsMake(QRCode_SCAN_PADDING, QRCode_SCAN_PADDING, QRCode_SCAN_PADDING, QRCode_SCAN_PADDING))

#define QRCode_iOSVersionEqualTo(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define QRCode_iOSVersionGreaterThan(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define QRCode_iOSVersionGreaterThanOrEqualTo(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define QRCode_iOSVersionLessThan(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define QRCode_iOSVersionLessThanOrEqualTo(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
