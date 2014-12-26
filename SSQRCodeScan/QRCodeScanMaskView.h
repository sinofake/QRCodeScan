//
//  QRCodeScanMaskView.h
//  QRCode
//
//  Created by zhucuirong on 14/12/13.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRCodeScanMaskView : UIView
@property (nonatomic, assign) CGRect scanAreaRect;
@property (nonatomic, strong) UIColor *themeColor;
@property (nonatomic, strong) UIColor *scanAreaColor;


@end
