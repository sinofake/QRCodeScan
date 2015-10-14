//
//  QRCodeScanViewControllerSystem.m
//  QRCode
//
//  Created by zhucuirong on 15/2/3.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "QRCodeScanUseSystemVC.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCodeScanUseSystemVC ()<AVCaptureMetadataOutputObjectsDelegate>
@property (strong, nonatomic) AVCaptureDevice            *defaultDevice;
@property (strong, nonatomic) AVCaptureDeviceInput       *defaultDeviceInput;
@property (strong, nonatomic) AVCaptureMetadataOutput    *metadataOutput;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@end

@implementation QRCodeScanUseSystemVC

- (void)setupAVComponents {
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (_defaultDevice) {
        self.defaultDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_defaultDevice error:nil];
        self.metadataOutput     = [[AVCaptureMetadataOutput alloc] init];
        self.session            = [[AVCaptureSession alloc] init];
        self.previewLayer       = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    }
}

- (void)configureDefaultComponents {
    [_session addOutput:_metadataOutput];
    
    if (_defaultDeviceInput) {
        [_session addInput:_defaultDeviceInput];
    }
    
    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //    if ([[_metadataOutput availableMetadataObjectTypes] containsObject:AVMetadataObjectTypeQRCode]) {
    //        [_metadataOutput setMetadataObjectTypes:@[ AVMetadataObjectTypeQRCode]];
    //    }
    NSArray *metadataObjectTypes = @[AVMetadataObjectTypeUPCECode,
                                     AVMetadataObjectTypeCode39Code,
                                     AVMetadataObjectTypeCode39Mod43Code,
                                     AVMetadataObjectTypeEAN13Code,
                                     AVMetadataObjectTypeEAN8Code,
                                     AVMetadataObjectTypeCode93Code,
                                     AVMetadataObjectTypeCode128Code,
                                     AVMetadataObjectTypePDF417Code,
                                     AVMetadataObjectTypeQRCode];
    [_metadataOutput setMetadataObjectTypes:metadataObjectTypes];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_previewLayer setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupAVComponents];
    [self configureDefaultComponents];
}

- (void)startScanning {
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

- (void)stopScanning {
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for(AVMetadataObject *current in metadataObjects) {
        if ([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            //[current.type isEqualToString:AVMetadataObjectTypeQRCode]
            NSString *scannedResult = [(AVMetadataMachineReadableCodeObject *)current stringValue];
            
            [self stopScanning];
            
            if ([self.scanDelegate respondsToSelector:@selector(QRCodeScanUseSystemVC:didScanContent:)]) {
                [self.scanDelegate QRCodeScanUseSystemVC:self didScanContent:scannedResult];
            }
            break;
        }
    }
}

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
