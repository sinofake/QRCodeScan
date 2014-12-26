//
//  MainViewController.h
//  QRCode
//
//  Created by zhucuirong on 14/12/11.
//  Copyright (c) 2014年 elong. All rights reserved.
//


#import "ZBarReaderViewController.h"
@class QRCodeViewController;

@protocol QRCodeViewControllerDelegate <NSObject>

- (void)QRCodeViewController:(QRCodeViewController *)viewController didScanContent:(NSString *)content;

@end

/*扫描二维码部分：
 导入ZBarSDK文件并引入一下框架
 AVFoundation.framework
 CoreMedia.framework
 CoreVideo.framework
 QuartzCore.framework
 libiconv.dylib
 */

@interface QRCodeViewController : ZBarReaderViewController
@property (nonatomic, assign) id <QRCodeViewControllerDelegate> scanDelegate;

@end
