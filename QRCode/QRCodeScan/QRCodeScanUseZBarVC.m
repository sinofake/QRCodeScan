//
//  MainViewController.m
//  QRCode
//
//  Created by zhucuirong on 14/12/11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "QRCodeScanUseZBarVC.h"
#import "ZBarSDK.h"
#import <AVFoundation/AVFoundation.h>
#import "QRCodeScanDefine.h"

@interface QRCodeScanUseZBarVC ()<ZBarReaderDelegate>

@end

@implementation QRCodeScanUseZBarVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.showsZBarControls = NO;
}

- (CGRect)getScanCropWithScanRect:(CGRect)rect andReaderViewBounds:(CGRect)rvBounds {
    CGFloat x,y,width,height;
    
    x = rect.origin.y / rvBounds.size.height;
    y = 1 - (rect.origin.x + rect.size.width) / rvBounds.size.width;
    width = rect.size.height / rvBounds.size.height;
    height = rect.size.width / rvBounds.size.width;
    
    return CGRectMake(x, y, width, height);
}

- (void)configureReaderView {
    self.readerDelegate = self;
    self.supportedOrientationsMask = UIInterfaceOrientationPortrait;
    self.videoQuality = UIImagePickerControllerQualityTypeHigh;
    self.readerView.session.sessionPreset = AVCaptureSessionPresetHigh;

    // EXAMPLE: disable rarely used I2/5 to improve performance
    [self.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    
    //关闭选中二维码时的绿色方框
    self.tracksSymbols = NO;
    
    //父类默认是UIImagePickerControllerCameraFlashModeAuto（自动）
    self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    
    //扫描区域计算
    self.readerView.scanCrop = [self getScanCropWithScanRect:QRCode_SCAN_BOX_FRAME andReaderViewBounds:self.readerView.bounds];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*扫描二维码部分：
     导入ZBarSDK文件并引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入头文件#import “ZBarSDK.h” 即可使用
     */
    
    [self configureReaderView];
}

#pragma mark - ZBarReaderDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    if ([info count]>2) {
        int quality = 0;
        ZBarSymbol *bestResult = nil;
        for(ZBarSymbol *sym in results) {
            int q = sym.quality;
            if(quality < q) {
                quality = q;
                bestResult = sym;
            }
        }
        [self performSelector: @selector(presentResult:) withObject: bestResult afterDelay: .001];
    }else {
        ZBarSymbol *symbol = nil;
        for(symbol in results)
            break;
        [self performSelector: @selector(presentResult:) withObject: symbol afterDelay: .001];
    }
    
    // EXAMPLE: do something useful with the barcode image
    //[info objectForKey: UIImagePickerControllerOriginalImage];
}

- (void) presentResult: (ZBarSymbol*)sym {
    if (sym) {
        NSString *tempStr = sym.data;
        if ([sym.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
            tempStr = [NSString stringWithCString:[tempStr cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        if ([self.scanDelegate respondsToSelector:@selector(QRCodeScanUseZBarVC:didScanContent:)]) {
            [self.scanDelegate QRCodeScanUseZBarVC:self didScanContent:tempStr];
        }
    }
}

//// called when no barcode is found in an image selected by the user.
//// if retry is NO, the delegate *must* dismiss the controller
//- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
//                             withRetry: (BOOL) retry {
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
