//
//  MainViewController.m
//  QRCode
//
//  Created by zhucuirong on 14/12/11.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "QRCodeViewController.h"
#import "ZBarSDK.h"
#import "QRCodeScanMaskView.h"
#import "SSUtilityFunc.h"
#import "QRCodeUserHelpViewController.h"
#import <AVFoundation/AVFoundation.h>

#define SCAN_PADDING SS_HORIZONTAL_LENGTH(43)


@interface QRCodeViewController ()<ZBarReaderDelegate>
@property (nonatomic, strong) UIImageView *scanRedLine;
@property (nonatomic, strong) UIImageView *scanBox;
@property (nonatomic, strong) UIButton *flashlightBtn;
@property (nonatomic, assign) BOOL scanRedLineIsUp;
@property (nonatomic, assign) BOOL scanRedLineCanAnimation;
@property (nonatomic, assign) BOOL isCameraDeviceAvailable;


@end

@implementation QRCodeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
- (BOOL)prefersStatusBarHidden {
    return YES;
}
#endif

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
    self.readerView.torchMode = 0;
    self.readerDelegate = self;
    self.supportedOrientationsMask = UIInterfaceOrientationPortrait;
    
    //加了这一句，扫描功能一个天上，一个地下
    if ([self.readerView.session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.readerView.session.sessionPreset = AVCaptureSessionPresetHigh;
    }

    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [self.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    //关闭选中二维码时的绿色方框
    self.tracksSymbols = NO;
    
    //父类默认是UIImagePickerControllerCameraFlashModeAuto（自动）
    self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    
    //扫描区域计算
    CGRect scanMaskRect = UIEdgeInsetsInsetRect(self.scanBox.frame, UIEdgeInsetsMake(SCAN_PADDING, SCAN_PADDING, SCAN_PADDING, SCAN_PADDING));
    //默认为 scanCrop = CGRectMake(0, 0, 1, 1);
    self.readerView.scanCrop = [self getScanCropWithScanRect:scanMaskRect andReaderViewBounds:self.readerView.bounds];
    
    //不识别任何码型
    //[self.scanner setSymbology:0 config:ZBAR_CFG_ENABLE to:0];
    //开启ZBAR_QRCODE识别
    //[self.scanner setSymbology:ZBAR_QRCODE config:ZBAR_CFG_ENABLE to:1];
}

- (void)createScanMaskView {
    QRCodeScanMaskView *maskView = [[QRCodeScanMaskView alloc] initWithFrame:self.view.bounds];
    
    maskView.scanAreaRect = UIEdgeInsetsInsetRect(self.scanBox.frame, UIEdgeInsetsMake(SCAN_PADDING, SCAN_PADDING, SCAN_PADDING, SCAN_PADDING));
    maskView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:maskView];
}

- (void)navBackBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)lightButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.readerView.torchMode = sender.selected ? 1 : 0;
}


- (void)createNavigationView {
    CGFloat originY = 20.f;
    UIButton *navBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [navBackBtn setFrame:CGRectMake(0, originY, 80, 44)];
    UIImage *navBackImg = [UIImage imageNamed:@"QRCode_back"];
    [navBackBtn setImage:navBackImg forState:UIControlStateNormal];

    navBackBtn.imageEdgeInsets = [SSUtilityFunc edgeInsetsWithType:SSEdgeInsetsTypeLeft viewSize:navBackBtn.frame.size subsidiaryViewSize:navBackImg.size margin:SS_HORIZONTAL_LENGTH(30)];
    
    [navBackBtn addTarget:self action:@selector(navBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navBackBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, originY, SCREEN_WIDTH - 100 * 2, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = UIColorFromHex(0xffffff);

    titleLabel.text = @"扫一扫";
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat lightBtnWidth = 60.f;
    lightButton.frame = CGRectMake(CGRectGetMaxX(self.scanBox.frame) - lightBtnWidth, originY, lightBtnWidth, 44);
    UIImage *lightImg = [UIImage imageNamed:@"QRCode_light"];
    [lightButton setImage:lightImg forState:UIControlStateNormal];
    
    lightButton.imageEdgeInsets = [SSUtilityFunc edgeInsetsWithType:SSEdgeInsetsTypeRight viewSize:lightButton.frame.size subsidiaryViewSize:lightImg.size margin:SCAN_PADDING];
    
    [lightButton addTarget:self action:@selector(lightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightButton];
    self.flashlightBtn = lightButton;
    self.flashlightBtn.hidden = YES;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        self.flashlightBtn.hidden = NO;
        self.readerView.torchMode = 0;
    }else{
        self.flashlightBtn.hidden = YES;
    }
    
    [device lockForConfiguration:NULL];
    if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    [device unlockForConfiguration];
}

- (void)createScanBoxAndRedLine {
    [self.view addSubview:self.scanBox];
    
    UIImage *redLineImg = [UIImage imageNamed:@"QRCode_scan_redLine"];
    _scanRedLine = [[UIImageView alloc] initWithImage:redLineImg];
    CGFloat delta = 1.5 * [[UIScreen mainScreen] scale];
    _scanRedLine.frame = CGRectMake(delta, SCAN_PADDING, CGRectGetWidth(self.scanBox.frame) - delta * 2, redLineImg.size.height/2208 *SCREEN_HEIGHT);
    [self.scanBox addSubview:_scanRedLine];
    
    self.scanRedLineIsUp = YES;
    self.scanRedLineCanAnimation = NO;
    
    
    CGRect scanTipLabelFrame = CGRectMake(0, CGRectGetMaxY(self.scanBox.frame) + 104/2208.f * SCREEN_HEIGHT, SCREEN_WIDTH, 20);
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
            dispatch_sync(dispatch_get_main_queue(), ^{
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

- (void)createReadFromAlbumsButton {
    UIButton *readFromAlbumsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [readFromAlbumsBtn setTitle:@"从相册读取" forState:UIControlStateNormal];
    readFromAlbumsBtn.frame = CGRectMake(0, 0, 100, 44);
    readFromAlbumsBtn.center = CGPointMake(self.view.center.x, SCREEN_HEIGHT - 100);
    [readFromAlbumsBtn addTarget:self action:@selector(createReadFromAlbumsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readFromAlbumsBtn];
}

- (void)createReadFromAlbumsButtonClick:(UIButton *)sender {
    ZBarReaderController *reader = [ZBarReaderController new];
    //reader.allowsEditing = YES;
    reader.readerDelegate = self;
    //不显示没有扫描到二维码的默认帮助界面
    reader.showsHelpOnFail = NO;
    reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:reader animated:YES completion:^{
        
    }];
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
    
    [self createScanMaskView];
    
    [self createNavigationView];

    [self createScanBoxAndRedLine];
    
    [self checkCameraDeviceIsAvailableAndAuthorized];
    
    [self createReadFromAlbumsButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGRect frame = self.scanRedLine.frame;
    frame.origin.y = SCAN_PADDING;
    self.scanRedLine.frame = frame;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.isCameraDeviceAvailable) {
        self.scanRedLineCanAnimation = YES;
        [self beginScanRedLineAnamationWithShouldMoveToBottomFlag:YES];
        [self.readerView start];

    }
    else {
        [self.readerView stop];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if (self.isCameraDeviceAvailable) {
        [self.readerView stop];
        self.scanRedLineCanAnimation = NO;
    }
}

#pragma mark - 扫描红线动画
- (void)beginScanRedLineAnamationWithShouldMoveToBottomFlag:(BOOL)bottomFlag {
    if (!self.scanRedLineCanAnimation) {
        return;
    }
    
    CGRect frame = self.scanRedLine.frame;
    frame.origin.y = bottomFlag ? CGRectGetHeight(self.scanBox.frame) - SCAN_PADDING -  CGRectGetHeight(frame): SCAN_PADDING;

    [UIView animateWithDuration:1.f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.scanRedLine.frame =frame;
    } completion:^(BOOL finished) {
        [self beginScanRedLineAnamationWithShouldMoveToBottomFlag:!bottomFlag];
    }];
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
        if (self.scanDelegate && [self.scanDelegate respondsToSelector:@selector(QRCodeViewController:didScanContent:)]) {
            [self.scanDelegate QRCodeViewController:self didScanContent:tempStr];
        }
        
        //UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:tempStr delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        //[av show];
    }
}

// called when no barcode is found in an image selected by the user.
// if retry is NO, the delegate *must* dismiss the controller
- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry {
    NSLog(@"reader:%@, retry:%@", reader, retry ? @"yes" : @"no");
    if (self.scanDelegate && [self.scanDelegate respondsToSelector:@selector(QRCodeViewController:didScanContent:)]) {
        [self.scanDelegate QRCodeViewController:self didScanContent:@"未发现二维码"];
    }
}


#pragma mark - accessor

- (UIImageView *)scanBox {
    if (!_scanBox) {
        UIImage *scanBoxImg = [UIImage imageNamed:@"QRCode_scan_box"];
        _scanBox = [[UIImageView alloc] initWithImage:scanBoxImg];
        _scanBox.frame = CGRectMake(185/1242.f * SCREEN_WIDTH, 486/2208.f * SCREEN_HEIGHT, SCREEN_WIDTH - (185/1242.f * SCREEN_WIDTH)*2.f, SCREEN_WIDTH - (185/1242.f * SCREEN_WIDTH)*2.f);
    }
    return _scanBox;
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
