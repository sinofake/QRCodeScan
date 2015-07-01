//
//  QRCodeScanVC.h
//  QRCode
//
//  Created by zhucuirong on 15/2/3.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRCodeScanViewController;

@protocol QRCodeScanViewControllerDelegate <NSObject>

- (void)QRCodeScanViewController:(QRCodeScanViewController *)viewController didScanContent:(NSString *)content;

@end

@interface QRCodeScanViewController : UIViewController
@property (nonatomic, weak) id<QRCodeScanViewControllerDelegate> delegate;

@end
