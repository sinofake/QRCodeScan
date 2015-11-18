//
//  ViewController.m
//  SSQRCodeScan
//
//  Created by zhucuirong on 14/12/22.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeScanViewController.h"
#import "QRCodeGenerator.h"

@interface ViewController ()<QRCodeScanViewControllerDelegate>
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)createContents {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.imageView.center = CGPointMake(self.view.center.x, 80 + CGRectGetHeight(self.imageView.frame)/2.f);
    [self.view addSubview:self.imageView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 0, 100, 44);
    button.center = CGPointMake(self.view.center.x, CGRectGetMaxY(self.imageView.frame) + 60);
    [button setTitle:@"扫描" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)scanButtonClick:(UIButton *)sender {
    QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createContents];
    
    self.imageView.image = [QRCodeGenerator qrImageForString:@"darongaixiaohua" imageSize:CGRectGetWidth(self.imageView.frame)];
}

#pragma mark -o QRCodeScanViewControllerDelegate
- (void)QRCodeScanViewController:(QRCodeScanViewController *)viewController didScanContent:(NSString *)content {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [av show];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
