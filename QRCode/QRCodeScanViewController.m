//
//  QRCodeScanVC.m
//  QRCode
//
//  Created by zhucuirong on 15/2/3.
//  Copyright (c) 2015年 elong. All rights reserved.
//

#import "QRCodeScanViewController.h"
#import "QRCodeScanUseZBarVC.h"
#import "QRCodeScanUseSystemVC.h"
#import "QRCodeScanMaskView.h"
#import "SSUtilityFunc.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderView.h"

@interface QRCodeScanViewController ()<QRCodeScanUseZBarVCDelegate, QRCodeScanUseSystemVCDelegate>
@property (nonatomic, strong) QRCodeScanUseZBarVC   *scanUseZBarVC;
@property (nonatomic, strong) QRCodeScanUseSystemVC *scanUseSystemVC;

@property (strong, nonatomic) AVCaptureDevice    *defaultDevice;
@property (nonatomic, assign) AVCaptureTorchMode torchMode;
@property (nonatomic, strong) UIButton           *torchBtn;

@property (nonatomic, strong) UIImageView        *scanRedLineImgView;
@property (nonatomic, strong) UIImageView        *scanBoxImgView;
@property (nonatomic, assign) BOOL               scanRedLineCanAnimation;
@property (nonatomic, assign) BOOL               isCameraDeviceAvailable;


@end

@implementation QRCodeScanViewController

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_0
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#endif

- (void)createScanViewController {
    UIViewController *childVC;
    if (iOSVersionGreaterThanOrEqualTo(@"7")) {
        _scanUseSystemVC = [[QRCodeScanUseSystemVC alloc] init];
        _scanUseSystemVC.scanDelegate = self;
        childVC = _scanUseSystemVC;
    }
    else {
        _scanUseZBarVC = [[QRCodeScanUseZBarVC alloc] init];
        _scanUseZBarVC.scanDelegate = self;
        childVC = _scanUseZBarVC;
    }
    [self addChildViewController:childVC];
    childVC.view.frame = self.view.frame;
    [self.view addSubview:childVC.view];
    [childVC didMoveToParentViewController:self];
    self.view.gestureRecognizers = childVC.view.gestureRecognizers;
}

- (void)createScanMaskView {
    QRCodeScanMaskView *maskView = [[QRCodeScanMaskView alloc] initWithFrame:self.view.bounds];
    maskView.scanAreaRect = SCAN_AREA_FRAME;
    [self.view addSubview:maskView];
}

- (void)createNavigationView {
    CGFloat originY = 20.f;
    UIButton *navBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navBackBtn setFrame:CGRectMake(0, originY, 80, 44)];
    UIImage *navBackImg = [UIImage imageNamed:@"QRCode_back"];
    [navBackBtn setImage:navBackImg forState:UIControlStateNormal];
    
    navBackBtn.imageEdgeInsets = [SSUtilityFunc edgeInsetsWithType:SSEdgeInsetsTypeLeft viewSize:navBackBtn.frame.size subsidiaryViewSize:navBackImg.size margin:HORIZONTAL_LENGTH(30)];
    
    [navBackBtn addTarget:self action:@selector(navBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBackBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, originY, SCREEN_WIDTH - 100 * 2, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = UIColorFromHex(0xffffff);
    
    titleLabel.text = @"扫一扫";
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    _torchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat lightBtnWidth = 60.f;
    _torchBtn.frame = CGRectMake(SCREEN_WIDTH - lightBtnWidth, originY, lightBtnWidth, 44);
    UIImage *lightImg = [UIImage imageNamed:@"QRCode_light"];
    [_torchBtn setImage:lightImg forState:UIControlStateNormal];
    
    _torchBtn.imageEdgeInsets = [SSUtilityFunc edgeInsetsWithType:SSEdgeInsetsTypeRight viewSize:_torchBtn.frame.size subsidiaryViewSize:lightImg.size margin:SCAN_PADDING];
    
    [_torchBtn addTarget:self action:@selector(lightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_torchBtn];
    
    if ([self.defaultDevice hasTorch]) {
        self.torchBtn.hidden = NO;
    }
    else {
        self.torchBtn.hidden = YES;
    }
}

#pragma mark - back 点击
- (void)navBackBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 手电筒按钮点击
- (void)lightButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.torchMode = sender.selected ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
}

- (void)createScanBoxAndRedLine {
    [self.view addSubview:self.scanBoxImgView];
    
    UIImage *redLineImg = [UIImage imageNamed:@"QRCode_scan_redLine"];
    _scanRedLineImgView = [[UIImageView alloc] initWithImage:redLineImg];
    CGFloat delta = 1.5 * [[UIScreen mainScreen] scale];
    _scanRedLineImgView.frame = CGRectMake(delta, SCAN_PADDING, CGRectGetWidth(self.scanBoxImgView.frame) - delta * 2, redLineImg.size.height/2208 *SCREEN_HEIGHT);
    [self.scanBoxImgView addSubview:_scanRedLineImgView];
    
    self.scanRedLineCanAnimation = NO;
    
    
    CGRect scanTipLabelFrame = CGRectMake(0, CGRectGetMaxY(self.scanBoxImgView.frame) + 104/2208.f * SCREEN_HEIGHT, SCREEN_WIDTH, 20);
    UILabel *scanTipLabel = [[UILabel alloc] initWithFrame:scanTipLabelFrame];
    scanTipLabel.font = [UIFont systemFontOfSize:14];
    scanTipLabel.textColor = UIColorFromHex(0x999999);
    
    scanTipLabel.textAlignment = NSTextAlignmentCenter;
    scanTipLabel.text = @"将二维码放入框内，即可自动扫描";
    scanTipLabel.backgroundColor = [UIColor clearColor];
    
    scanTipLabelFrame.size.height = [scanTipLabel sizeThatFits:scanTipLabelFrame.size].height;
    scanTipLabel.frame = scanTipLabelFrame;
    [self.view addSubview:scanTipLabel];
}

- (void)configureDefaultDevice {
    if (_defaultDevice) {
        /**
         typedef NS_ENUM(NSInteger, AVCaptureTorchMode) {
         AVCaptureTorchModeOff  = 0,
         AVCaptureTorchModeOn   = 1,
         AVCaptureTorchModeAuto = 2,
         } NS_AVAILABLE(10_7, 4_0);
         */
        [self.defaultDevice lockForConfiguration:NULL];
        if ([self.defaultDevice isTorchModeSupported:AVCaptureTorchModeOff]) {
            self.defaultDevice.torchMode = AVCaptureTorchModeOff;
        }
        
        if ([self.defaultDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [self.defaultDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }
        [self.defaultDevice unlockForConfiguration];
    }
}

- (void)checkCameraDeviceIsAvailableAndAuthorized {
    if (![ZBarReaderViewController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
        self.isCameraDeviceAvailable = NO;
        
        NSString *message = @"您的设备里没有摄像头，请您更换有摄像头的设备下载艺龙APP进行扫描";
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
        return;
    }
    
    if (iOSVersionLessThan(@"7")) {
        self.isCameraDeviceAvailable = YES;
        return;
    }
    
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted){
                self.isCameraDeviceAvailable = YES;
            }else{
                NSLog(@"not error not granted");
                self.isCameraDeviceAvailable = NO;
            }
            //这一句很是关键，不然在第一次用户授权成功后，红色的扫描线要10s左右才能动起来
            dispatch_async(dispatch_get_main_queue(), ^{
                [self viewDidAppear:NO];
            });
        }];
        
    }else if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized){
        NSLog(@"kABAuthorizationStatusAuthorized");
        self.isCameraDeviceAvailable = YES;
    }
    else if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
        NSLog(@"kABAuthorizationStatusDenied");
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"未开启相机使用权限"
                                                     message:@"请进入“设置-隐私-相机”打开艺龙的相机授权"
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"知道了", nil];
        [av show];
        self.isCameraDeviceAvailable = NO;
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.defaultDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    
    [self createScanViewController];
    [self createScanMaskView];
    [self createNavigationView];
    [self createScanBoxAndRedLine];
    [self configureDefaultDevice];
    
    [self checkCameraDeviceIsAvailableAndAuthorized];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect frame = self.scanRedLineImgView.frame;
    frame.origin.y = SCAN_PADDING;
    self.scanRedLineImgView.frame = frame;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isCameraDeviceAvailable) {
        [self.scanUseZBarVC.readerView start];
        [self.scanUseSystemVC startScanning];
        self.scanRedLineCanAnimation = YES;
        if (self.torchBtn.selected) {
            self.torchMode = AVCaptureTorchModeOn;
        }
        [self beginScanRedLineAnamationWithShouldMoveToBottomFlag:YES];
    }
    else {
        [self.scanUseZBarVC.readerView stop];
        [self.scanUseSystemVC stopScanning];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.isCameraDeviceAvailable) {
        [self.scanUseZBarVC.readerView stop];
        [self.scanUseSystemVC stopScanning];
        self.scanRedLineCanAnimation = NO;
    }
    
    [super viewWillDisappear:animated];
}

#pragma mark - 扫描红线动画
- (void)beginScanRedLineAnamationWithShouldMoveToBottomFlag:(BOOL)bottomFlag {
    if (!self.scanRedLineCanAnimation) {
        return;
    }
    
    CGRect frame = self.scanRedLineImgView.frame;
    frame.origin.y = bottomFlag ? CGRectGetHeight(self.scanBoxImgView.frame) - SCAN_PADDING -  CGRectGetHeight(frame): SCAN_PADDING;

    [UIView animateWithDuration:1.f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.scanRedLineImgView.frame =frame;
    } completion:^(BOOL finished) {
        [self beginScanRedLineAnamationWithShouldMoveToBottomFlag:!bottomFlag];
    }];
}

#pragma mark - accessor
- (UIImageView *)scanBoxImgView {
    if (!_scanBoxImgView) {
        UIImage *scanBoxImg = [UIImage imageNamed:@"QRCode_scan_box"];
        _scanBoxImgView = [[UIImageView alloc] initWithImage:scanBoxImg];
        _scanBoxImgView.frame = CGRectMake(185/1242.f * SCREEN_WIDTH, 486/2208.f * SCREEN_HEIGHT, SCREEN_WIDTH - (185/1242.f * SCREEN_WIDTH)*2.f, SCREEN_WIDTH - (185/1242.f * SCREEN_WIDTH)*2.f);
    }
    return _scanBoxImgView;
}

- (void)setTorchMode:(AVCaptureTorchMode)torchMode {
    _torchMode = torchMode;
    [self.defaultDevice lockForConfiguration:NULL];
    if ([self.defaultDevice isTorchModeSupported:torchMode]) {
        self.defaultDevice.torchMode = torchMode;
    }
    [self.defaultDevice unlockForConfiguration];
}

#pragma mark - QRCodeScanUseZBarVCDelegate
- (void)QRCodeScanUseZBarVC:(QRCodeScanUseZBarVC *)viewController didScanContent:(NSString *)content {
    [self sendScanResultToDelegate:content];
}

#pragma mark - QRCodeScanUseSystemVCDelegate
- (void)QRCodeScanUseSystemVC:(QRCodeScanUseSystemVC *)viewController didScanContent:(NSString *)content {
    [self sendScanResultToDelegate:content];
}

- (void)sendScanResultToDelegate:(NSString *)content {
    if ([self.delegate respondsToSelector:@selector(QRCodeScanViewController:didScanContent:)]) {
        [self.delegate QRCodeScanViewController:self didScanContent:content];
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
