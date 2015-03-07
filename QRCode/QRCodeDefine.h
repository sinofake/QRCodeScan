//
//  QRCodeDefine.h
//  QRCode
//
//  Created by zhucuirong on 15/2/3.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#ifndef QRCode_QRCodeDefine_h
#define QRCode_QRCodeDefine_h

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

#define SCREEN_BOUNDS                   [[UIScreen mainScreen]                                                                                                              bounds]
#define SCREEN_WIDTH                       [[UIScreen mainScreen]                                                                                                           bounds].size.width
#define SCREEN_HEIGHT                      [[UIScreen mainScreen]                                                                                                           bounds].size.height
#define HORIZONTAL_LENGTH(l) round(l/1242.f * SCREEN_WIDTH)
#define VERTICAL_LENGTH(l) round(l/2208.f * SCREEN_HEIGHT)

#define SCAN_PADDING HORIZONTAL_LENGTH(43)

#define SCAN_BOX_FRAME       CGRectMake(185/1242.f * SCREEN_WIDTH, 486/2208.f * SCREEN_HEIGHT, SCREEN_WIDTH - (185/1242.f * SCREEN_WIDTH)*2.f, SCREEN_WIDTH - (185/1242.f * SCREEN_WIDTH)*2.f)

#define SCAN_AREA_FRAME  UIEdgeInsetsInsetRect(SCAN_BOX_FRAME, UIEdgeInsetsMake(SCAN_PADDING, SCAN_PADDING, SCAN_PADDING, SCAN_PADDING));

#define iOSVersionEqualTo(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define iOSVersionGreaterThan(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define iOSVersionGreaterThanOrEqualTo(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define iOSVersionLessThan(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define iOSVersionLessThanOrEqualTo(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif
