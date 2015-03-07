//
//  QRCodeScanViewControllerSystem.h
//  QRCode
//
//  Created by zhucuirong on 15/2/3.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRCodeScanUseSystemVC;

@protocol QRCodeScanUseSystemVCDelegate <NSObject>

- (void)QRCodeScanUseSystemVC:(QRCodeScanUseSystemVC *)viewController didScanContent:(NSString *)content;
@end

@interface QRCodeScanUseSystemVC : UIViewController
@property (nonatomic, weak) id <QRCodeScanUseSystemVCDelegate> scanDelegate;
- (void)startScanning;
- (void)stopScanning;

@end
